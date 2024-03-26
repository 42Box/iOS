//
//  BoxListView.swift
//  iBox
//
//  Created by 이지현 on 1/3/24.
//

import Combine
import UIKit

import SnapKit

protocol BoxListViewDelegate: AnyObject {
    func didSelectWeb(id: UUID, at url: URL, withName name: String)
    func pushViewController(type: EditType)
    func pushViewController(url: URL?)
    func presentEditBookmarkController(at indexPath: IndexPath)
}

class BoxListView: UIView {
    
    var viewModel: BoxListViewModel?
    private var boxListDataSource: BoxListDataSource!
    weak var delegate: BoxListViewDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private let backgroundView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .tableViewBackgroundColor
    }
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(BoxListCell.self, forCellReuseIdentifier: BoxListCell.reuseIdentifier)
        
        $0.sectionHeaderTopPadding = 0
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .clear
        $0.separatorColor = .clear
        $0.rowHeight = 50
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperty()
        setupHierarchy()
        setupLayout()
        configureDataSource()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        backgroundColor = .backgroundColor
        viewModel = BoxListViewModel()
        tableView.delegate = self
    }
    
    private func setupHierarchy() {
        addSubview(backgroundView)
        backgroundView.addSubview(tableView)
    }
    
    private func setupLayout() {
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        boxListDataSource = BoxListDataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
            guard let self, let viewModel = self.viewModel else { fatalError() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BoxListCell.reuseIdentifier, for: indexPath) as? BoxListCell else { fatalError() }
            cell.setEditButtonHidden(!viewModel.isEditing)
            cell.bindViewModel(viewModel.viewModel(at: indexPath))
            cell.onDelete = { [weak self] in
                guard let self else { return }
                if let currentIndexPath = self.tableView.indexPath(for: cell) {
                    self.viewModel?.deleteBookmark(at: currentIndexPath)
                }
            }
            cell.onEdit = { [weak self] in
                guard let self else { return }
                if let currentIndexPath = self.tableView.indexPath(for: cell) {
                    self.delegate?.presentEditBookmarkController(at: currentIndexPath)
                }
            }

            return cell
        }
        boxListDataSource.delegate = self
    }
    
    private func applySnapshot(with sections: [BoxListSectionViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<BoxListSectionViewModel.ID, BoxListCellViewModel.ID>()
        snapshot.appendSections(sections.map{ $0.id })
        for section in sections {
            snapshot.appendItems(section.boxListCellViewModelsWithStatus.map { $0.id }, toSection: section.id)
        }
        boxListDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func bindViewModel() {
        guard let viewModel else { return }
        let output = viewModel.transform(input: viewModel.input.eraseToAnyPublisher())
        
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .sendBoxList(boxList: let boxList):
                    self?.applySnapshot(with: boxList)
                case .editStatus(isEditing: let isEditing):
                    self?.tableView.setEditing(isEditing, animated: true)
                    guard let snapshot = self?.boxListDataSource.snapshot() else { return }
                    self?.boxListDataSource.applySnapshotUsingReloadData(snapshot)
                case .reloadSections(idArray: let idArray):
                    guard var snapshot = self?.boxListDataSource.snapshot() else { return }
                    snapshot.reloadSections(idArray)
                    self?.boxListDataSource.apply(snapshot)
                case .reloadRows(idArray: let idArray):
                    guard var snapshot = self?.boxListDataSource.snapshot() else { return }
                    snapshot.reloadItems(idArray)
                    self?.boxListDataSource.apply(snapshot)
                }
            }.store(in: &cancellables)
    }
    
}

extension BoxListView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        let line = UIView()
        view.addSubview(line)
        line.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(15)
        }
        view.backgroundColor = .backgroundColor
        line.backgroundColor = .quaternaryLabel
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.7
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel else { return nil }
        let button = FolderButton(isOpen: viewModel.boxList[section].isOpened)
        button.setFolderName(viewModel.boxList[section].name)
        button.tag = section
        
        button.addTarget(self, action: #selector(handleOpenClose), for: .touchUpInside)
        
        return button
    }
    
    @objc private func handleOpenClose(button: FolderButton) {
        guard let viewModel else { return }
        viewModel.input.send(.folderTapped(section: button.tag))
        button.toggleStatus()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellViewModel = viewModel?.boxList[indexPath.section].boxListCellViewModelsWithStatus[indexPath.row] else { return }
        delegate?.didSelectWeb(id: cellViewModel.id, at: cellViewModel.url, withName: cellViewModel.name)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 액션 정의
        let favoriteAction = UIContextualAction(style: .normal, title: "favorite", handler: {(action, view, completionHandler) in
            self.viewModel?.input.send(.setFavorite(indexPath: indexPath))
            completionHandler(true)
        })
        favoriteAction.backgroundColor = .box2
        favoriteAction.image = UIImage(systemName: "heart")
        
        let shareAction = UIContextualAction(style: .normal, title: "share", handler: {(action, view, completionHandler) in
            let cellViewModel = self.viewModel?.viewModel(at: indexPath)
            self.delegate?.pushViewController(url: cellViewModel?.url)
            completionHandler(true)
        })
        shareAction.backgroundColor = .box3
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        let deleteAction = UIContextualAction(style: .normal, title: "delete", handler: {(action, view, completionHandler) in
            self.viewModel?.input.send(.deleteBookmark(indexPath: indexPath))
            completionHandler(true)
        })
        deleteAction.backgroundColor = .systemGray
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        // 스와이프 액션 구성
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction, favoriteAction])
        configuration.performsFirstActionWithFullSwipe = false // 완전히 스와이프했을 때 첫 번째 액션이 자동으로 실행되는 것을 막음
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

extension BoxListView: BoxListDataSourceDelegate {
    func openFolderIfNeeded(_ folderIndex: Int) {        viewModel?.input.send(.openFolderIfNeeded(folderIndex: folderIndex))
    }
    
    func moveCell(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel?.input.send(.moveBookmark(from: sourceIndexPath, to: destinationIndexPath))
    }
    
}

protocol BoxListDataSourceDelegate: AnyObject {
    func moveCell(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    func openFolderIfNeeded(_ folderIndex: Int)
}

class BoxListDataSource: UITableViewDiffableDataSource<BoxListSectionViewModel.ID, BoxListCellViewModel.ID> {
    weak var delegate: BoxListDataSourceDelegate?
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        delegate?.moveCell(at: sourceIndexPath, to: destinationIndexPath)
        
        guard let src = itemIdentifier(for: sourceIndexPath),
            sourceIndexPath != destinationIndexPath else { return }
        
        var snap = snapshot()
        if let dest = itemIdentifier(for: destinationIndexPath) {
            snap.moveItem(src, beforeItem:dest)
        } else {
            snap.deleteItems([src])
            snap.appendItems([src], toSection: snap.sectionIdentifiers[destinationIndexPath.section])
        }
        
        self.apply(snap, animatingDifferences: false)
        
        delegate?.openFolderIfNeeded(destinationIndexPath.section)
    }
}

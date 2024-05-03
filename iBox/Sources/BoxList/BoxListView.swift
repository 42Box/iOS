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
    func deleteFolderinBoxList(at section: Int)
    func editFolderNameinBoxList(at section: Int, currentName: String)
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
        $0.estimatedSectionHeaderHeight = 0
        $0.estimatedSectionFooterHeight = 0
        $0.estimatedRowHeight = 0
    }
    
    private let emptyStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.isHidden = true
    }
    
    private let emptyLabel = UILabel().then {
        $0.text = "폴더가 없습니다"
        $0.font = .emptyLabelFont
        $0.textColor = .secondaryLabel
        $0.textAlignment = .center
    }
    
    private lazy var lightEmptyImages = [
        UIImage(named: "sitting_fox0")?.imageWithColor(.secondaryLabel.resolvedColor(with: .init(userInterfaceStyle: .light))) ?? UIImage(),
        UIImage(named: "sitting_fox1")?.imageWithColor(.secondaryLabel.resolvedColor(with: .init(userInterfaceStyle: .light))) ?? UIImage(),
        UIImage(named: "sitting_fox2")?.imageWithColor(.secondaryLabel.resolvedColor(with: .init(userInterfaceStyle: .light))) ?? UIImage(),
        UIImage(named: "sitting_fox3")?.imageWithColor(.secondaryLabel.resolvedColor(with: .init(userInterfaceStyle: .light))) ?? UIImage()
    ]
    
    private lazy var darkEmptyImages = [
        UIImage(named: "sitting_fox0")?.imageWithColor(.secondaryLabel.resolvedColor(with: .init(userInterfaceStyle: .dark))) ?? UIImage(),
        UIImage(named: "sitting_fox1")?.imageWithColor(.secondaryLabel.resolvedColor(with: .init(userInterfaceStyle: .dark))) ?? UIImage(),
        UIImage(named: "sitting_fox2")?.imageWithColor(.secondaryLabel.resolvedColor(with: .init(userInterfaceStyle: .dark))) ?? UIImage(),
        UIImage(named: "sitting_fox3")?.imageWithColor(.secondaryLabel.resolvedColor(with: .init(userInterfaceStyle: .dark))) ?? UIImage()
    ]
    
    private let emptyImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .secondaryLabel
        $0.animationDuration = 1.5
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperty()
        setupHierarchy()
        setupLayout()
        configureDataSource()
        bindViewModel()
        subscribeToNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if previousTraitCollection?.userInterfaceStyle == .light {
                emptyImageView.animationImages = darkEmptyImages
            } else {
                emptyImageView.animationImages = lightEmptyImages
            }
            if !emptyStackView.isHidden {
                emptyImageView.startAnimating()
            }
        }
    }
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        backgroundColor = .backgroundColor
        viewModel = BoxListViewModel()
        tableView.delegate = self
        
        if UITraitCollection.current.userInterfaceStyle == .light {
            emptyImageView.animationImages = lightEmptyImages
        } else {
            emptyImageView.animationImages = darkEmptyImages
        }
    }
    
    private func setupHierarchy() {
        addSubview(backgroundView)
        backgroundView.addSubview(tableView)
        backgroundView.addSubview(emptyStackView)
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
        
        emptyStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        
        emptyStackView.addArrangedSubview(emptyLabel)
        emptyStackView.addArrangedSubview(emptyImageView)
        
    }
    
    private func configureDataSource() {
        boxListDataSource = BoxListDataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
            guard let self, let viewModel = self.viewModel else { fatalError() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BoxListCell.reuseIdentifier, for: indexPath) as? BoxListCell else { fatalError() }
            cell.setEditButtonHidden(!viewModel.isEditing)
            cell.bindViewModel(viewModel.viewModel(at: indexPath))
            cell.onDelete = { [weak self, weak cell] in
                guard let self = self, let cell = cell else { return }
                if let currentIndexPath = self.tableView.indexPath(for: cell) {
                    self.viewModel?.deleteBookmark(at: currentIndexPath)
                }
            }
            cell.onEdit = { [weak self, weak cell] in
                guard let self = self, let cell = cell else { return }
                if let currentIndexPath = self.tableView.indexPath(for: cell) {
                    self.delegate?.presentEditBookmarkController(at: currentIndexPath)
                }
            }
            
            return cell
        }
        boxListDataSource.defaultRowAnimation = .top
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
                    self?.emptyStackView.isHidden = !boxList.isEmpty
                    if self?.emptyStackView.isHidden == false {
                        self?.emptyImageView.startAnimating()
                    } else {
                        self?.emptyImageView.stopAnimating()
                    }
                case .editStatus(isEditing: let isEditing):
                    self?.tableView.setEditing(isEditing, animated: false)
                    guard let snapshot = self?.boxListDataSource.snapshot() else { return }
                    self?.boxListDataSource.applySnapshotUsingReloadData(snapshot)
                case .reloadSections(idArray: let idArray):
                    guard var snapshot = self?.boxListDataSource.snapshot() else { return }
                    snapshot.reloadSections(idArray)
                    self?.boxListDataSource.apply(snapshot, animatingDifferences: false)
                case .reloadRows(idArray: let idArray):
                    guard var snapshot = self?.boxListDataSource.snapshot() else { return }
                    snapshot.reloadItems(idArray)
                    self?.boxListDataSource.apply(snapshot)
                case .openCloseFolder(boxList: let boxList, section: let section, isEmpty: let isEmpty):
                    self?.applySnapshot(with: boxList)
                    self?.tableView.layoutIfNeeded()
                    if !isEmpty {
                        let indexPath = IndexPath(row: NSNotFound, section: section)
                        self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                }
            }.store(in: &cancellables)
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(dataDidReset), name: .didResetData, object: nil)
    }
    
    @objc private func dataDidReset(notification: NSNotification) {
        viewModel?.input.send(.viewDidLoad)
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
        view.backgroundColor = .tableViewBackgroundColor
        line.backgroundColor = .quaternaryLabel
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.7
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel else { return nil }
        let button = FolderButton(isOpen: viewModel.boxList[section].isOpened)
        button.setFolderName(viewModel.boxList[section].name)
        button.tag = section
        
        // 터치했을 때
        button.addTarget(self, action: #selector(handleOpenClose), for: .touchUpInside)
        // 길게 눌렀을 때
        button.addTarget(self, action: #selector(handleMenu), for: .menuActionTriggered)
        
        let edit = UIAction(title: "폴더 편집", image: UIImage(systemName: "pencil")) { [weak self] _ in
            guard let folderName = self?.viewModel?.boxList[section].name else { return }
            self?.delegate?.editFolderNameinBoxList(at: section, currentName: folderName)
        }
        let delete = UIAction(title: "폴더 삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            self?.delegate?.deleteFolderinBoxList(at: section)
        }
        
        button.menu = UIMenu(options: .displayInline, children: [edit, delete])
        
        return button
    }
    
    @objc private func handleOpenClose(button: FolderButton) {
        guard let viewModel else { return }
        viewModel.input.send(.folderTapped(section: button.tag))
        button.toggleStatus()
        if UserDefaultsManager.isHaptics {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
    @objc private func handleMenu(button: FolderButton) {
        if UserDefaultsManager.isHaptics {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellViewModel = viewModel?.boxList[indexPath.section].boxListCellViewModelsWithStatus[indexPath.row] else { return }
        delegate?.didSelectWeb(id: cellViewModel.id, at: cellViewModel.url, withName: cellViewModel.name)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 액션 정의
        let favoriteAction = UIContextualAction(style: .normal, title: "favorite", handler: { [weak self] (action, view, completionHandler) in
            self?.viewModel?.input.send(.toggleFavorite(indexPath: indexPath))
            if UserDefaultsManager.isHaptics {
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.prepare()
                generator.impactOccurred()
            }
            completionHandler(true)
        })
        favoriteAction.backgroundColor = .box2
        if viewModel?.isFavoriteBookmark(at: indexPath) == true {
            favoriteAction.image = UIImage(systemName: "heart.fill")
        } else {
            favoriteAction.image = UIImage(systemName: "heart")
        }
        
        let shareAction = UIContextualAction(style: .normal, title: "share", handler: {(action, view, completionHandler) in
            let cellViewModel = self.viewModel?.viewModel(at: indexPath)
            self.delegate?.pushViewController(url: cellViewModel?.url)
            if UserDefaultsManager.isHaptics {
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.prepare()
                generator.impactOccurred()
            }
            completionHandler(true)
        })
        shareAction.backgroundColor = .box3
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        let deleteAction = UIContextualAction(style: .normal, title: "delete", handler: {(action, view, completionHandler) in
            self.viewModel?.input.send(.deleteBookmark(indexPath: indexPath))
            if UserDefaultsManager.isHaptics {
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.prepare()
                generator.impactOccurred()
            }
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
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: { [weak self] () -> UIViewController? in
            guard let self = self else { return nil }
            return self.createOrRetrievePreviewController(for: indexPath)
        }, actionProvider: { suggestedActions in
            return self.makeContextMenu(for: indexPath)
        })
        return configuration
    }
    
    private func createOrRetrievePreviewController(for indexPath: IndexPath) -> UIViewController? {
        guard let cellViewModel = self.viewModel?.boxList[indexPath.section].boxListCellViewModelsWithStatus[indexPath.row] else { return nil }
        let id = cellViewModel.id
        let cachedViewController = WebCacheManager.shared.viewControllerForKey(id)

        if let cachedViewController = cachedViewController, cachedViewController.errorViewController?.isHandlingError == nil {
            return cachedViewController
        }

        if cachedViewController?.errorViewController?.isHandlingError ?? false {
            WebCacheManager.shared.removeViewControllerForKey(id)
        }

        let newViewController = createWebViewController(with: cellViewModel)
        WebCacheManager.shared.cacheData(forKey: id, viewController: newViewController)
        return newViewController
    }

    private func createWebViewController(with viewModel: BoxListCellViewModel) -> WebViewController {
        let viewController = WebViewController()
        viewController.selectedWebsite = viewModel.url
        viewController.title = viewModel.name
        viewController.id = viewModel.id
        return viewController
    }
    
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath, let cell = tableView.cellForRow(at: indexPath) else {
                    return nil
        }
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        
        return UITargetedPreview(view: cell, parameters: parameters)
    }
    
    private func makeContextMenu(for indexPath: IndexPath) -> UIMenu {
        let isFavorite = self.viewModel?.isFavoriteBookmark(at: indexPath) ?? false
        let favoriteActionTitle = isFavorite ? "즐겨찾기 해제" : "즐겨찾기로 등록"
        let favoriteActionImage = UIImage(systemName: isFavorite ? "heart.slash.fill" : "heart.fill")
        
        let favoriteAction = UIAction(title: favoriteActionTitle, image: favoriteActionImage) { [weak self] action in
            self?.viewModel?.input.send(.toggleFavorite(indexPath: indexPath))
            if UserDefaultsManager.isHaptics {
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.prepare()
                generator.impactOccurred()
            }
        }
        
        favoriteAction.image?.withTintColor(.box2)
        
        let shareAction = UIAction(title: "공유하기", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] action in
            guard let self = self, let url = self.viewModel?.boxList[indexPath.section].boxListCellViewModelsWithStatus[indexPath.row].url else { return }
            
            if UserDefaultsManager.isHaptics {
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.prepare()
                generator.impactOccurred()
            }
            
            delegate?.pushViewController(url: url)
        }
        
        let editAction = UIAction(title: "북마크 편집", image: UIImage(systemName: "pencil")) { [weak self] action in
            guard let self = self else { return }

            self.delegate?.presentEditBookmarkController(at: indexPath)
            
            if UserDefaultsManager.isHaptics {
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.prepare()
                generator.impactOccurred()
            }
        }
        
        let deleteAction = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] action in
            self?.viewModel?.input.send(.deleteBookmark(indexPath: indexPath))
            if UserDefaultsManager.isHaptics {
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.prepare()
                generator.impactOccurred()
            }
        }
        
        return UIMenu(title: "", children: [favoriteAction, shareAction, editAction, deleteAction])
    }
}

extension BoxListView: BoxListDataSourceDelegate {
    func openFolderIfNeeded(_ folderIndex: Int) {
        viewModel?.input.send(.openFolderIfNeeded(folderIndex: folderIndex))
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
            if sourceIndexPath.section == destinationIndexPath.section && sourceIndexPath.row < destinationIndexPath.row {
                snap.moveItem(src, afterItem: dest)
            } else {
                snap.moveItem(src, beforeItem:dest)
            }
        } else {
            snap.deleteItems([src])
            snap.appendItems([src], toSection: snap.sectionIdentifiers[destinationIndexPath.section])
        }
        
        self.apply(snap, animatingDifferences: false)
        
        delegate?.openFolderIfNeeded(destinationIndexPath.section)
    }
}

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
    func didSelectWeb(at url: URL, withName name: String)
    func pushViewController(type: EditType)
}

class BoxListView: UIView {
    
    var viewModel: BoxListViewModel?
    private var boxListDataSource: UITableViewDiffableDataSource<BoxListSectionViewModel.ID, BoxListCellViewModel.ID>!
    weak var delegate: BoxListViewDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK : - UI Components
    
    private let backgroundView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .tableViewBackgroundColor
    }
    
    private let tableView = UITableView().then {
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
        viewModel?.input.send(.viewDidLoad)
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
        boxListDataSource = UITableViewDiffableDataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
            guard let self, let viewModel = self.viewModel else { fatalError() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BoxListCell.reuseIdentifier, for: indexPath) as? BoxListCell else { fatalError() }
            cell.bindViewModel(viewModel.viewModel(at: indexPath))
            return cell
        }
    }
    
    private func applySnapshot(with: [BoxListSectionViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<BoxListSectionViewModel.ID, BoxListCellViewModel.ID>()
        snapshot.appendSections(with.map{ $0.id })
        for folder in with {
            snapshot.appendItems(folder.boxListCellViewModels.map { $0.id }, toSection: folder.id)
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
        view.backgroundColor = .clear
        line.backgroundColor = .tertiaryLabel
        return view
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.3
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
        guard let viewModel else { return }
        let webUrl = viewModel.boxList[indexPath.section].boxListCellViewModels[indexPath.row].url
        let webName = viewModel.boxList[indexPath.section].boxListCellViewModels[indexPath.row].name
        delegate?.didSelectWeb(at: webUrl, withName: webName)
    }
    
}
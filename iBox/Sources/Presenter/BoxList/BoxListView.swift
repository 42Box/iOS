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
    func didSelectWeb(at url: String, withName name: String)
}

class BoxListView: BaseView {
    var viewModel: BoxListViewModel?
    private var boxListDataSource: UITableViewDiffableDataSource<BoxListSectionViewModel.ID, BoxListCellViewModel.ID>!
    weak var delegate: BoxListViewDelegate?
    
    private var cancellables = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        viewModel = BoxListViewModel()
        
        setupLayout()
        configureDataSource()
        initDataSource()
        bindViewModel()
        viewModel?.input.send(.viewDidLoad)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var backgroundView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
        }
        return view
    }()
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.register(BoxListCell.self, forCellReuseIdentifier: BoxListCell.reuseIdentifier)
        
        tableView.sectionHeaderTopPadding = 0
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 20
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        return tableView
    }()
    
    private func setupLayout() {
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func configureDataSource() {
        boxListDataSource = UITableViewDiffableDataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
            guard let self, let viewModel = self.viewModel else { fatalError() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BoxListCell.reuseIdentifier, for: indexPath) as? BoxListCell else { fatalError() }
            cell.configure(viewModel.viewModel(at: indexPath))
            return cell
        }
    }
    
    private func initDataSource() {
        guard let viewModel else { return }
        var snapshot = NSDiffableDataSourceSnapshot<BoxListSectionViewModel.ID, BoxListCellViewModel.ID>()
        snapshot.appendSections(viewModel.boxList.map{ $0.id })
        for folder in viewModel.boxList {
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
                case .toggleFolder:
                    var snapshot = NSDiffableDataSourceSnapshot<BoxListSectionViewModel.ID, BoxListCellViewModel.ID>()
                    snapshot.appendSections(viewModel.boxList.map{ $0.id })
                    for folder in viewModel.boxList {
                        if folder.isOpen {
                            snapshot.appendItems(folder.boxListCellViewModels.map { $0.id }, toSection: folder.id)
                        }
                    }
                    self?.boxListDataSource.apply(snapshot, animatingDifferences: true)
                }
            }.store(in: &cancellables)
    }
}

//extension BoxListView: UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return viewModel.folderArr.count
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if !viewModel.folderArr[section].isOpened {
//            return 0
//        }
//        return viewModel.folderArr[section].bookmarks.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.selectionStyle = .none
//        cell.backgroundColor = .clear
//        cell.textLabel?.text = viewModel.folderArr[indexPath.section].bookmarks[indexPath.row].name
//        cell.imageView?.image = UIImage(systemName: "ellipsis.rectangle.fill")
//        cell.imageView?.tintColor = ColorPalette.webIconColor
//        return cell
//    }
//    
//}

extension BoxListView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        let line = UIView()
        view.addSubview(line)
        line.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(15)
        }
        view.backgroundColor = ColorPalette.tableViewBackgroundColor
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
        let button = FolderButton(isOpen: viewModel.boxList[section].isOpen)
        button.setFolderName(viewModel.boxList[section].name)
        button.setFolderColor(viewModel.boxList[section].color.toUIColor())
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


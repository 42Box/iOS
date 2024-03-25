//
//  FolderListView.swift
//  iBox
//
//  Created by 최종원 on 3/7/24.
//

import UIKit

class FolderListView: UIView {

    let coreDataManager = CoreDataManager.shared
    
    var folders: [Folder] = []
    var onFolderSelected: ((Folder) -> Void)?

    // MARK: - UI Components

    private let infoLabel = UILabel().then {
        $0.text = "새로운 북마크를 추가할 폴더를 선택해주세요."
        $0.font = UIFont.boldSystemFont(ofSize: 17)
        $0.textColor = .label
        $0.textAlignment = .center
    }
    
    private let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [infoLabel, tableView]).then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        backgroundColor = .systemGroupedBackground
        addSubview(stackView)
        setupLayout()
        setupTableView()
    }

    func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20) // Adjust as necessary
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
        }
    }
    
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(FolderListCell.self, forCellReuseIdentifier: FolderListCell.reuseIdentifier)

        folders = coreDataManager.getFolders()
    }
   
    func reloadFolderList() {
        folders = coreDataManager.getFolders()
        tableView.reloadData()
    }
}

extension FolderListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FolderListCell.reuseIdentifier, for: indexPath) as! FolderListCell
        cell.folderNameLabel.text = folders[indexPath.row].name

        return cell
    }
}

extension FolderListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFolder = folders[indexPath.row]
        onFolderSelected?(selectedFolder)
    }
}

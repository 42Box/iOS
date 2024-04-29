//
//  FolderListView.swift
//  iBox
//
//  Created by 최종원 on 3/7/24.
//

import UIKit

protocol FolderListViewDelegate: AnyObject {
    func selectFolder(_ folder: Folder, at index: Int)
}

class FolderListView: UIView {
    weak var delegate: FolderListViewDelegate?

    let coreDataManager = CoreDataManager.shared
    var folders: [Folder] = []
    var selectedFolderId: UUID?

    // MARK: - UI Components

    private let infoLabel = UILabel().then {
        $0.text = "새로운 북마크를 추가할 폴더를 선택해주세요."
        $0.font = .barItemFont
        $0.textColor = .label
        $0.textAlignment = .center
    }
    
    private let tableView = UITableView().then {
        $0.backgroundColor = .clear
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperty()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    func setupProperty() {
        backgroundColor = .systemGroupedBackground
        setupTableView()
    }

    func setupHierarchy() {
        addSubview(stackView)
    }
    
    func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20) // Adjust as necessary
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
        }
        
        stackView.addArrangedSubview(infoLabel)
        stackView.addArrangedSubview(tableView)
    }
    
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(FolderListCell.self, forCellReuseIdentifier: FolderListCell.reuseIdentifier)
    }
   
    func reloadFolderList() {
        tableView.reloadData()
    }
}

extension FolderListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FolderListCell.reuseIdentifier, for: indexPath) as! FolderListCell
        let folder = folders[indexPath.row]

        let isSelectedFolder = selectedFolderId == folder.id
        cell.configureWith(folder: folder, isSelected: isSelectedFolder)

        return cell
    }
}

extension FolderListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFolder = folders[indexPath.row]
        UserDefaultsManager.selectedFolderId = selectedFolder.id
        delegate?.selectFolder(selectedFolder, at: indexPath.row)
    }
}

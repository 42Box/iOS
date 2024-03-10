//
//  FolderListView.swift
//  iBox
//
//  Created by 최종원 on 3/7/24.
//

import UIKit

class FolderListView: UIView {

    // CoreDataManager
    let coreDataManager = CoreDataManager.shared
    
    // 폴더 엔티티를 저장할 배열
    var folders: [Folder] = []
    var onFolderSelected: ((Folder) -> Void)?


    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 북마크를 추가할 폴더를 선택해주세요."
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [infoLabel, tableView])
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
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
    
    var num = 0
    
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(FolderListCell.self, forCellReuseIdentifier: FolderListCell.reuseIdentifier)

        // 모든 폴더 가져오기
        folders = coreDataManager.getFolders()
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
        // 선택시 로직
        print("항목 \(indexPath.row) 선택됨")
        let selectedFolder = folders[indexPath.row]
        onFolderSelected?(selectedFolder)
    }
    
}

//
//  EditFolderView.swift
//  iBox
//
//  Created by jiyeon on 2/29/24.
//

import UIKit

class EditFolderView: UIView {
    
    var viewModel: EditFolderViewModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let backgroundView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .tableViewBackgroundColor
    }
    
    private let tableView = UITableView().then {
        $0.register(FolderCell.self, forCellReuseIdentifier: FolderCell.reuserIdentifier)
        
        $0.backgroundColor = .clear
        $0.rowHeight = 50
        $0.separatorInset = .init(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureDataSource()
        setupProperty()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func configureDataSource() {
        tableView.dataSource = self
    }
    
    private func setupProperty() {
        backgroundColor = .backgroundColor
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
    
}

extension EditFolderView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.folderCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel else { fatalError() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FolderCell.reuserIdentifier, for: indexPath) as? FolderCell else { fatalError() }
        cell.configure(viewModel.folderName(at: indexPath))
        return cell
    }
    
    
}

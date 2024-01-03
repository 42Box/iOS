//
//  BoxListView.swift
//  iBox
//
//  Created by 이지현 on 1/3/24.
//

import UIKit

class BoxListView: UIView {
    
    let folders = ["folder1", "folder2", "folder3"]
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 10))
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 20
        tableView.backgroundColor = ColorPalette.tableViewBackgroundColor
        tableView.separatorColor = .secondaryLabel
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorPalette.backgroundColor
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
}

extension BoxListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = folders[indexPath.row]
        cell.backgroundColor = .clear
        return cell
    }
    
}

extension BoxListView: UITableViewDelegate {
    
}

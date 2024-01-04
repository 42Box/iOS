//
//  BoxListView.swift
//  iBox
//
//  Created by 이지현 on 1/3/24.
//

import UIKit
import SnapKit

class BoxListView: UIView {
    
    var folderArr = [
        Folder(name: "folder1", webs: [
            Web(name: "42 Intra", url: "https://profile.intra.42.fr/"),
            Web(name: "42Where", url: "https://where42.kr/")
        ]),
        Folder(name: "folder2", webs: [Web(name: "Cabi", url: "https://cabi.42seoul.io/")]),
        Folder(name: "folder3", webs: [])
    ]
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return folderArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !folderArr[section].isExpanded {
            return 0
        }
        return folderArr[section].webs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = folderArr[indexPath.section].webs[indexPath.row].name
        return cell
    }
    
}

extension BoxListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        button.setTitle(folderArr[section].name, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = ColorPalette.tableViewBackgroundColor
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.tag = section
        
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        
        return button
    }
    
    @objc private func handleExpandClose(button: UIButton) {
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        for row in folderArr[section].webs.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        folderArr[section].isExpanded.toggle()
        
        if folderArr[section].isExpanded {
            tableView.insertRows(at: indexPaths, with: .fade)
        } else {
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
}


//
//  BoxListView.swift
//  iBox
//
//  Created by 이지현 on 1/3/24.
//

import UIKit

import SnapKit

protocol BoxListViewDelegate: AnyObject {
    func didSelectWeb(at url: String, withName name: String)
}

class BoxListView: UIView {
    weak var delegate: BoxListViewDelegate?
    
    var folderArr = [
        Folder(name: "기본 폴더", color: .gray, webs: [
            Web(name: "42 Intra", url: "https://profile.intra.42.fr/"),
            Web(name: "42Where", url: "https://where42.kr/"),
            Web(name: "42Stat", url: "https://stat.42seoul.kr/"),
            Web(name: "집현전", url: "https://42library.kr/")
        ]),
        Folder(name: "새 폴더", color: .green, webs: [Web(name: "Cabi", url: "https://cabi.42seoul.io/")], isOpened: false),
        Folder(name: "새 폴더(2)", color: .yellow, webs: [Web(name: "24HANE", url: "https://24hoursarenotenough.42seoul.kr/")], isOpened: false)
    ]
    
    private lazy var backgroundView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = ColorPalette.tableViewBackgroundColor
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
        }
        return view
    }()
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.sectionHeaderTopPadding = 0
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 20
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
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
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
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
        if !folderArr[section].isOpened {
            return 0
        }
        return folderArr[section].webs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.textLabel?.text = folderArr[indexPath.section].webs[indexPath.row].name
        cell.imageView?.image = UIImage(systemName: "ellipsis.rectangle.fill")
        cell.imageView?.tintColor = ColorPalette.webIconColor
        return cell
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
        let button = FolderButton(isOpen: folderArr[section].isOpened)
        button.setFolderName(folderArr[section].name)
        button.setFolderColor(folderArr[section].color.toUIColor())
        button.tag = section
        
        button.addTarget(self, action: #selector(handleOpenClose), for: .touchUpInside)
        
        return button
    }
    
    @objc private func handleOpenClose(button: FolderButton) {
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        for row in folderArr[section].webs.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        folderArr[section].isOpened.toggle()
        button.toggleStatus()
        
        if folderArr[section].isOpened {
            tableView.insertRows(at: indexPaths, with: .fade)
        } else {
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webUrl = folderArr[indexPath.section].webs[indexPath.row].url
        let webName = folderArr[indexPath.section].webs[indexPath.row].name
        delegate?.didSelectWeb(at: webUrl, withName: webName)
    }
}


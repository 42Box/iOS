//
//  EditView.swift
//  iBox
//
//  Created by jiyeon on 2/29/24.
//

import UIKit

import SnapKit

class EditView: BaseView {
    
    var delegate: EditViewDelegate?
    
    private let editItems = [
        EditItem(imageString: "folder.fill", title: "폴더 편집"),
        EditItem(imageString: "bookmark.fill", title: "북마크 편집")
    ]
    
    // MARK: - UI Components
    
    let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(EditCell.self, forCellReuseIdentifier: EditCell.reuseIdentifier)
        $0.separatorStyle = .none
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
    
    private func setupProperty() {
        backgroundColor = .backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupHierarchy() {
        addSubview(tableView)
    }
    
    private func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
}

extension EditView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.pushViewController(index: indexPath.row)
    }
    
}

extension EditView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditCell.reuseIdentifier) as? EditCell else { return UITableViewCell() }
        cell.bind(editItems[indexPath.row])
        return cell
    }
    
}

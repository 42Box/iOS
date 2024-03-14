//
//  FolderCell.swift
//  iBox
//
//  Created by 이지현 on 3/11/24.
//

import UIKit

class EditFolderCell: UITableViewCell {
    static let reuserIdentifier = "folderCell"
    
    var onDelete: (() -> Void)?
    var onEdit: (() -> Void)?
    
    private let folderView = FolderView()
    
    private let editButton = UIButton().then{
        $0.configuration = .plain()
        $0.configuration?.image = UIImage(systemName: "ellipsis.circle")?.withTintColor(.box, renderingMode: .alwaysOriginal)
        
        $0.showsMenuAsPrimaryAction = true
    }
    
    private lazy var nameEditAction = UIAction(title: "이름 변경", image: UIImage(systemName: "pencil")) {[weak self] _ in
        self?.onEdit?()
    }
    
    private lazy var deleteAction = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
        self?.onDelete?()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupProperty()
        setupHierarchy()
        setupLayout()
        configureEditMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProperty() {
        backgroundColor = .tableViewBackgroundColor
        selectionStyle = .none
    }
    
    private func setupHierarchy() {
        contentView.addSubview(folderView)
        folderView.addSubview(editButton)
    }
    
    private func setupLayout() {
        folderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        editButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
    }
    
    private func configureEditMenu() {
        editButton.menu = UIMenu(options: .displayInline, children: [nameEditAction, deleteAction])
    }
    
    func configure(_ name: String) {
        folderView.setFolderName(name)
    }

}

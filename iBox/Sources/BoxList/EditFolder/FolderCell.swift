//
//  FolderCell.swift
//  iBox
//
//  Created by 이지현 on 3/11/24.
//

import UIKit

class FolderCell: UITableViewCell {
    static let reuserIdentifier = "folderCell"
    
    private let folderView = FolderView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupProperty()
        setupHierarchy()
        setupLayout()
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
    }
    
    private func setupLayout() {
        folderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(_ name: String) {
        folderView.setFolderName(name)
    }

}

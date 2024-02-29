//
//  FolderButton.swift
//  iBox
//
//  Created by 이지현 on 1/4/24.
//

import UIKit

import SnapKit

class FolderButton: UIButton {
    private var isOpen: Bool = true
    
    private lazy var folderImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "folder.fill")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var folderNameLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var openCloseImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .tertiaryLabel
        imageView.image = isOpen ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
        return imageView
    }()
    
    init(isOpen: Bool) {
        self.isOpen = isOpen
        super.init(frame: .zero)
        backgroundColor = .tableViewBackgroundColor
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(folderImageView)
        folderImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
            make.leading.equalToSuperview().offset(20)
        }
        
        addSubview(folderNameLabel)
        folderNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(folderImageView.snp.trailing).offset(10)
        }
        
        addSubview(openCloseImageView)
        openCloseImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func setFolderName(_ name: String) {
        folderNameLabel.text = name
    }
    
    func setFolderColor(_ color: UIColor) {
        folderImageView.tintColor = color
    }
    
    func toggleStatus() {
        isOpen = !isOpen
        openCloseImageView.image = isOpen ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
    }
}

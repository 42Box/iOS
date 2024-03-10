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
    
    // MARK: - UI Components
    
    private let folderImageView = UIImageView().then {
        $0.image = UIImage(systemName: "folder.fill")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .gray
    }
    
    private let folderNameLabel = UILabel().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    private let openCloseImageView = UIImageView().then {
        $0.tintColor = .tertiaryLabel
    }
    
    // MARK: - Initializer
    
    init(isOpen: Bool) {
        self.isOpen = isOpen
        super.init(frame: .zero)
        setupProperty()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        backgroundColor = .tableViewBackgroundColor
        openCloseImageView.image = isOpen ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
    }
    
    private func setupHierarchy() {
        addSubview(folderImageView)
        addSubview(folderNameLabel)
        addSubview(openCloseImageView)
    }
    
    private func setupLayout() {
        folderImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
            make.leading.equalToSuperview().offset(20)
        }
        
        folderNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(folderImageView.snp.trailing).offset(10)
        }
        
        openCloseImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func setFolderName(_ name: String) {
        folderNameLabel.text = name
    }
    
    func toggleStatus() {
        isOpen = !isOpen
        openCloseImageView.image = isOpen ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
    }
}

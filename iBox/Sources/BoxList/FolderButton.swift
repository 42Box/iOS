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
    
    private let folderView = FolderView().then {
        $0.isUserInteractionEnabled = false
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
        openCloseImageView.image = isOpen ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.right")
    }
    
    private func setupHierarchy() {
        addSubview(folderView)
        addSubview(openCloseImageView)
    }
    
    private func setupLayout() {
        openCloseImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        folderView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.equalTo(openCloseImageView.snp.leading)
        }
    }
    
    func setFolderName(_ name: String) {
        folderView.setFolderName(name)
    }
    
    func toggleStatus() {
        isOpen = !isOpen
        openCloseImageView.image = isOpen ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.right")
    }
}

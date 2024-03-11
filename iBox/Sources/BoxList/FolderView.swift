//
//  FolderView.swift
//  iBox
//
//  Created by 이지현 on 3/11/24.
//

import UIKit

class FolderView: UIView {
    private let folderImageView = UIImageView().then {
        $0.image = UIImage(systemName: "folder.fill")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .gray
    }
    
    private let folderNameLabel = UILabel().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    init() {
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
    }
    
    private func setupHierarchy() {
        addSubview(folderImageView)
        addSubview(folderNameLabel)
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
    }
    
    func setFolderName(_ name: String) {
        folderNameLabel.text = name
    }
}



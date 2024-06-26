//
//  FolderListCell.swift
//  iBox
//
//  Created by 최종원 on 3/7/24.
//

import UIKit

class FolderListCell: UITableViewCell {
    
    static let reuseIdentifier = "ListCell"
    
    // MARK: - UI Components

    private let folderImageView = UIImageView().then {
        $0.image = UIImage(systemName: "folder.fill")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .gray
    }
    
    let folderNameLabel = UILabel().then {
        $0.textColor = .label
        $0.font = .cellTitleFont
    }
    
    private let checkImageView = UIImageView().then {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold, scale: .default)
        $0.image = UIImage(systemName: "checkmark", withConfiguration: config)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .box
        $0.isHidden = true
    }

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupProperty()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        self.backgroundColor = .clear
    }

    private func setupHierarchy() {
        self.contentView.addSubview(folderImageView)
        self.contentView.addSubview(folderNameLabel)
        self.contentView.addSubview(checkImageView)
    }
    
    func setupLayout() {
        folderImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(30)
            make.top.greaterThanOrEqualToSuperview().offset(10)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        checkImageView.snp.makeConstraints { make in
             make.centerY.equalToSuperview()
             make.trailing.equalToSuperview().offset(-20)
         }
        
        folderNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(folderImageView.snp.trailing).offset(10)
            make.trailing.equalTo(checkImageView.snp.leading).offset(-10)
            make.top.greaterThanOrEqualToSuperview().offset(10)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    
    func configureWith(folder: Folder, isSelected: Bool) {
        folderNameLabel.text = folder.name
        checkImageView.isHidden = !isSelected
    }
    
}

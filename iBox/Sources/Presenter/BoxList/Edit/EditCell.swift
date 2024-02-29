//
//  EditCell.swift
//  iBox
//
//  Created by jiyeon on 2/29/24.
//

import UIKit

import SnapKit

class EditCell: UITableViewCell {
    
    static let reuseIdentifier = "EditCell"
    
    // MARK: - UI Components
    
    private let iconView = UIImageView().then {
        $0.tintColor = .label
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .label
    }
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupProperty()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    private func setupHierarchy() {
        addSubview(iconView)
        addSubview(titleLabel)
    }
    
    private func setupLayout() {
        iconView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.leading.equalToSuperview().inset(30)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints{ make in
            make.leading.equalTo(iconView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    func bind(_ editItem: EditItem) {
        iconView.image = UIImage(systemName: editItem.imageString)
        titleLabel.text = editItem.title
    }
    
}

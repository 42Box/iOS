//
//  ThemeCell.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import UIKit

class ThemeCell: UITableViewCell {
    
    static let reuseIdentifier = "ThemeCell"
    
    // MARK: - UI Components
    
    let themeImageView = UIImageView().then {
        $0.tintColor = .label
    }
    
    let titleLabel = UILabel().then {
        $0.font = .cellTitleFont
    }
    
    let selectButton = UIButton().then {
        $0.configuration = .plain()
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
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func setupHierarchy() {
        addSubview(themeImageView)
        addSubview(titleLabel)
        addSubview(selectButton)
    }
    
    private func setupLayout() {
        themeImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(23)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(themeImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        
        selectButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
    
    func bind(_ theme: Theme) {
        titleLabel.text = theme.toString()
        themeImageView.image = UIImage(systemName: theme.toImageString())
    }
    
    func setupSelectButton(_ selected: Bool) {
        if selected {
            selectButton.configuration?.image = UIImage(systemName: "circle.inset.filled")
            selectButton.tintColor = .box2
        } else {
            selectButton.configuration?.image = UIImage(systemName: "circle")
            selectButton.tintColor = .gray
        }
    }
    
}

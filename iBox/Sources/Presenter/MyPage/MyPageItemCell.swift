//
//  MyPageItemCell.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import UIKit

import SnapKit

class MyPageItemCell: UITableViewCell {
    
    static let reuseIdentifier = "MyPageItemCell"
    private var viewModel: MyPageCellViewModel?
    
    // MARK: - UI Components
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .gray
    }
    
    let switchControl = UISwitch().then {
        $0.onTintColor = .box2
    }
    
    let chevronButton = UIButton().then {
        $0.configuration = .plain()
        $0.configuration?.image = UIImage(systemName: "chevron.right")
        $0.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 10, weight: .bold)
        $0.tintColor = .systemGray3
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(switchControl)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(chevronButton)
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        switchControl.snp.makeConstraints {
            $0.right.equalToSuperview().inset(30)
            $0.centerY.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(30)
            $0.centerY.equalToSuperview()
        }
        
        chevronButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Bind ViewModel
    
    func bindViewModel(_ viewModel: MyPageCellViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        
        descriptionLabel.isHidden = true
        switchControl.isHidden = true
        chevronButton.isHidden = true
        
        if let description = viewModel.description {
            descriptionLabel.text = description
            descriptionLabel.isHidden = false
        } else if let flag = viewModel.flag {
            switchControl.isOn = flag
            switchControl.isHidden = false
        } else {
            chevronButton.isHidden = false
        }
    }
    
}

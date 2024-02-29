//
//  MyPageItemCell.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import UIKit

import SnapKit

class MyPageItemCell: UITableViewCell, BaseViewProtocol {
    
    static let reuseIdentifier = "MyPageItemCell"
    private var viewModel: MyPageCellViewModel?
    
    // MARK: - UI
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
    }
    
    let stackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .gray
    }
    
    let controlSwitch = UISwitch().then {
        $0.tintColor = .box3
    }
    
    let chevronButton = UIButton().then {
        $0.configuration = .plain()
        $0.configuration?.image = UIImage(systemName: "chevron.right")
        $0.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 10, weight: .bold)
        $0.tintColor = .systemGray3
    }
    
    // MARK: - initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - BaseViewProtocol
    
    func configureUI() {
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(stackView)
        stackView.addArrangedSubview(controlSwitch)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(chevronButton)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(30)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Bind ViewModel
    
    func bindViewModel(_ viewModel: MyPageCellViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        
        descriptionLabel.isHidden = true
        controlSwitch.isHidden = true
        chevronButton.isHidden = true
        
        if let description = viewModel.description {
            descriptionLabel.text = viewModel.description
            descriptionLabel.isHidden = false
        } else if let flag = viewModel.flag {
            controlSwitch.isOn = flag
            controlSwitch.isHidden = false
        } else {
            chevronButton.isHidden = false
        }
    }
    
}

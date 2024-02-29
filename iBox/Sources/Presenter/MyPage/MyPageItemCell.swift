//
//  MyPageItemCell.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import UIKit

import SnapKit

class MyPageItemCell: UITableViewCell, BaseViewProtocol {
    
    // MARK: - UI
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .gray
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
        selectionStyle = .none // 셀 선택했을 때 회색으로 변하는 것 비활성화
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - BaseViewProtocol
    
    func configureUI() {
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(chevronButton)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        chevronButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.right.equalTo(chevronButton.snp.left).offset(-10)
            $0.centerY.equalToSuperview()
        }
    }
    
}

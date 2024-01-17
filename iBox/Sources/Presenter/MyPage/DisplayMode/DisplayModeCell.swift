//
//  DisplayModeCell.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import UIKit

class DisplayModeCell: UITableViewCell, BaseViewProtocol {
    
    // MARK: - UI
    
    let displayModeImageView = UIImageView().then {
        $0.tintColor = .black
    }
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
    }
    
    let selectButton = UIButton().then {
        $0.configuration = .plain()
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
        addSubview(displayModeImageView)
        addSubview(titleLabel)
        addSubview(selectButton)
        
        displayModeImageView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(23)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(displayModeImageView.snp.right).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        selectButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
    }
    
    // MARK: - functions
    
    func bind(_ item: DisplayModeItem) {
        titleLabel.text = item.title
        displayModeImageView.image = item.image
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
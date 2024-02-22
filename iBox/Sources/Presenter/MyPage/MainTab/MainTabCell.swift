//
//  MainTabCell.swift
//  iBox
//
//  Created by jiyeon on 2/22/24.
//

import UIKit

import SnapKit

class MainTabCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "MainTabCell"
    
    // MARK: - UI Components
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
    }
    
    let selectButton = UIButton().then {
        $0.configuration = .plain()
    }
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupLayout() {
        selectionStyle = .none
        
        addSubview(titleLabel)
        addSubview(selectButton)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        selectButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
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

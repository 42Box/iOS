//
//  FolderListCell.swift
//  iBox
//
//  Created by 최종원 on 3/7/24.
//

import UIKit

class FolderListCell: UITableViewCell {
    
    static let reuseIdentifier = "ListCell"

    let testLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.contentView.addSubview(testLabel)
        
        setupLayout()
        
    }
    
    func setupLayout() {
       testLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20) // 왼쪽 여백
            make.trailing.equalToSuperview().offset(-20) // 오른쪽 여백
            make.centerY.equalToSuperview() // 세로 중앙 정렬
        }
        
    }
    
}

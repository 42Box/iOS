//
//  ProfileView.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import UIKit

class ProfileView: BaseView {
    
    let profileView = UIView()/*.then {
        $0.backgroundColor = .systemPink
    }*/
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.crop.circle")
        $0.tintColor = .box
    }
    
    let profileLabel = UILabel().then {
        $0.text = "예시입니당"
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
    }
    
    let chevronButton = UIButton().then {
        $0.configuration = .plain()
        $0.configuration?.image = UIImage(systemName: "chevron.right")
        $0.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 15, weight: .bold)
        $0.tintColor = .systemGray3
    }

    let tableView = UITableView().then {
        $0.register(ProfileItemCell.self, forCellReuseIdentifier: "ProfileItemCell")
    }
    
    override func configureUI() {
        addSubview(profileView)
        profileView.addSubview(profileImageView)
        profileView.addSubview(profileLabel)
        profileView.addSubview(chevronButton)
        addSubview(tableView)
        
        profileView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(90)
        }
        
        profileImageView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        
        profileLabel.snp.makeConstraints {
            $0.left.equalTo(profileImageView.snp.right).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        chevronButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(10)
            $0.left.bottom.right.equalToSuperview()
        }
    }
    
}

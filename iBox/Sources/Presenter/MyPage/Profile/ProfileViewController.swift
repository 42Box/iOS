//
//  ProfileViewController.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import UIKit

class ProfileViewController: BaseNavigationBarViewController<ProfileView> {
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar() // 얘는 왜 여기에 적어줘야 전부 다 적용이 될까 ..? 🧐
    }
    
    // MARK: - BaseNavigationBarViewControllerProtocol
    
    override func setupNavigationBar() {
        setNavigationBarTitleLabelText("내 정보 수정하기")
        setNavigationBarTitleLabelFont(.systemFont(ofSize: 17, weight: .semibold))
        setNavigationBarBackButtonHidden(false)
    }
    
}

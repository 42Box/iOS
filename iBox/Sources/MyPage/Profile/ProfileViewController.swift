//
//  ProfileViewController.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import UIKit

class ProfileViewController: BaseViewController<ProfileView>, BaseViewControllerProtocol {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        checkLoginStatusAndStartAuthIfNeeded()
    }
    
    // MARK: - BaseViewControllerProtocol
    
    func setupNavigationBar() {
        setNavigationBarTitleLabelText("내 정보")
        setNavigationBarTitleLabelFont(.systemFont(ofSize: 17, weight: .semibold))
        setNavigationBarBackButtonHidden(false)
    }

    func checkLoginStatusAndStartAuthIfNeeded() {
        // 로그인 상태를 확인하는 로직 (여기서는 예시로 간단하게 처리)
        let isLoggedIn = false // 실제 로그인 상태를 확인하는 코드로 대체해야 함
        
        if !isLoggedIn {
            let oauthManager = OAuthManager()
            oauthManager.startAuth()
            // 로그인 페이지나 인증 플로우로 사용자를 리디렉션
        } else {
            // 사용자가 이미 로그인되어 있을 경우, 프로필 페이지 로직을 계속 진행
        }
    }

}

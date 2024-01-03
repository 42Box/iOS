//
//  ProfileViewController.swift
//  iBox
//
//  Created by 이지현 on 12/27/23.
//

import UIKit

class ProfileViewController: BaseNavigationBarViewController<ProfileView> {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavigationBar() {
        setNavigationBarTitleLabelText("Profile")
    }
    
}

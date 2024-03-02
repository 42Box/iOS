//
//  EditBookmarkViewController.swift
//  iBox
//
//  Created by jiyeon on 2/29/24.
//

import UIKit

class EditBookmarkViewController: BaseNavigationBarViewController<EditBookmarkView> {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    // MARK: - BaseNavigationBarViewControllerProtocol
    
    override func setupNavigationBar() {
        setNavigationBarTitleLabelText("북마크 편집")
        setNavigationBarTitleLabelFont(.systemFont(ofSize: 17, weight: .semibold))
        setNavigationBarBackButtonHidden(false)
    }
    
}

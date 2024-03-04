//
//  EditBookmarkViewController.swift
//  iBox
//
//  Created by jiyeon on 2/29/24.
//

import UIKit

class EditBookmarkViewController: BaseViewController<EditBookmarkView>, BaseViewControllerProtocol {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    // MARK: - BaseViewControllerProtocol
    
    func setupNavigationBar() {
        setNavigationBarTitleLabelText("북마크 편집")
        setNavigationBarTitleLabelFont(.systemFont(ofSize: 17, weight: .semibold))
        setNavigationBarBackButtonHidden(false)
    }
    
}

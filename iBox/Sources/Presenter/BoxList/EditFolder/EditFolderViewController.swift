//
//  EditFolderViewController.swift
//  iBox
//
//  Created by jiyeon on 2/29/24.
//

import UIKit

class EditFolderViewController: BaseNavigationBarViewController<EditFolderView> {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    // MARK: - BaseNavigationBarViewControllerProtocol
    
    override func setupNavigationBar() {
        setNavigationBarTitleLabelText("폴더 편집")
        setNavigationBarTitleLabelFont(.systemFont(ofSize: 17, weight: .semibold))
        setNavigationBarBackButtonHidden(false)
    }
    
}

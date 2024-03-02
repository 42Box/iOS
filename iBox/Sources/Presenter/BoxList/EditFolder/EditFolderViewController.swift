//
//  EditFolderViewController.swift
//  iBox
//
//  Created by jiyeon on 2/29/24.
//

import UIKit

class EditFolderViewController: BaseViewController<EditFolderView>, BaseViewControllerProtocol {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    // MARK: - BaseNavigationBarViewControllerProtocol
    
    func setupNavigationBar() {
        setNavigationBarTitleLabelText("폴더 편집")
        setNavigationBarTitleLabelFont(.systemFont(ofSize: 17, weight: .semibold))
        setNavigationBarBackButtonHidden(false)
    }
    
}

//
//  GuideViewController.swift
//  iBox
//
//  Created by jiyeon on 4/22/24.
//

import UIKit

class GuideViewController: BaseViewController<GuideView>, BaseViewControllerProtocol {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        guard let contentView = contentView as? GuideView else { return }
        contentView.guideUrl = URL(string: "https://42box.github.io/iOSIntroduction")
    }
    
    // MARK: - BaseViewControllerProtocol
    
    func setupNavigationBar() {
        setNavigationBarTitleLabelText("앱 소개")
        setNavigationBarTitleLabelFont(.subTitlefont)
        setNavigationBarBackButtonHidden(false)
    }
    
}

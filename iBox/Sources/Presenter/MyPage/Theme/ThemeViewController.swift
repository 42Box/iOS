//
//  ThemeViewController.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import UIKit

class ThemeViewController: BaseNavigationBarViewController<ThemeView> {
    
    // MARK: - properties
    
    private let viewModel = ThemeViewModel()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        guard let contentView = contentView as? ThemeView else { return }
        contentView.bineViewModel(viewModel)
    }
    
    // MARK: - BaseNavigationBarViewControllerProtocol
    
    override func setupNavigationBar() {
        setNavigationBarTitleLabelText("다크 모드 설정")
        setNavigationBarTitleLabelFont(.systemFont(ofSize: 17, weight: .semibold))
        setNavigationBarBackButtonHidden(false)
    }
    
}

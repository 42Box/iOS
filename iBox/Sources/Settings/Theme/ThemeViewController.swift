//
//  ThemeViewController.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import UIKit

class ThemeViewController: BaseViewController<ThemeView>, BaseViewControllerProtocol {
    
    private let viewModel = ThemeViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        guard let contentView = contentView as? ThemeView else { return }
        contentView.bineViewModel(viewModel)
    }
    
    // MARK: - BaseViewControllerProtocol
    
    func setupNavigationBar() {
        setNavigationBarTitleLabelText("다크 모드 설정")
        setNavigationBarTitleLabelFont(.subTitlefont)
        setNavigationBarBackButtonHidden(false)
    }
    
}

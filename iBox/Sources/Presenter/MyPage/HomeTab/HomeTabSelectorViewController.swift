//
//  HomeTabSelectorViewwController.swift
//  iBox
//
//  Created by jiyeon on 2/22/24.
//

import UIKit

class HomeTabSelectorViewController: BaseViewController<HomeTabSelectorView>, BaseViewControllerProtocol {
    
    private let viewModel = HomeTabSelectorViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        guard let contentView = contentView as? HomeTabSelectorView else { return }
        contentView.bindViewModel(viewModel)
    }
    
    // MARK: - BaseViewControllerProtocol
    
    func setupNavigationBar() {
        setNavigationBarTitleLabelText("홈화면 설정하기")
        setNavigationBarTitleLabelFont(.systemFont(ofSize: 17, weight: .semibold))
        setNavigationBarBackButtonHidden(false)
    }
    
}

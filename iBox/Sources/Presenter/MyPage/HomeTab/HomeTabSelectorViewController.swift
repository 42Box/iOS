//
//  HomeTabSelectorViewwController.swift
//  iBox
//
//  Created by jiyeon on 2/22/24.
//

import UIKit

class HomeTabSelectorViewController: BaseNavigationBarViewController<HomeTabSelectorView> {
    
    // MARK: - Properties
    
    private let viewModel = HomeTabSelectorViewModel()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar() // 얘는 왜 여기에 적어줘야 전부 다 적용이 될까 ..? 🧐
        
        guard let contentView = contentView as? HomeTabSelectorView else { return }
        contentView.bindViewModel(viewModel)
    }
    
    // MARK: - BaseNavigationBarViewControllerProtocol
    
    override func setupNavigationBar() {
        setNavigationBarTitleLabelText("첫 화면 설정하기")
        setNavigationBarTitleLabelFont(.systemFont(ofSize: 17, weight: .semibold))
        setNavigationBarBackButtonHidden(false)
    }
    
}

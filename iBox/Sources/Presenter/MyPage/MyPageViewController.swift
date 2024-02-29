//
//  MyPageViewController.swift
//  iBox
//
//  Created by 이지현 on 12/27/23.
//

import UIKit

protocol MyPageViewDelegate {
    func pushViewController(_ type: MyPageType)
    func pushViewController(_ viewController: UIViewController)
}

class MyPageViewController: BaseNavigationBarViewController<MyPageView> {
    
    // MARK: - Properties
    
    private let viewModel = MyPageViewModel()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let contentView = contentView as? MyPageView else { return }
        contentView.delegate = self
        contentView.bindViewModel(viewModel)
        viewModel.input.send(.viewWillAppear)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.send(.viewWillAppear)
    }
    
    // MARK: - BaseNavigationBarViewControllerProtocol
    
    override func setupNavigationBar() {
        setNavigationBarTitleLabelText("마이 페이지")
    }
    
}

extension MyPageViewController: MyPageViewDelegate {
    
    func pushViewController(_ type: MyPageType) {
        switch type {
        case .theme:
            navigationController?.pushViewController(ThemeViewController(), animated: true)
        case .homeTab:
            navigationController?.pushViewController(HomeTabSelectorViewController(), animated: true)
        case .preload:
            print("미리 로드 탭 !")
        case .guide:
            print("이용 가이드 탭 !")
        case .feedback:
            print("앱 피드백 탭 !")
        case .developer:
            print("개발자 정보 탭 !")
        }
    }
    
    func pushViewController(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

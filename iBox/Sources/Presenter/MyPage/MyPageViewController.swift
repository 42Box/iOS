//
//  MyPageViewController.swift
//  iBox
//
//  Created by 이지현 on 12/27/23.
//

import UIKit

protocol MyPageViewDelegate {
    func pushViewController(_ indexPath: IndexPath)
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
    }
    
    // MARK: - BaseNavigationBarViewControllerProtocol
    
    override func setupNavigationBar() {
        setNavigationBarTitleLabelText("My Page")
    }
    
}

extension MyPageViewController: MyPageViewDelegate {
    
    func pushViewController(_ indexPath: IndexPath) {
        if indexPath.section == 0 {
            navigationController?.pushViewController(ThemeViewController(), animated: true)
        } else {
            switch indexPath.row {
            case 0: print("이용 가이드 탭 !")
            case 1: print("앱 피드백 탭 !")
            case 2: print("개발자 정보 탭 !")
            default: break;
            }
        }
    }
    
    func pushViewController(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

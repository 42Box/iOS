//
//  SettingsViewController.swift
//  iBox
//
//  Created by 이지현 on 12/27/23.
//

import UIKit

protocol SettingsViewDelegate {
    func pushViewController(_ type: SettingsType)
    func pushViewController(_ viewController: UIViewController)
}

final class SettingsViewController: BaseViewController<SettingsView>, BaseViewControllerProtocol {
    
    private let viewModel = SettingsViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        guard let contentView = contentView as? SettingsView else { return }
        contentView.delegate = self
        contentView.bindViewModel(viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.send(.viewWillAppear)
    }
    
    // MARK: - BaseViewControllerProtocol
    
    func setupNavigationBar() {
        setNavigationBarTitleLabelText("설정")
    }
    
}

extension SettingsViewController: SettingsViewDelegate {
    
    func pushViewController(_ type: SettingsType) {
        switch type {
        case .theme:
            navigationController?.pushViewController(ThemeViewController(), animated: true)
        case .homeTab:
            navigationController?.pushViewController(HomeTabSelectorViewController(), animated: true)
        case .reset:
            navigationController?.pushViewController(ResetViewController(), animated: true)
        case .guide:
            navigationController?.pushViewController(GuideViewController(), animated: true)
        default: break
        }
    }
    
    func pushViewController(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

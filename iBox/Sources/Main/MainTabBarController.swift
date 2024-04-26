//
//  MainTabBarController.swift
//  iBox
//
//  Created by 이지현 on 12/27/23.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var previousTabIndex = 0
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        view.backgroundColor = .backgroundColor
        
        setupTabBar()
        setupTabBarAppearance()
    }
    
    // MARK: - Setup Methods
    
    private func setupTabBar() {
        viewControllers = [
            setupViewController(viewController: BoxListViewController(), image: UIImage(systemName: "square.grid.2x2.fill")),
            setupViewController(viewController: FavoriteViewController(), image: UIImage(systemName: "heart.fill")),
            setupViewController(viewController: SettingsViewController(), image: UIImage(systemName: "gearshape.fill"))
        ]
        tabBar.tintColor = .box
        tabBar.backgroundColor = .backgroundColor
        selectedIndex = UserDefaultsManager.homeTabIndex
    }
    
    private func setupViewController(viewController: UIViewController, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = ""
        viewController.tabBarItem.image = image
        return UINavigationController(rootViewController: viewController)
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarItem.appearance()
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .selected)
    }
    
}

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if UserDefaultsManager.isHaptics {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
        if tabBarController.selectedIndex == 1 && previousTabIndex == 1 {
            WebViewPreloader.shared.resetFavoriteView()
        }
        previousTabIndex = tabBarController.selectedIndex
    }
    
}

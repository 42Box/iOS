//
//  MainTabBarController.swift
//  iBox
//
//  Created by 이지현 on 12/27/23.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        setupTabBar()
        setupTabBarAppearance()
    }
    
    private func setupTabBar() {
        viewControllers = [
            setupViewController(viewController: BoxListViewController(), image: UIImage(systemName: "square.grid.2x2.fill")),
            setupViewController(viewController: FavoriteViewController(), image: UIImage(systemName: "heart.fill")),
            setupViewController(viewController: MyPageViewController(), image: UIImage(systemName: "person.fill"))
        ]
        tabBar.tintColor = .box
        tabBar.backgroundColor = .systemBackground
        selectedIndex = UserDefaultsManager.homeTabIndex.value
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

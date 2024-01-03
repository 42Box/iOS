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
        view.backgroundColor = .systemBackground

        setupTabBar()
    }
    
    private func setupTabBar() {
        viewControllers = [
            setupViewController(viewController: BoxListViewController(), image: UIImage(systemName: "square.grid.2x2.fill")),
            setupViewController(viewController: FavoriteViewController(), image: UIImage(systemName: "heart.fill")),
            setupViewController(viewController: ProfileViewController(), image: UIImage(systemName: "person.fill"))
        ]
    }
    
    private func setupViewController(viewController: UIViewController, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.image = image
        return UINavigationController(rootViewController: viewController)
    }

}

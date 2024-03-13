//
//  MainTabBarController.swift
//  iBox
//
//  Created by 이지현 on 12/27/23.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var previousTabIndex = 0
    var imageChangeTimer: Timer?
    var currentImageIndex = 0
    
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
            setupViewController(viewController: SettingsViewController(), image: UIImage(named: "sitting_fox0"))
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
        if tabBarController.selectedIndex == 1 && previousTabIndex == 1 {
            WebViewPreloader.shared.resetFavoriteView()
        }
        previousTabIndex = tabBarController.selectedIndex
        
        if tabBarController.selectedIndex == 2 {
            startImageRotation()
        } else {
            stopImageRotation()
        }
    }
    
    private func startImageRotation() {
        stopImageRotation() // 현재 진행 중인 타이머가 있다면 중지
        imageChangeTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updateTabBarImage), userInfo: nil, repeats: true)
    }
    
    private func stopImageRotation() {
        imageChangeTimer?.invalidate()
        imageChangeTimer = nil
    }
    
    @objc private func updateTabBarImage() {
        if let viewControllers = viewControllers, viewControllers.count > 2 {
            let settingsViewController = viewControllers[2]
            let imageName = "sitting_fox\(currentImageIndex)"
            settingsViewController.tabBarItem.image = UIImage(named: imageName)
            
            currentImageIndex += 1
            if currentImageIndex > 3 { currentImageIndex = 0 }
        }
    }
    
}

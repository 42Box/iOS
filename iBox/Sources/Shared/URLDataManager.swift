//
//  URLDataManager.swift
//  iBox
//
//  Created by 최종원 on 3/5/24.
//

import UIKit

class URLDataManager {
    static let shared = URLDataManager()
    
    var incomingTitle: String?
    var incomingData: String?
    var incomingFaviconUrl: String?

    private init() {}

    func update(with data: (title: String?, data: String?, faviconUrl: String?)) {
        incomingTitle = data.title
        incomingData = data.data
        incomingFaviconUrl = data.faviconUrl
    }
    
    func navigateToAddBookmarkView(from url: URL, in tabBarController: UITabBarController) {
        guard url.scheme == "iBox" else { return }

        let urlData = URLdecoder.handleCustomURL(url)
        self.update(with: urlData)

        tabBarController.selectedIndex = 0
        DispatchQueue.main.async {
            guard let navigationController = tabBarController.selectedViewController as? UINavigationController,
                  let boxListViewController = navigationController.viewControllers.first as? BoxListViewController else {
                return
            }
            boxListViewController.shouldPresentModalAutomatically = true
        }
    }
}

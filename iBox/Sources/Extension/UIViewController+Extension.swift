//
//  UIViewController+Extension.swift
//  iBox
//
//  Created by Chan on 4/16/24.
//

import UIKit

extension UIViewController {
    func findMainTabBarController() -> UITabBarController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UITabBarController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
    
    func findAddBookmarkViewController() -> AddBookmarkViewController? {
        if let navigationController = presentedViewController as? UINavigationController,
           let vc = navigationController.topViewController as? AddBookmarkViewController {
            return vc
        }
        return nil
    }
}

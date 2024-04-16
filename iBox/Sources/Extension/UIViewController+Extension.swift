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
    
    func findAddBookmarkView() -> Bool? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? AddBookmarkView {
                return true
            }
            responder = nextResponder
        }
        return nil
    }
    
    
}

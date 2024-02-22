//
//  UIView+Extension.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import UIKit

protocol Then {}

extension Then where Self: AnyObject {
    
    func then(block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
    
}

extension UIView: Then {}

extension UIView {
    
    func toUserInterfaceStyle(_ theme: Theme) -> UIUserInterfaceStyle {
        switch theme {
        case .light: return UIUserInterfaceStyle.light
        case .dark: return UIUserInterfaceStyle.dark
        case .system: return UIUserInterfaceStyle.unspecified
        }
    }
    
}

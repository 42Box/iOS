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
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        DispatchQueue.main.async { // 확실히 메인 스레드에서 실행되도록 강제
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            mask.frame = self.bounds
            self.layer.mask = mask
        }
    }
    
}

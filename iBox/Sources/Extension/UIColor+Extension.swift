//
//  UIColor+Extension.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import UIKit

extension UIColor {
    
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    class var box: UIColor { UIColor(hex: 0xFF7F29) }
    class var box2: UIColor { UIColor(hex: 0xFF9548) }
    class var box3: UIColor { UIColor(hex: 0xFFDC6E) }
    
}

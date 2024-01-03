//
//  ColorPalette.swift
//  iBox
//
//  Created by 이지현 on 1/3/24.
//

import UIKit

struct ColorPalette {
    
    public static var backgroundColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return UIColor.black
                } else {
                    return .systemGray5
                }
            }
        } else {
            return .systemGray5
        }
    }()
    
    public static var tableViewBackgroundColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return UIColor.systemGray5
                } else {
                    return .white
                }
            }
        } else {
            return .white
        }
    }()
    
}

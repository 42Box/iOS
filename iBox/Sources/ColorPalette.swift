//
//  ColorPalette.swift
//  iBox
//
//  Created by 이지현 on 1/3/24.
//

import UIKit

enum ColorName: String {
    case gray
    case green
    case red
    case blue
    case yellow

    func toUIColor() -> UIColor {
        switch self {
        case .gray:
            return UIColor.systemGray2
        case .green:
            return UIColor.systemGreen
        case .red:
            return UIColor.systemRed
        case .blue:
            return UIColor.systemBlue
        case .yellow:
            return UIColor.systemYellow
        }
    }
}

struct ColorPalette {
    
    public static var backgroundColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor.black
            } else {
                return .systemGray5
            }
        }
    }()
    
    public static var tableViewBackgroundColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor.systemGray5
            } else {
                return .white
            }
        }
    }()
    
}


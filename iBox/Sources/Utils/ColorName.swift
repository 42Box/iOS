//
//  ColorName.swift
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

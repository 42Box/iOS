//
//  Theme.swift
//  iBox
//
//  Created by jiyeon on 1/4/24.
//

import UIKit

enum Theme: Codable, CaseIterable {
    case light
    case dark
    case system
    
    func toString() -> String {
        switch self {
        case .light: "라이트 모드"
        case .dark: "다크 모드"
        case .system: "시스템 설정 모드"
        }
    }
    
    func toImageString() -> String {
        switch self {
        case .light: "circle"
        case .dark: "circle.fill"
        case .system: "circle.righthalf.filled"
        }
    }
}

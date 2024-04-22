//
//  SettingsItem.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import Foundation

enum SettingsType {
    case theme
    case homeTab
    case haptics
    case preload
    case reset
    case guide
    
    func toString() -> String {
        switch self {
        case .theme: "테마"
        case .homeTab: "시작 화면"
        case .haptics: "진동"
        case .preload: "즐겨찾기 미리 로드"
        case .reset: "데이터 초기화"
        case .guide: "앱 소개"
        }
    }

}

struct SettingsItem {
    var type: SettingsType
    var description: String?
    var flag: Bool?
}

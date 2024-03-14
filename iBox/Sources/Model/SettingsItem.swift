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
    case preload
    case reset
    case guide
    case feedback
    
    func toString() -> String {
        switch self {
        case .theme: "테마"
        case .homeTab: "홈화면"
        case .preload: "즐겨찾기 미리 로드"
        case .reset: "데이터 초기화"
        case .guide: "앱 소개"
        case .feedback: "앱 피드백"
        }
    }

}

struct SettingsItem {
    var type: SettingsType
    var description: String?
    var flag: Bool?
}

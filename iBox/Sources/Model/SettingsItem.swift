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
    case guide
    case feedback
    case developer
    
    func toString() -> String {
        switch self {
        case .theme: "테마"
        case .homeTab: "홈화면"
        case .preload: "즐겨찾기 미리 로드"
        case .guide: "이용 가이드"
        case .feedback: "앱 피드백"
        case .developer: "개발자 정보"
        }
    }

}

struct SettingsItem {
    var type: SettingsType
    var description: String?
    var flag: Bool?
}

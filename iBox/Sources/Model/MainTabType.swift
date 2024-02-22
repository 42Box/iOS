//
//  MainTabType.swift
//  iBox
//
//  Created by jiyeon on 2/22/24.
//

import Foundation

enum MainTabType: CaseIterable {
    case boxList
    case favorite
    
    func toString() -> String {
        switch self {
        case .boxList: "북마크 목록"
        case .favorite: "즐겨찾기"
        }
    }
}

//
//  ThemeViewModel.swift
//  iBox
//
//  Created by jiyeon on 2/22/24.
//

import Combine
import Foundation

class ThemeViewModel {
    
    @Published var selectedIndex: Int
    
    init() {
        switch UserDefaultsManager.theme {
        case .light: selectedIndex = 0
        case .dark: selectedIndex = 1
        case .system: selectedIndex = 2
        }
    }
    
}

//
//  HomeTabSelectorViewModel.swift
//  iBox
//
//  Created by jiyeon on 2/22/24.
//

import Combine
import Foundation

class HomeTabSelectorViewModel {
    
    @Published var selectedIndex: Int = UserDefaultsManager.homeTabIndex
    
}

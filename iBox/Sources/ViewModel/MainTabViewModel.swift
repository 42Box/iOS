//
//  MainTabViewModel.swift
//  iBox
//
//  Created by jiyeon on 2/22/24.
//

import Combine
import Foundation

class MainTabViewModel {
    
    @Published var selectedIndex: Int = UserDefaultsManager.mainTabIndex.value
    
}

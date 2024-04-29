//
//  SettingsCellViewModel.swift
//  iBox
//
//  Created by jiyeon on 2/22/24.
//

import Foundation

class SettingsCellViewModel {
    
    let settingsItem: SettingsItem
    
    init(_ settingsItem: SettingsItem) {
        self.settingsItem = settingsItem
    }
    
    var title: String {
        settingsItem.type.toString()
    }
    
    var flag: Bool? {
        settingsItem.flag
    }
    
    var description: String? {
        settingsItem.description
    }
    
}

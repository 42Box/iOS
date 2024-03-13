//
//  SettingsSectionViewModel.swift
//  iBox
//
//  Created by jiyeon on 2/22/24.
//

import Foundation

class SettingsSectionViewModel {
    
    let cellViewModels: [SettingsCellViewModel]
    
    init(cellViewModels: [SettingsCellViewModel]) {
        self.cellViewModels = cellViewModels
    }
    
}

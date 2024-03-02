//
//  MyPageSectionViewModel.swift
//  iBox
//
//  Created by jiyeon on 2/22/24.
//

import Foundation

class MyPageSectionViewModel {
    
    let cellViewModels: [MyPageCellViewModel]
    
    init(cellViewModels: [MyPageCellViewModel]) {
        self.cellViewModels = cellViewModels
    }
    
}

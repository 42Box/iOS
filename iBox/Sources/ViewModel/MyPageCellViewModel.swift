//
//  MyPageCellViewModel.swift
//  iBox
//
//  Created by jiyeon on 2/22/24.
//

import Foundation

class MyPageCellViewModel {
    
    let model: MyPageItem
    
    init(_ model: MyPageItem) {
        self.model = model
    }
    
    var title: String {
        model.title
    }
    
    var description: String? {
        model.description
    }
    
}

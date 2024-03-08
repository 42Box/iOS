//
//  MyPageCellViewModel.swift
//  iBox
//
//  Created by jiyeon on 2/22/24.
//

import Foundation

class MyPageCellViewModel {
    
    let myPageItem: MyPageItem
    
    init(_ myPageItem: MyPageItem) {
        self.myPageItem = myPageItem
    }
    
    var title: String {
        myPageItem.type.toString()
    }
    
    var flag: Bool? {
        myPageItem.flag
    }
    
    var description: String? {
        myPageItem.description
    }
    
}

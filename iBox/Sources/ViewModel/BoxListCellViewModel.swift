//
//  BoxListCellViewModel.swift
//  iBox
//
//  Created by 이지현 on 1/30/24.
//

import Foundation

class BoxListCellViewModel: Identifiable {
    private let bookmark: Bookmark
    
    init(bookmark: Bookmark) {
        self.bookmark = bookmark
    }
    
    let id = UUID()
    
    var name: String {
        bookmark.name
    }

    var url: String {
        bookmark.url
    }
    
}

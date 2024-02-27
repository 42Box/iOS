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
        self.name = bookmark.name
        self.url = bookmark.url
    }
    
    var id: UUID {
        bookmark.id
    }
    
    var name: String

    var url: URL
    
}

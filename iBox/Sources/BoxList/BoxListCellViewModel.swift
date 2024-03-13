//
//  BoxListCellViewModel.swift
//  iBox
//
//  Created by 이지현 on 1/30/24.
//

import Foundation

class BoxListCellViewModel: Identifiable {
    var bookmark: Bookmark
    
    init(bookmark: Bookmark) {
        self.bookmark = bookmark
    }
    
    var id: UUID {
        bookmark.id
    }
    
    var name: String {
        bookmark.name
    }

    var url: URL {
        bookmark.url
    }
    
}

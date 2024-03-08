//
//  Folder.swift
//  iBox
//
//  Created by 이지현 on 1/4/24.
//

import Foundation

struct Folder {
    var id: UUID
    let name: String
    let bookmarks: [Bookmark]
    var isOpened: Bool = false
}


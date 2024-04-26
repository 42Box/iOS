//
//  Folder.swift
//  iBox
//
//  Created by 이지현 on 1/4/24.
//

import Foundation

struct Folder: Codable {
    let id: UUID
    var name: String
    var bookmarks: [Bookmark]
}


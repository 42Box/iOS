//
//  Folder.swift
//  iBox
//
//  Created by 이지현 on 1/4/24.
//

import Foundation

struct Folder {
    let name: String
    let color: ColorName
    let bookmarks: [Bookmark]
    var isOpened: Bool = true
}


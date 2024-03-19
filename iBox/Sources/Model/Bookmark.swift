//
//  Bookmark.swift
//  iBox
//
//  Created by 이지현 on 1/30/24.
//

import Foundation

struct Bookmark: Codable {
    let id: UUID
    var name: String
    var url: URL
}

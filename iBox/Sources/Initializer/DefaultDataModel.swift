//
//  DefaultDataModel.swift
//  iBox
//
//  Created by Chan on 4/17/24.
//

import Foundation


struct FolderData: Codable {
    var favorite: String
    var list: [BookmarkData]
}

struct BookmarkData: Codable {
    var name: String
    var url: String
}

struct DefaultDataLoader {
    static var defaultURL = URL(string: "https://42box.github.io/iOSHowToUse/")!
}

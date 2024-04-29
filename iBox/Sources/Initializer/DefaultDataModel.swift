//
//  DefaultDataModel.swift
//  iBox
//
//  Created by Chan on 4/17/24.
//

import Foundation


struct FolderData: Codable {
    var list: [BookmarkData]
}

struct BookmarkData: Codable {
    var name: String
    var url: String
}

struct DefaultDataLoader {
    static let defaultData = [
        Folder(id: UUID(), name: "42 폴더", bookmarks: [
            Bookmark(id: UUID(), name: "42 Intra", url: URL(string: "https://profile.intra.42.fr/")!),
            Bookmark(id: UUID(), name: "42Where", url: URL(string: "https://www.where42.kr/")! ),
            Bookmark(id: UUID(), name: "42Stat", url: URL(string: "https://stat.42seoul.kr/")!),
            Bookmark(id: UUID(), name: "집현전", url: URL(string: "https://42library.kr/")!),
            Bookmark(id: UUID(), name: "42gg", url: URL(string: "https://gg.42seoul.kr/")!),
            Bookmark(id: UUID(), name: "24HANE", url: URL(string: "https://24hoursarenotenough.42seoul.kr/")!)
        ])
    ]
}

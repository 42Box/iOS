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
    let webs: [Web]
    var isOpened: Bool = true
}

struct Web: Codable {
    let name: String
    let url: String
}

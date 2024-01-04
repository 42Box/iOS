//
//  Folder.swift
//  iBox
//
//  Created by 이지현 on 1/4/24.
//

import Foundation

struct Folder {
    let name: String
    let webs: [Web]
    var isExpanded: Bool = true
}

struct Web {
    let name: String
    let url: String
}

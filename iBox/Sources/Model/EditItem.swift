//
//  EditItem.swift
//  iBox
//
//  Created by jiyeon on 2/29/24.
//

import Foundation

enum EditType {
    case folder
    case bookmark
}

struct EditItem {
    var type: EditType
    var imageString: String
    var title: String
}

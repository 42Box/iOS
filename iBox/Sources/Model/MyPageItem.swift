//
//  MyPageItem.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import UIKit

struct MyPageSection {
    var title: String
    var items: [MyPageItem]
}

struct MyPageItem {
    var title: String
    var description: String?
    var viewController: UIViewController?
}

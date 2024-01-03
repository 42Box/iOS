//
//  ProfileItem.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import UIKit

struct ProfileSection {
    var title: String
    var items: [ProfileItem]
}

struct ProfileItem {
    var title: String
    var viewController: UIViewController?
}

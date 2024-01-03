//
//  BoxListViewController.swift
//  iBox
//
//  Created by 이지현 on 12/27/23.
//

import UIKit

class BoxListViewController: BaseViewController<BoxListView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "iBox"
        navigationController?.navigationBar.prefersLargeTitles = true // BaseViewController에 추가해도 될 듯?
    }

}

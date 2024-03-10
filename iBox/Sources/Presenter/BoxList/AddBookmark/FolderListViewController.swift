//
//  FolderListViewController.swift
//  iBox
//
//  Created by 최종원 on 3/7/24.
//

import UIKit

class FolderListViewController: UIViewController {
    let bookmarkListView = FolderListView()

    override func loadView() {
        view = bookmarkListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

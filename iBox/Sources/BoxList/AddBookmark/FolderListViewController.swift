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
        
        bookmarkListView.onFolderSelected = { [weak self] folder in
            
            guard let self = self else { return }
            
            if let addBookmarkVC = self.navigationController?.viewControllers.first as? AddBookmarkViewController {
                addBookmarkVC.selectedFolder = folder
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

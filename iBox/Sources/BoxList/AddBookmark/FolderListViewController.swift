//
//  FolderListViewController.swift
//  iBox
//
//  Created by 최종원 on 3/7/24.
//

import UIKit

class FolderListViewController: UIViewController {
    let folderListView = FolderListView()

    override func loadView() {
        view = folderListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        folderListView.onFolderSelected = { [weak self] folder in
            
            guard let self = self else { return }
            
            if let addBookmarkVC = self.navigationController?.viewControllers.first as? AddBookmarkViewController {
                addBookmarkVC.selectedFolder = folder
                UserDefaultsManager.selectedFolder = folder
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

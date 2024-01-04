//
//  BoxListViewController.swift
//  iBox
//
//  Created by 이지현 on 12/27/23.
//

import UIKit

class BoxListViewController: BaseNavigationBarViewController<BoxListView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let contentView = contentView as? BoxListView else { return }
        contentView.delegate = self
    }
    
    override func setupNavigationBar() {
        setNavigationBarTitleLabelText("iBox")
    }

}

extension BoxListViewController: BoxListViewDelegate {
    func didSelectWeb(at url: String, withName name: String) {
        let viewController = WebViewController()
        viewController.title = name 
        viewController.selectedWebsite = url
        navigationController?.pushViewController(viewController, animated: true)
    }
}

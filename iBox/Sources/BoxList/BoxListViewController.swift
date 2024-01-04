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
        baseView.delegate = self
        
        title = "iBox"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}

extension BoxListViewController: BoxListViewDelegate {
    func didSelectWeb(at url: String) {
        let viewController = WebViewController()
        viewController.selectedWebsite = url
        navigationController?.pushViewController(viewController, animated: true)
    }
}

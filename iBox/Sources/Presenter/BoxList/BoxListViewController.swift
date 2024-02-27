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
        setupNavigationBar()
        
        guard let contentView = contentView as? BoxListView else { return }
        contentView.delegate = self
    }
    
    override func setupNavigationBar() {
        setNavigationBarTitleLabelText("iBox")
        setNavigationBarAddButtonHidden(false)
        setNavigationBarAddButtonAction(#selector(addButtonTapped))
    }
    
    @objc private func addButtonTapped(_ sender: Any?) {
        let addBookmarkBottomSheetViewController = AddBookmarkBottomSheetViewController(bottomSheetHeight: 200)
        present(addBookmarkBottomSheetViewController, animated: false)
    }

}

extension BoxListViewController: BoxListViewDelegate {
    func didSelectWeb(at url: URL, withName name: String) {
        let viewController = PreloadedWebViewController(selectedWebsite: url)
        viewController.title = name
        navigationController?.pushViewController(viewController, animated: true)
    }
}

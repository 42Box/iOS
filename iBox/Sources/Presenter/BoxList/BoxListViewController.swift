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
        setNavigationBarMenuButtonHidden(false)
        setNavigationBarAddButtonAction(#selector(addButtonTapped))
        setNavigationBarMoreButtonAction(#selector(moreButtonTapped))
    }
    
    @objc private func addButtonTapped() {
        let addBookmarkBottomSheetViewController = AddBookmarkBottomSheetViewController(bottomSheetHeight: 200)
        present(addBookmarkBottomSheetViewController, animated: false)
    }
    
    @objc private func moreButtonTapped() {
        let editViewController = EditViewController(bottomSheetHeight: 200)
        editViewController.delegate = self
        present(editViewController, animated: false)
    }

}

extension BoxListViewController: BoxListViewDelegate {
    func didSelectWeb(at url: URL, withName name: String) {
        let viewController = PreloadedWebViewController(selectedWebsite: url)
        viewController.title = name
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushViewController(type: EditType) {
        switch type {
        case .folder:
            navigationController?.pushViewController(EditFolderViewController(), animated: true)
        case .bookmark:
            navigationController?.pushViewController(EditBookmarkViewController(), animated: true)
        }
    }
}

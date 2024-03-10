//
//  BoxListViewController.swift
//  iBox
//
//  Created by 이지현 on 12/27/23.
//

import UIKit

class BoxListViewController: BaseViewController<BoxListView>, BaseViewControllerProtocol {

    var shouldPresentModalAutomatically: Bool = false {
        didSet {
            if shouldPresentModalAutomatically {
                // shouldPresentModalAutomatically가 true로 설정될 때 함수 호출
                dismiss(animated: false) {
                    self.addButtonTapped()
                }
                // 함수 호출 후 shouldPresentModalAutomatically를 false로 설정
                shouldPresentModalAutomatically = false
            }
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        guard let contentView = contentView as? BoxListView else { return }
        contentView.delegate = self
    }
    
    // MARK: - BaseViewControllerProtocol
    
    func setupNavigationBar() {
        setNavigationBarTitleLabelText("iBox")
        setNavigationBarMenuButtonHidden(false)
        setNavigationBarAddButtonAction(#selector(addButtonTapped))
        setNavigationBarMoreButtonAction(#selector(moreButtonTapped))
    }
    
    // MARK: - Action Functions
    
    @objc private func addButtonTapped() {
        let addBookmarkViewController = AddBookmarkViewController()
        let navigationController = UINavigationController(rootViewController: addBookmarkViewController)

        navigationController.modalPresentationStyle = .pageSheet
        present(navigationController, animated: true, completion: nil)
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

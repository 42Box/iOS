//
//  WebViewController.swift
//  iBox
//
//  Created by 이지현 on 1/4/24.
//

import UIKit

protocol WebViewDelegate {
    func pushAddBookMarkViewController(url: URL)
}

class WebViewController: BaseViewController<WebView>, BaseViewControllerProtocol {
    
    var delegate: AddBookmarkViewControllerProtocol?
    var selectedWebsite: URL?

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        view.backgroundColor = .backgroundColor
        
        guard let contentView = contentView as? WebView else { return }
        contentView.delegate = self
        contentView.selectedWebsite = selectedWebsite
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let contentView = contentView as? WebView else { return }
        contentView.setupRefreshControl()
    }
    
    // MARK: - BaseViewControllerProtocol
    
    func setupNavigationBar() {
        setNavigationBarHidden(true)
    }

}

extension WebViewController: WebViewDelegate {
    
    func pushAddBookMarkViewController(url: URL) {
        URLDataManager.shared.incomingData = url.absoluteString
        
        let addBookmarkViewController = AddBookmarkViewController()
        addBookmarkViewController.delegate = delegate
        
        let navigationController = UINavigationController(rootViewController: addBookmarkViewController)
        navigationController.modalPresentationStyle = .pageSheet
        self.present(navigationController, animated: true, completion: nil)
    }
    
}

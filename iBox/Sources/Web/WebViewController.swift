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
        
        if let iBoxUrl = URL(string: "iBox://url?data=" + url.absoluteString) {
            if let tabBarController = findMainTabBarController() {
                URLDataManager.shared.navigateToAddBookmarkView(from: iBoxUrl, in: tabBarController)
            }
        }
        
    }
    
}

//
//  WebViewController.swift
//  iBox
//
//  Created by 이지현 on 1/4/24.
//

import UIKit
import WebKit

protocol WebViewDelegate {
    func pushAddBookMarkViewController(url: URL)
}

class WebViewController: BaseViewController<WebView>, BaseViewControllerProtocol {
    
    var errorViewController: ErrorPageViewController?
    var delegate: AddBookmarkViewControllerProtocol?
    var selectedWebsite: URL?

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
        setupDelegate()
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
    
    func setupDelegate() {
        guard let contentView = contentView as? WebView else { return }
        contentView.delegate = self
        contentView.selectedWebsite = selectedWebsite

        errorViewController = ErrorPageViewController(webView: contentView)
        contentView.errorDelegate = errorViewController
        errorViewController?.delegate = self
    }
    
    func setupView() {
        view.backgroundColor = .backgroundColor
    }
}

extension WebViewController: WebViewDelegate {
    
    func pushAddBookMarkViewController(url: URL) {
        let encodingURL = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let iBoxUrl = URL(string: "iBox://url?data=" + encodingURL) {
            if let tabBarController = findMainTabBarController() {
                AddBookmarkManager.shared.navigateToAddBookmarkView(from: iBoxUrl, in: tabBarController)
            }
        }
    }
}

extension WebViewController: ErrorPageControllerDelegate {
    func presentErrorPage(_ errorPage: ErrorPageViewController) {
        self.present(errorPage, animated: true, completion: nil)
    }
}

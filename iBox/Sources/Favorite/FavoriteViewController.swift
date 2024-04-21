//
//  FavoriteViewController.swift
//  iBox
//
//  Created by 이지현 on 12/27/23.
//

import UIKit

class FavoriteViewController: BaseViewController<FavoriteView>, BaseViewControllerProtocol {

    var delegate: AddBookmarkViewControllerProtocol?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        guard let contentView = contentView as? FavoriteView else { return }
        contentView.webView?.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let contentView = contentView as? FavoriteView else { return }
        contentView.webView?.setupRefreshControl()
    }
    
    // MARK: - BaseViewControllerProtocol
    
    func setupNavigationBar() {
        setNavigationBarHidden(true)
    }

}

extension FavoriteViewController: WebViewDelegate {
    
    func pushAddBookMarkViewController(url: URL) {
        let encodingURL = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let iBoxUrl = URL(string: "iBox://url?data=" + encodingURL) {
            if let tabBarController = findMainTabBarController() {
                AddBookmarkManager.shared.navigateToAddBookmarkView(from: iBoxUrl, in: tabBarController)
            }
        }
    }
    
}

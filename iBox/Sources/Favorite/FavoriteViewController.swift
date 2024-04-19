//
//  FavoriteViewController.swift
//  iBox
//
//  Created by 이지현 on 12/27/23.
//

import UIKit

class FavoriteViewController: BaseViewController<FavoriteView>, BaseViewControllerProtocol {
    
    var selectedWebsite: URL?

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        view.backgroundColor = .backgroundColor

        // contentView가 FavoriteView 인스턴스인 경우, WebView의 delegate 설정
        if let favoriteView = self.view as? FavoriteView {
            // WebViewPreloader를 통해 가져온 WebView의 delegate를 이 ViewController로 설정
            let webView = favoriteView.webView
            webView.delegate = self
            webView.selectedWebsite = selectedWebsite  // 웹 사이트 설정
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let favoriteView = self.view as? FavoriteView {
            favoriteView.webView.setupRefreshControl()
        }
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

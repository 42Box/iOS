//
//  WebViewPreloader.swift
//  iBox
//
//  Created by 이지현 on 1/18/24.
//

import Foundation
import WebKit

class WebViewPreloader {
    static let shared = WebViewPreloader()
    private var favoriteView: (url: URL, webView: WebView)?
    private var defaultUrl = DefaultDataLoader.defaultURL
    
    private init() {}
    
    func preloadFavoriteView(url: URL?) {
        let webView = WebView()
        webView.isOpaque = false
        webView.selectedWebsite = url ?? defaultUrl
        favoriteView = (url ?? defaultUrl, webView)
    }
    
    func getFavoriteView() -> WebView? {
        return favoriteView?.webView
    }
    
    func resetFavoriteView() {
        guard let favoriteView else { return }
        favoriteView.webView.selectedWebsite = favoriteView.url
    }
    
    func setFavoriteUrl(url: URL?) {
        if let favoriteView {
            if url == favoriteView.url || 
                (url == nil && favoriteView.url == defaultUrl ) {
                return
            } else {
                self.favoriteView?.url = url ?? defaultUrl
                resetFavoriteView()
            }
        } else {
            preloadFavoriteView(url: url)
        }
    }

}

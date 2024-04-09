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
    private var favoriteView: (url: URL, webView: WKWebView)?
    private var defaultUrl = URL(string: "https://profile.intra.42.fr/")!
    
    private init() {}
    
    func preloadFavoriteView(url: URL?) {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.load(URLRequest(url: url ?? defaultUrl))
        favoriteView = (url ?? defaultUrl, webView)
    }
    
    func getFavoriteView() -> WKWebView? {
        return favoriteView?.webView
    }
    
    func resetFavoriteView() {
        guard let favoriteView else { return }
        favoriteView.webView.load(URLRequest(url: favoriteView.url))
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

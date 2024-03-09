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
    private var webView: WKWebView?
    private var favoriteView: (url: URL, webView: WKWebView)?
    
    private init() {}
    
    func preload(url: URL) {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.load(URLRequest(url: url))
        self.webView = webView
    }
    
    func preloadFavoriteView(url: URL) {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.load(URLRequest(url: url))
        favoriteView = (url, webView)
    }
    
    func getWebView() -> WKWebView? {
        return webView
    }
    
    func getFavoriteView() -> WKWebView? {
        return favoriteView?.webView
    }
    
    func resetWebView() {
        webView = nil
    }
    
    func resetFavoriteView() {
        guard let favoriteView else { return }
        favoriteView.webView.load(URLRequest(url: favoriteView.url))
    }

}

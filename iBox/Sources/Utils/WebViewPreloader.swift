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
    private var webViews: [URL: WKWebView] = [:]
    private var favoriteView: (url: URL, webView: WKWebView)?
    
    private init() {}
    
    func preload(urls: [URL]) {
        for url in urls {
            let webView = WKWebView()
            webView.load(URLRequest(url: url))
            webViews[url] = webView
        }
    }
    
    func preloadFavoriteView(url: URL) {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        favoriteView = (url, webView)
    }
    
    func getWebView(for url: URL) -> WKWebView? {
        return webViews[url]
    }
    
    func getFavoriteView() -> WKWebView? {
        return favoriteView?.webView
    }
    
    func resetWebView(for url: URL) {
        webViews[url]?.load(URLRequest(url: url))
    }
    
    func resetFavoriteView() {
        guard let favoriteView else { return }
        favoriteView.webView.load(URLRequest(url: favoriteView.url))
    }
    

}

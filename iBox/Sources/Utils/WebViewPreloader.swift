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
    
    private init() {}
    
    func preload(urls: [URL]) {
        for url in urls {
            let webView = WKWebView()
            webView.load(URLRequest(url: url))
            webViews[url] = webView
        }
    }
    
    func getWebView(for url: URL) -> WKWebView? {
        return webViews[url]
    }
    
    func resetWebView(for url: URL) {
        webViews[url]?.load(URLRequest(url: url))
    }

}

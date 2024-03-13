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
    private var favoriteURL: String?
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
        favoriteURL = url.description
        print(url.description)
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
    
    func injectTokenIntoFavoriteView() {
        guard let accessToken = OAuthManager.shared.getToken(for: "accessToken") else {
            print("Failed to retrieve access token from Keychain")
            return
        }
        
        guard let favoriteView = favoriteView else {
            print("Favorite view is not set")
            return
        }
        
        DispatchQueue.main.async {
            let jsCode = "localStorage.setItem('access_token', '\(accessToken)');"
            favoriteView.webView.evaluateJavaScript(jsCode) { result, error in
                DispatchQueue.main.async {
                    self.favoriteView?.webView.reload()
                }
                
                if let error = error {
                    print("Error injecting access token into webview: \(error.localizedDescription)")
                } else {
                    print("Access token successfully injected into webview")
                }
            }
        }
    }
    
    func injectAccessTokenAsCookie() {
        guard let accessToken = OAuthManager.shared.getToken(for: "accessToken") else {
            print("Failed to retrieve access token from Keychain")
            return
        }
        
        let cookie = HTTPCookie(properties: [
            .domain: self.favoriteURL ?? "https://profile.intra.42.fr", // 쿠키를 사용할 도메인
            .path: "/", // 쿠키 경로
            .name: "access_token", // 쿠키 이름
            .value: accessToken, // 액세스 토큰 값
            .secure: "TRUE", // HTTPS를 통해서만 쿠키를 전송
            .expires: NSDate(timeIntervalSinceNow: 3600) // 쿠키 만료 시간 (예: 1시간 후)
        ])!
        
        DispatchQueue.main.async {
            self.favoriteView?.webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie) {
                DispatchQueue.main.async {
                    self.favoriteView?.webView.reload()
                }
            }
        }
    }
    
}

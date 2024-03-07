//
//  WebView.swift
//  iBox
//
//  Created by 이지현 on 1/4/24.
//

import UIKit
import WebKit

import SnapKit

class WebView: UIView {
    var selectedWebsite: URL? {
        didSet {
            loadWebsite()
        }
    }
    
    private let webView = WKWebView().then {
        $0.isOpaque = false
        $0.scrollView.contentInsetAdjustmentBehavior = .always
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperty()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        webView.stopLoading()
        webView.navigationDelegate = nil
        webView.scrollView.delegate = nil
    }
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        backgroundColor = .backgroundColor
        webView.navigationDelegate = self
    }
    
    private func setupHierarchy() {
        addSubview(webView)
    }
    
    private func setupLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadWebsite() {
        guard let url = selectedWebsite else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
}

extension WebView: WKNavigationDelegate {
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//            print("웹뷰 로딩 실패: \(error.localizedDescription)")
//        }
//
//    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        print("웹뷰 프로비저널 네비게이션 실패: \(error.localizedDescription)")
//    }
//    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if let url = navigationAction.request.url {
//            print("웹뷰가 리다이렉트 되는 URL: \(url.absoluteString)")
//        }
//        
//        decisionHandler(.allow)
//    }
}

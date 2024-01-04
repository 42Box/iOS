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
    var selectedWebsite: String? {
        didSet {
            loadWebsite()
        }
    }
    
    private lazy var webView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
//        webView.scrollView.contentInsetAdjustmentBehavior = .always
        
        return webView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadWebsite() {
        guard let website = selectedWebsite, let url = URL(string: website) else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
}

extension WebView: WKNavigationDelegate {
    
}

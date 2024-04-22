//
//  GuideView.swift
//  iBox
//
//  Created by jiyeon on 4/22/24.
//

import UIKit
import WebKit

import SnapKit

class GuideView: UIView {
    
    var guideUrl: URL? {
        didSet {
            loadWebsite()
        }
    }
    
    // MARK: - UI Components
    
    private let webView: WKWebView
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        
        webView = WKWebView(frame: .zero, configuration: config)
        super.init(frame: frame)
        
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        webView.stopLoading()
        webView.isOpaque = false
    }
    
    // MARK: - Setup Methods
    
    private func setupHierarchy() {
        addSubview(webView)
    }
    
    private func setupLayout() {
        webView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.topMargin)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottomMargin)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leadingMargin)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailingMargin)
        }
    }
    
    private func loadWebsite() {
        guard let url = guideUrl else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
}

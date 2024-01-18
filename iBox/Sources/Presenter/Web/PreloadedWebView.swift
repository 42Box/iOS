//
//  PreloadedWebView.swift
//  iBox
//
//  Created by 이지현 on 1/18/24.
//

import UIKit
import WebKit

import SnapKit

class PreloadedWebView: BaseView {
    var selectedWebsite: String? {
        didSet {
            getWebView()
        }
    }
    
    private var webView: WKWebView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getWebView() {
        guard let selectedWebsite else { return }
        webView = WebViewPreloader.shared.getWebView(for: URL(string: selectedWebsite)!)
        guard let webView else { return }
        addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

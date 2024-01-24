//
//  FavoriteView.swift
//  iBox
//
//  Created by 이지현 on 1/18/24.
//

import UIKit
import WebKit

import SnapKit

class FavoriteView: PreloadedWebView {
    
    private lazy var webView = WebViewPreloader.shared.getFavoriteView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        guard let webView else { return }
        addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

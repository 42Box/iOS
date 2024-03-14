//
//  FavoriteView.swift
//  iBox
//
//  Created by 이지현 on 1/18/24.
//

import UIKit
import WebKit

import SnapKit

class FavoriteView: UIView {
    
    private lazy var webView = WebViewPreloader.shared.getFavoriteView()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperty()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        guard let webView else { return }
        backgroundColor = .backgroundColor
        webView.scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    private func setupHierarchy() {
        guard let webView else { return }
        addSubview(webView)
    }
    
    private func setupLayout() {
        guard let webView else { return }
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func handleRefreshControl() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            guard let self = self , let webView = self.webView else { return }
            webView.reload()
            refreshControl.endRefreshing()
        }
    }
    
}

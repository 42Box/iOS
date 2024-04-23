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
    
    var webView: WebView?
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        webView?.setupRefreshControl()
    }
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        backgroundColor = .backgroundColor
        
        loadFavoriteWeb()
        webView = WebViewPreloader.shared.getFavoriteView()
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
    
    private func loadFavoriteWeb() {
        let favoriteId = UserDefaultsManager.favoriteId
        var favoriteUrl: URL? = nil
        if let favoriteId {
            favoriteUrl = CoreDataManager.shared.getBookmarkUrl(favoriteId)
            if favoriteUrl == nil {
                UserDefaultsManager.favoriteId = nil
            }
        }
        WebViewPreloader.shared.preloadFavoriteView(url: favoriteUrl)
    }
    
}

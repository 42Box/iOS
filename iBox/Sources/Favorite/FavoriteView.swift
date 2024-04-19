//
//  FavoriteView.swift
//  iBox
//
//  Created by 이지현 on 1/18/24.
//

import UIKit
import SnapKit

class FavoriteView: UIView {
    
    var webView: WebView {
        if let view = WebViewPreloader.shared.getFavoriteView() {
            return view
        } else {
            loadFavoriteWeb()
            return WebViewPreloader.shared.getFavoriteView()!
        }
    }
    
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
        webView.setupRefreshControl()
    }
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        backgroundColor = .backgroundColor
    }
    
    private func setupHierarchy() {
        addSubview(webView)
    }
    
    private func setupLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadFavoriteWeb() {
        let favoriteId = UserDefaultsManager.favoriteId
        var favoriteUrl: URL? = nil
        if let favoriteId = favoriteId {
            favoriteUrl = CoreDataManager.shared.getBookmarkUrl(favoriteId)
            if favoriteUrl == nil {
                UserDefaultsManager.favoriteId = nil
            }
        }
        WebViewPreloader.shared.preloadFavoriteView(url: favoriteUrl)
    }
}

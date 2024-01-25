//
//  PreloadedWebViewController.swift
//  iBox
//
//  Created by 이지현 on 1/18/24.
//

import UIKit

class PreloadedWebViewController: BaseNavigationBarViewController<PreloadedWebView> {
    var selectedWebsite: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        guard let contentView = contentView as? PreloadedWebView else { return }
        contentView.selectedWebsite = selectedWebsite
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let selectedWebsite else { return }
        WebViewPreloader.shared.resetWebView(for: URL(string: selectedWebsite)!)
    }
    
    override func setupNavigationBar() {
        setNavigationBarHidden(true)
    }

}

//
//  PreloadedWebViewController.swift
//  iBox
//
//  Created by 이지현 on 1/18/24.
//

import UIKit

class PreloadedWebViewController: BaseNavigationBarViewController<PreloadedWebView> {
    var selectedWebsite: URL
    
    init(selectedWebsite: URL) {
        self.selectedWebsite = selectedWebsite
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        guard let contentView = contentView as? PreloadedWebView else { return }
        contentView.selectedWebsite = selectedWebsite
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        WebViewPreloader.shared.resetWebView(for: selectedWebsite)
    }
    
    override func setupNavigationBar() {
        setNavigationBarHidden(true)
    }

}

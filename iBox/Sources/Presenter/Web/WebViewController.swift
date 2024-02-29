//
//  WebViewController.swift
//  iBox
//
//  Created by 이지현 on 1/4/24.
//

import UIKit

class WebViewController: BaseNavigationBarViewController<WebView> {
    var selectedWebsite: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        navigationItem.largeTitleDisplayMode = .never
        
        guard let contentView = contentView as? WebView else { return }
        contentView.selectedWebsite = selectedWebsite
    }
    
    override func setupNavigationBar() {
        setNavigationBarHidden(true)
    }

}

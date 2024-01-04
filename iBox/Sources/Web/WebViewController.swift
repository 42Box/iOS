//
//  WebViewController.swift
//  iBox
//
//  Created by 이지현 on 1/4/24.
//

import UIKit

class WebViewController: BaseViewController<WebView> {
    var selectedWebsite: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        baseView.selectedWebsite = selectedWebsite
    }

}

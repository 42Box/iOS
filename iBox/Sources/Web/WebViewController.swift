//
//  WebViewController.swift
//  iBox
//
//  Created by 이지현 on 1/4/24.
//

import UIKit

class WebViewController: BaseViewController<WebView>, BaseViewControllerProtocol {
    
    var selectedWebsite: URL?

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        view.backgroundColor = .backgroundColor
        
        guard let contentView = contentView as? WebView else { return }
        contentView.selectedWebsite = selectedWebsite
    }
    
    // MARK: - BaseViewControllerProtocol
    
    func setupNavigationBar() {
        setNavigationBarHidden(true)
    }

}

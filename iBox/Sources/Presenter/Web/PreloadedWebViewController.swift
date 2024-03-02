//
//  PreloadedWebViewController.swift
//  iBox
//
//  Created by 이지현 on 1/18/24.
//

import UIKit

class PreloadedWebViewController: BaseViewController<PreloadedWebView>, BaseViewControllerProtocol {
    
    var selectedWebsite: URL
    
    // MARK: - Initializer
    
    init(selectedWebsite: URL) {
        self.selectedWebsite = selectedWebsite
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        navigationItem.largeTitleDisplayMode = .never
        
        guard let contentView = contentView as? PreloadedWebView else { return }
        contentView.selectedWebsite = selectedWebsite
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        WebViewPreloader.shared.resetWebView(for: selectedWebsite)
    }
    
    // MARK: - BaseViewControllerProtocol
    
    func setupNavigationBar() {
        setNavigationBarHidden(true)
    }

}

//
//  FavoriteViewController.swift
//  iBox
//
//  Created by 이지현 on 12/27/23.
//

import UIKit

class FavoriteViewController: BaseViewController<FavoriteView>, BaseViewControllerProtocol {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        WebViewPreloader.shared.resetFavoriteView()
    }
    
    // MARK: - BaseViewControllerProtocol
    
    func setupNavigationBar() {
        setNavigationBarHidden(true)
    }

}

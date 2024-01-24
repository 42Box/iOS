//
//  FavoriteViewController.swift
//  iBox
//
//  Created by 이지현 on 12/27/23.
//

import UIKit

class FavoriteViewController: BaseNavigationBarViewController<FavoriteView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = contentView as? FavoriteView else { return }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        WebViewPreloader.shared.resetFavoriteView()
    }
    
    override func setupNavigationBar() {
        setNavigationBarHidden(true)
    }

}

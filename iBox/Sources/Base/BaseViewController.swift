//
//  BaseViewController.swift
//  iBox
//
//  Created by jiyeon on 12/26/23.
//

import UIKit

class BaseViewController<View: UIView>: UIViewController {
    
    let baseView = View(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(baseView)
    }
}

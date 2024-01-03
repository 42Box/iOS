//
//  BaseView.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import UIKit

protocol BaseViewProtocol {
    func configureUI()
}

class BaseView: UIView, BaseViewProtocol {
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - BaseViewProtocol
    
    func configureUI() {}
    
}

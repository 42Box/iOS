//
//  RefreshControl.swift
//  iBox
//
//  Created by jiyeon on 4/4/24.
//

import UIKit

class RefreshControl: UIView {
    
    // MARK: - UI Components
    
    
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProperty() {
        backgroundColor = .systemBlue
        isUserInteractionEnabled = true
    }
    
}

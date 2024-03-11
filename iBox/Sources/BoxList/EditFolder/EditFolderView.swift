//
//  EditFolderView.swift
//  iBox
//
//  Created by jiyeon on 2/29/24.
//

import UIKit

class EditFolderView: UIView {
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperty()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        backgroundColor = .backgroundColor
    }
    
    private func setupHierarchy() {
        
    }
    
    private func setupLayout() {
        
    }
    
}

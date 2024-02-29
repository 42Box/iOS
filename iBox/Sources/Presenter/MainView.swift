//
//  MainView.swift
//  iBox
//
//  Created by jiyeon on 12/26/23.
//

import UIKit

import SnapKit

class MainView: UIView {
    
    // MARK: - UI
    
    var label: UILabel = {
        let label = UILabel()
        label.text = "예시입니당"
        label.textColor = .black
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - configure UI
    
    func configureUI() {
        backgroundColor = .backgroundColor
        
        addSubview(label)
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}

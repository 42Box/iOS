//
//  ErrorPageView.swift
//  iBox
//
//  Created by Chan on 4/18/24.
//

import UIKit

import SnapKit

class ErrorPageView: UIView {
    
    let messageLabel = UILabel()
    let retryButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .red
        
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        retryButton.setTitle("Retry", for: .normal)
        retryButton.backgroundColor = .systemBlue
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.layer.cornerRadius = 10
        
        addSubview(messageLabel)
        addSubview(retryButton)
    }
    
    private func setupLayout() {
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
        
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
    }
    
    func configure(with error: Error, url: URL) {
        messageLabel.text = "Failed to load \(url.absoluteString): \(error.localizedDescription)"
    }
}

//
//  BackGroundView.swift
//  iBox
//
//  Created by Chan on 2/19/24.
//

import UIKit

import SnapKit

protocol ShareExtensionBackGroundViewDelegate: AnyObject {
    func didTapCancel()
    func didTapOpenApp()
}

class ShareExtensionBackGroundView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ShareExtensionBackGroundViewDelegate?
    
    // MARK: - UI Components
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "이 링크를 iBox 앱에서 여시겠습니까?"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .label
        return label
    }()
    
    lazy var linkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.attributedTitle = .init(
            "Cancel",
            attributes: .init([.font: UIFont.systemFont(ofSize: 14)])
        )
        return button
    }()
    
    lazy var openAppButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.attributedTitle = .init(
            "Open",
            attributes: .init([.font: UIFont.boldSystemFont(ofSize: 14)])
        )
        return button
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupLayout()
        setupButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupHierarchy() {
        addSubview(label)
        addSubview(linkLabel)
        addSubview(cancelButton)
        addSubview(openAppButton)
    }
    
    private func setupLayout() {
        backgroundColor = .systemBackground
        clipsToBounds = true
        layer.cornerRadius = 10
        
        label.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        linkLabel.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        cancelButton.snp.makeConstraints {
            $0.trailing.equalTo(openAppButton.snp.leading).offset(-20)
            $0.centerY.equalTo(openAppButton.snp.centerY)
        }
        
        openAppButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupButtonAction() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        openAppButton.addTarget(self, action: #selector(openAppButtonTapped), for: .touchUpInside)
    }
    
    func updateLinkLabel(with text: String) {
        linkLabel.text = text
    }
    
    // MARK: - Actions
    
    @objc func cancelButtonTapped() {
        delegate?.didTapCancel()
    }
    
    @objc func openAppButtonTapped() {
        delegate?.didTapOpenApp()
    }
}

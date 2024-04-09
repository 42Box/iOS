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
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label
        return label
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.attributedTitle = .init(
            "Cancel",
            attributes: .init([.font: UIFont.systemFont(ofSize: 13)])
        )
        return button
    }()
    
    lazy var openAppButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.attributedTitle = .init(
            "Open",
            attributes: .init([.font: UIFont.boldSystemFont(ofSize: 13)])
        )
        return button
    }()
    
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
        backgroundColor = .systemBackground
        clipsToBounds = true
        layer.cornerRadius = 15
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        openAppButton.addTarget(self, action: #selector(openAppButtonTapped), for: .touchUpInside)
    }
    
    private func setupHierarchy() {
        addSubview(label)
        addSubview(cancelButton)
        addSubview(openAppButton)
    }
    
    private func setupLayout() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(25)
            make.leading.equalToSuperview().inset(20)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.trailing.equalTo(openAppButton.snp.leading)
            make.centerY.equalTo(openAppButton.snp.centerY)
        }
        
        openAppButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(15)
        }
    }
    
    // MARK: - Action Functions
    
    @objc func cancelButtonTapped() {
        delegate?.didTapCancel()
    }
    
    @objc func openAppButtonTapped() {
        delegate?.didTapOpenApp()
    }
}

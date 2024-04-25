//
//  BackGroundView.swift
//  iBox
//
//  Created by Chan on 2/19/24.
//

import UIKit

import SnapKit

protocol ShareExtensionPanelViewDelegate: AnyObject {
    func didTapCancel()
    func didTapOpenApp()
}

class ShareExtensionPanelView: UIView {
    
    // MARK: - Properties
    weak var delegate: ShareExtensionPanelViewDelegate?
    
    // MARK: - UI Components
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 10
        return stack
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "128")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.setContentHuggingPriority(.required, for: .horizontal)
        logoImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return logoImageView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "이 링크를 iBox 앱에서 여시겠습니까?"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label
        label.numberOfLines = 3
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .systemGray3
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()
    
    lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.opacity = 0.2
        return view
    }()
    
    lazy var openAppButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up.forward.square"), for: .normal)
        button.setTitle("앱으로 담아가기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        
        button.setTitle("앱이 실행됩니다", for: .highlighted)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.setBackgroundColor(.box2, for: .highlighted)
        button.setImage(UIImage(systemName: "heart.fill"), for: .highlighted)
        
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .box2
        
        let spacing: CGFloat = 5
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        
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
        addSubview(stackView)
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(cancelButton)
        
        addSubview(divider)
        addSubview(openAppButton)
    }
    
    private func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        openAppButton.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.width.leading.trailing.bottom.equalToSuperview()
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

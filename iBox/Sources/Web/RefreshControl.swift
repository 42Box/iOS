//
//  RefreshControl.swift
//  iBox
//
//  Created by jiyeon on 4/4/24.
//

import UIKit

import SnapKit

enum RefreshControlType {
    case addBookmark
    case refresh
    case back
}

class RefreshControl: UIView {
    
    var currentType: RefreshControlType?
    
    // MARK: - UI Components
    
    let addBookmarkButton = UIButton().then {
        $0.configuration = .plain()
        $0.tintColor = .label
        $0.configuration?.image = UIImage(systemName: "bookmark.circle")
        $0.configuration?.imagePadding = 10
        $0.configuration?.imagePlacement = .top
        $0.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 20.0)
        $0.configuration?.attributedTitle = AttributedString("북마크 추가", attributes: AttributeContainer([NSAttributedString.Key.font: UIFont.refreshControlFont]))
        $0.layer.cornerRadius = 15
    }
    
    let refreshButton = UIButton().then {
        $0.configuration = .plain()
        $0.tintColor = .label
        $0.configuration?.image = UIImage(systemName: "arrow.clockwise.circle")
        $0.configuration?.imagePadding = 10
        $0.configuration?.imagePlacement = .top
        $0.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 20.0)
        $0.configuration?.attributedTitle = AttributedString("새로고침", attributes: AttributeContainer([NSAttributedString.Key.font: UIFont.refreshControlFont]))
        $0.layer.cornerRadius = 15
    }
    
    let backButton = UIButton().then {
        $0.configuration = .plain()
        $0.tintColor = .label
        $0.configuration?.image = UIImage(systemName: "arrowshape.turn.up.backward.circle")
        $0.configuration?.imagePadding = 10
        $0.configuration?.imagePlacement = .top
        $0.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 20.0)
        $0.configuration?.attributedTitle = AttributedString("처음으로 이동", attributes: AttributeContainer([NSAttributedString.Key.font: UIFont.refreshControlFont]))
        $0.layer.cornerRadius = 15
    }
    
    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 20
    }
    
    
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
    
    // MAKR: - Setup Methods
    
    private func setupProperty() {
        isUserInteractionEnabled = true
    }
    
    private func setupHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubview(addBookmarkButton)
        stackView.addArrangedSubview(refreshButton)
        stackView.addArrangedSubview(backButton)
    }
    
    private func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    func setSelected(_ type: RefreshControlType) {
        if type == currentType { return }
        currentType = type
        clear()
        switch type {
        case .addBookmark: addBookmarkButton.backgroundColor = .tableViewBackgroundColor
        case .refresh: refreshButton.backgroundColor = .tableViewBackgroundColor
        case .back: backButton.backgroundColor = .tableViewBackgroundColor
        }
    }
    
    func clear() {
        [addBookmarkButton, refreshButton, backButton].forEach { button in
            button.backgroundColor = .clear
        }
    }
    
}

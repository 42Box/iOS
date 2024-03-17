//
//  ResetView.swift
//  iBox
//
//  Created by jiyeon on 3/14/24.
//

import UIKit

import SnapKit

class ResetView: UIView {
    
    var delegate: ResetViewDelegate?
    
    // MARK: - UI Components
    
    let label = UILabel().then {
        $0.text = "경고: 이 작업을 진행하면 저장하신 모든 폴더 및 북마크 정보가 영구적으로 삭제되고 기본값으로 초기화됩니다. 진행하기 전에 중요한 정보가 없는지 다시 한번 확인해 주시기 바랍니다."
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 15)
    }
    
    let resetButton = UIButton().then {
        $0.configuration = .plain()
        $0.configuration?.attributedTitle = .init("초기화", attributes: .init([.font: UIFont.boldSystemFont(ofSize: 15)]))
        $0.tintColor = .white
        $0.backgroundColor = .box
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
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
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        resetButton.addTarget(self, action: #selector(handleResetButtonTap), for: .touchUpInside)
    }
    
    private func setupHierarchy() {
        addSubview(label)
        addSubview(resetButton)
    }
    
    private func setupLayout() {
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        resetButton.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(20)
            make.trailing.leading.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    @objc private func handleResetButtonTap() {
        delegate?.showAlert()
    }
    
}

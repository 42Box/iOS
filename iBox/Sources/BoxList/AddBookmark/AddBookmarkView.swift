//
//  AddBookmarkBottomSheetView.swift
//  iBox
//
//  Created by jiyeon on 1/5/24.
//

import UIKit

import SnapKit

class AddBookmarkView: UIView {
    
    var onButtonTapped: (() -> Void)?
    var onTextChange: ((Bool) -> Void)?     // '추가'버튼 비활성화 관련
    
    var selectedFolderName: String? {
        didSet {
            selectedFolderLabel.text = selectedFolderName
        }
    }

    // MARK: - UI Components

    private lazy var textFieldView: UIView = UIView().then {
        $0.backgroundColor = UIColor.backgroundColor
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.addSubview(nameTextView)
        $0.addSubview(separatorView)
        $0.addSubview(urlTextView)
    }
    
    private let nameTextViewPlaceHolder = UILabel().then {
        $0.text = "북마크 이름"
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textColor = .systemGray3
    }
    
    let nameTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 0
        $0.textContainerInset = UIEdgeInsets(top: 7, left: 0, bottom: 0, right: 0)
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .label
        $0.isScrollEnabled = true
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .systemGray3
    }
    
    private let urlTextViewPlaceHolder = UILabel().then {
        $0.text = "URL"
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textColor = .systemGray3
    }
    
    let urlTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 0
        $0.textContainerInset = UIEdgeInsets(top: 7, left: 0, bottom: 0, right: 0)
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .label
        $0.isScrollEnabled = true
    }
    
    private lazy var button = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor.backgroundColor
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.isEnabled = true
        $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private let buttonLabel = UILabel().then {
        $0.text = "목록"
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = .label
    }
    
    let selectedFolderLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = .systemGray
        $0.textAlignment = .right
    }
    
    private let chevronImageView = UIImageView().then {
        let image = UIImage(systemName: "chevron.forward")?.withRenderingMode(.alwaysTemplate)
        $0.image = image
        $0.tintColor = .systemGray
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
        nameTextView.delegate = self
        urlTextView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }

    private func configureUI() {
        backgroundColor = .systemGroupedBackground
        addSubview(textFieldView)
        addSubview(nameTextViewPlaceHolder)
        addSubview(urlTextViewPlaceHolder)
        addSubview(button)
        addSubview(buttonLabel)
        addSubview(selectedFolderLabel)
        addSubview(chevronImageView)
        setupLayout()
        updateTextFieldWithIncomingURL()
    }
    
    private func setupLayout() {
        
        textFieldView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.height.equalTo(150)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        // nameTextView
        nameTextView.snp.makeConstraints { make in
            make.top.equalTo(textFieldView.snp.top).offset(10)
            make.leading.trailing.equalTo(textFieldView).offset(15)
            make.height.equalTo(30)
        }
        
        nameTextViewPlaceHolder.snp.makeConstraints { make in
            make.top.equalTo(nameTextView.snp.top).offset(7)
            make.leading.equalTo(nameTextView.snp.leading).offset(5)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(nameTextView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(nameTextView).offset(5)
            make.height.equalTo(1)
        }
        
        // urlTextView
        urlTextView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(nameTextView)
            make.bottom.equalTo(textFieldView.snp.bottom).inset(10)
        }
        
        urlTextViewPlaceHolder.snp.makeConstraints { make in
            make.top.equalTo(urlTextView.snp.top).offset(7)
            make.leading.equalTo(urlTextView.snp.leading).offset(5)
        }
        
        // button
        button.snp.makeConstraints { make in
            make.top.equalTo(textFieldView.snp.bottom).offset(20)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.height.equalTo(50)
        }
        
        
        buttonLabel.snp.makeConstraints { make in
            make.leading.equalTo(button.snp.leading).offset(20)
            make.centerY.equalTo(button.snp.centerY)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        selectedFolderLabel.snp.makeConstraints { make in
            make.trailing.equalTo(chevronImageView.snp.leading).offset(-10)
            make.centerY.equalTo(button.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalTo(button.snp.trailing).inset(20)
            make.centerY.equalTo(button.snp.centerY)
            make.width.equalTo(17)
            make.height.equalTo(17)
        }
        
    }
    
    private func updateTextFieldWithIncomingURL() {
        // GlobalURLManager의 incomingURL을 텍스트 필드에 설정
        if let incomingURL = GlobalURLManager.shared.incomingURL?.absoluteString, !incomingURL.isEmpty {
            urlTextView.text = incomingURL
            urlTextViewPlaceHolder.isHidden = true
        } else {
            urlTextView.text = ""
            urlTextViewPlaceHolder.isHidden = false
        }

        GlobalURLManager.shared.incomingURL = nil
    }
    
    @objc private func buttonTapped() {
        onButtonTapped?()
    }
}


extension AddBookmarkView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        // 텍스트 변경 시 검사를 수행하고, '추가' 버튼 활성화 상태를 업데이트
        let isBothTextViewsFilled = !nameTextView.text.isEmpty && !urlTextView.text.isEmpty
        onTextChange?(isBothTextViewsFilled)
        
        if textView == nameTextView {
            nameTextViewPlaceHolder.isHidden = !nameTextView.text.isEmpty
        }

        if textView == urlTextView {
            urlTextViewPlaceHolder.isHidden = !urlTextView.text.isEmpty
        }
        
    }
}

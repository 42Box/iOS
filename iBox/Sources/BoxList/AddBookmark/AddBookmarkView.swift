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

    private lazy var textFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.backgroundColor
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.addSubview(nameTextView)
        view.addSubview(separatorView)
        view.addSubview(urlTextView)
        return view
    }()
    
    private let nameTextViewPlaceHolder: UILabel = {
        let label = UILabel()
        label.text = "북마크 이름"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return label
    }()
    
    let nameTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.layer.borderWidth = 0 // 테두리 안보이게
        textView.textContainerInset = UIEdgeInsets(top: 7, left: 0, bottom: 0, right: 0)
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .label
        textView.isScrollEnabled = true
        return textView
    }()
    

    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    private let urlTextViewPlaceHolder: UILabel = {
        let label = UILabel()
        label.text = "URL"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return label
    }()

    
    let urlTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.layer.borderWidth = 0
        textView.textContainerInset = UIEdgeInsets(top: 7, left: 0, bottom: 0, right: 0)
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = true
        textView.textColor = .label
        textView.isScrollEnabled = true
        return textView
    }()

    
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.backgroundColor
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.isEnabled = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.text = "목록"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .label
        return label
    }()
    
    let selectedFolderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.textAlignment = .right
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "chevron.forward")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
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
        
        // 텍스트 필드뷰
        textFieldView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.height.equalTo(150)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        // name 텍스트뷰
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
        
        // url 텍스트뷰
        urlTextView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(nameTextView)
            make.bottom.equalTo(textFieldView.snp.bottom).inset(10)
        }
        
        urlTextViewPlaceHolder.snp.makeConstraints { make in
            make.top.equalTo(urlTextView.snp.top).offset(7)
            make.leading.equalTo(urlTextView.snp.leading).offset(5)
        }
        
        // 버튼
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
        
        // 선택된 폴더 레이블
        selectedFolderLabel.snp.makeConstraints { make in
            make.trailing.equalTo(chevronImageView.snp.leading).offset(-10)
            make.centerY.equalTo(button.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        // 꺽쇠 이미지
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

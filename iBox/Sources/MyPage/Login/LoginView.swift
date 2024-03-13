//
//  LoginView.swift
//  iBox
//
//  Created by Chan on 3/12/24.
//

import UIKit
import WebKit

protocol LoginViewDelegate: AnyObject {
    func loginScript(username: String?, password: String?)
    func toggleSaveUsername()
    func toggleAutoLogin()
}

class LoginView: UIView {
    weak var delegate: LoginViewDelegate?
    
    public var loginViewWebsite: URL? {
        didSet {
            loadWebsite()
        }
    }
    
    let usernameTextField = UITextField().then {
        $0.placeholder = "Login Intra"
        $0.borderStyle = .roundedRect
        $0.autocapitalizationType = .none
    }
    
    let passwordTextField = UITextField().then {
        $0.placeholder = "Password"
        $0.borderStyle = .roundedRect
        $0.isSecureTextEntry = true
        $0.autocapitalizationType = .none
    }
    
    let loginButton = UIButton().then {
        $0.setTitle("Sign In", for: .normal)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    let saveUsernameCheckBox = UIButton().then {
        $0.setImage(UIImage(systemName: "square"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        $0.addTarget(self, action: #selector(toggleSaveUsername), for: .touchUpInside)
    }
    
    let autoLoginCheckBox = UIButton().then {
        $0.setImage(UIImage(systemName: "square"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        $0.addTarget(self, action: #selector(toggleAutoLogin), for: .touchUpInside)
    }
    
    let loginWebView: WKWebView = WKWebView().then {
        $0.isOpaque = false
        $0.scrollView.contentInsetAdjustmentBehavior = .always
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperty()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        loginWebView.stopLoading()
        loginWebView.navigationDelegate = nil
        loginWebView.scrollView.delegate = nil
    }
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        loginWebView.navigationDelegate = self
        backgroundColor = .backgroundColor
    }
    
    private func setupHierarchy() {
        addSubview(loginWebView)
        addSubview(usernameTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(autoLoginCheckBox)
        addSubview(saveUsernameCheckBox)
    }
    
    private func setupLayout() {
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20) // 상단 안전 영역으로부터 20pt 아래에 위치
            make.centerX.equalToSuperview() // 뷰의 가운데에 위치
            make.width.equalToSuperview().multipliedBy(0.8) // 뷰 너비의 80%
            make.height.equalTo(44) // 높이는 44pt
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(10) // 사용자 이름 필드 아래로 10pt 간격
            make.centerX.equalToSuperview() // 뷰의 가운데에 위치
            make.width.equalTo(usernameTextField.snp.width) // 사용자 이름 필드와 같은 너비
            make.height.equalTo(44) // 높이는 44pt
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20) // 비밀번호 필드 아래로 20pt 간격
            make.centerX.equalToSuperview() // 뷰의 가운데에 위치
            make.width.equalTo(passwordTextField.snp.width) // 비밀번호 필드와 같은 너비
            make.height.equalTo(44) // 높이는 44pt
        }

        autoLoginCheckBox.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(10) // 로그인 버튼 아래로 10pt 간격
            make.centerX.equalToSuperview() // 뷰의 가운데에 위치
            make.size.equalTo(CGSize(width: 24, height: 24)) // 크기는 24x24pt
        }
        
        saveUsernameCheckBox.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.leading.equalTo(autoLoginCheckBox).offset(10)
            make.size.equalTo(CGSize(width: 24, height: 24)) // 크기는 24x24pt
        }
    }

    private func loadWebsite() {
        guard let url = loginViewWebsite else { return }
        loginWebView.load(URLRequest(url: url))
        loginWebView.allowsBackForwardNavigationGestures = true
    }
    
    // MARK: - delegate actions
    
    @objc private func loginButtonTapped() {
        delegate?.loginScript(username: usernameTextField.text, password: passwordTextField.text)
    }
    
    @objc private func toggleSaveUsername() {
        delegate?.toggleSaveUsername()
    }
    
    @objc private func toggleAutoLogin() {
        delegate?.toggleAutoLogin()
    }
}

extension LoginView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("웹뷰 로딩 실패: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("웹뷰 프로비저널 네비게이션 실패: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            print("웹뷰가 리다이렉트 되는 URL: \(url.absoluteString)")
        }
        
        decisionHandler(.allow)
    }
}

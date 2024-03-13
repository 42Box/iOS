//
//  LoginViewController.swift
//  iBox
//
//  Created by Chan on 3/12/24.
//

import UIKit
import WebKit

class LoginViewController: BaseViewController<LoginView>, BaseViewControllerProtocol {
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard contentView is LoginView else { return }
        
        if let loginView = contentView as? LoginView {
            loginView.delegate = self
        }
        
        view.backgroundColor = .backgroundColor
        
        setupNavigationBar()
        startAuthProcess()
    }
    
    // MARK: - BaseViewControllerProtocol
    
    func setupNavigationBar() {
        setNavigationBarTitleLabelText("로그인")
        setNavigationBarTitleLabelFont(.systemFont(ofSize: 17, weight: .semibold))
        setNavigationBarBackButtonHidden(false)
    }
    
    private func startAuthProcess() {
        guard let authURL = OAuthAPI.shared.createAuthURL() else {
            print("Invalid Auth URL")
            return
        }
        
        if let loginView = contentView as? LoginView {
            loginView.loginViewWebsite = authURL
        }
    }
}

extension LoginViewController: LoginViewDelegate {
    func loginScript(username: String?, password: String?) {
        guard let username = username, let password = password else { return }

        let fillFormScript = """
        document.getElementById('username').value = '\(username)';
        document.getElementById('password').value = '\(password)';
        document.getElementById('kc-login').click();
        """
        
        if let loginView = contentView as? LoginView {
            loginView.loginWebView.evaluateJavaScript(fillFormScript, completionHandler: { (result, error) in
                if let error = error as NSError? {
                    // 기본 에러 메시지 출력
                    print("JavaScript execution error: \(error.localizedDescription)")
                    
                    // 에러 도메인과 코드를 사용한 보다 세부적인 에러 처리
                    print("Error domain: \(error.domain)")
                    print("Error code: \(error.code)")
                    
                    // 에러의 userInfo 사전에서 추가적인 정보를 얻을 수 있음
                    if let failingURL = error.userInfo[NSURLErrorFailingURLErrorKey] as? String {
                        print("Failing URL: \(failingURL)")
                    }
                    
                    // 특정 에러 코드에 대한 처리 예시
                    switch error.code {
                    case NSURLErrorNotConnectedToInternet:
                        print("Internet connection is not available.")
                    case WKError.javaScriptExceptionOccurred.rawValue:
                        if let javaScriptError = error.userInfo["WKJavaScriptExceptionMessage"] as? String {
                            print("JavaScript Error Message: \(javaScriptError)")
                        }
                    default:
                        print("An unknown error occurred.")
                    }
                }
            })

        }
    }
    
    
    @objc func toggleSaveUsername() {
        
        // UserDefaults 등을 사용하여 autoLoginCheckBox.isSelected 값을 저장합니다.
    }
    
    @objc func toggleAutoLogin() {
        // keychain username + password 저장 후 로그인시 웹뷰 띄워서 로그인 시킴.
    }
}


//
//  ErrorPageViewController.swift
//  iBox
//
//  Created by Chan on 4/18/24.
//

import UIKit
import WebKit

protocol ErrorPageControllerDelegate: AnyObject {
    func presentErrorPage(_ errorPage: ErrorPageViewController)
    func backButton()
}

protocol WebViewErrorDelegate {
    func webView(_ webView: WebView, didFailWithError error: Error, url: URL?)
}

class ErrorPageViewController: UIViewController {
    weak var delegate: ErrorPageControllerDelegate?
    var webView: WebView?
    var isHandlingError = false
    
    let slideInPresentationManager = SlideInPresentationManager()
    
    init(webView: WebView) {
        super.init(nibName: nil, bundle: nil)
        self.webView = webView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ErrorPageView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperty()
        setupPresentation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        resetErrorHandling()
    }
    
    private func setupProperty() {
        if let errorPageView = view as? ErrorPageView {
            errorPageView.retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
            errorPageView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
            errorPageView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
    }
    
    func setupPresentation() {
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = slideInPresentationManager
    }
    
    func configureWithError(_ error: Error, url: String) {
        if let errorPageView = view as? ErrorPageView {
            errorPageView.configure(with: error, url: url)
        }
    }
    
    @objc private func retryButtonTapped() {
        webView?.retryLoading()
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true) {
            self.delegate?.backButton()
        }
    }

    func handleError(_ error: Error, _ url: URL?) {
        guard !isHandlingError else { return }
        isHandlingError = true
        
        if presentedViewController != nil {
            dismiss(animated: true) {
                self.configureWithError(error, url: url?.absoluteString ?? "")
                self.delegate?.presentErrorPage(self)
            }
        } else {
            configureWithError(error, url: url?.absoluteString ?? "")
            delegate?.presentErrorPage(self)
        }
    }

    func resetErrorHandling() {
        isHandlingError = false
    }
    
    private func convertErrorToViewErrorCode(_ error: Error) -> ViewErrorCode {
        if let wkError = error as? WKError {
            switch wkError.code {
            case .webContentProcessTerminated:
                return .webContentProcessTerminated
            case .webViewInvalidated:
                return .webViewInvalidated
            case .javaScriptExceptionOccurred:
                return .javaScriptExceptionOccurred
            case .javaScriptResultTypeIsUnsupported:
                return .javaScriptResultTypeIsUnsupported
            default:
                return .unknown
            }
        } else if let urlError = error as? URLError {
            return .networkError(urlError)
        }
        
        return .unknown
    }
    
    private func handleViewError(_ error: ViewErrorCode) {
        switch error {
        case .normal:
            print("OK.")
        case .unknown:
            print("Unknown error occurred in the view.")
        case .webContentProcessTerminated:
            print("Web content process has been terminated unexpectedly.")
        case .webViewInvalidated:
            print("The web view has been invalidated.")
        case .javaScriptExceptionOccurred:
            print("A JavaScript exception occurred.")
        case .javaScriptResultTypeIsUnsupported:
            print("JavaScript returned a result type that is not supported.")
        case .networkError(let urlError):
            print("Network error occurred: \(urlError.localizedDescription)")
        }
        
        AppStateManager.shared.updateViewError(error)
    }
}

extension ErrorPageViewController: WebViewErrorDelegate {
    
    func webView(_ webView: WebView, didFailWithError error: Error, url: URL?) {
            handleError(error, url)
        
        let viewErrorCode = convertErrorToViewErrorCode(error)
        handleViewError(viewErrorCode)
    }
    
}

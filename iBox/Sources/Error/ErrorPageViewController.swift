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
}

protocol WebViewErrorDelegate {
    func webView(_ webView: WebView, didFailWithError error: Error, url: URL?)
}

class ErrorPageViewController: UIViewController {
    weak var delegate: ErrorPageControllerDelegate?
    var webView: WebView?

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
        if let errorPageView = view as? ErrorPageView {
            errorPageView.retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        }
    }
    
    func configureWithError(_ error: Error, url: String) {
        if let errorPageView = view as? ErrorPageView {
            errorPageView.configure(with: error, url: url)
        }
    }
    
    @objc private func retryButtonTapped() {
        webView?.retryLoading()
        dismiss(animated: true)
    }
    
    func handleError(_ error: Error, _ url: URL?) {
        self.modalPresentationStyle = .overFullScreen
        self.configureWithError(error, url: url?.absoluteString ?? "")
        delegate?.presentErrorPage(self)
    }
}

extension ErrorPageViewController: WebViewErrorDelegate {
    
    func webView(_ webView: WebView, didFailWithError error: Error, url: URL?) {
        handleError(error, url)
    }
    
}

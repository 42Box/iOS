//
//  WebView.swift
//  iBox
//
//  Created by 이지현 on 1/4/24.
//

import UIKit
import WebKit

import SnapKit

class WebView: UIView {
    
    private var progressObserver: NSKeyValueObservation?
    
    var selectedWebsite: URL? {
        didSet {
            loadWebsite()
        }
    }
    
    // MARK: - UI Components
    
    private let webView = WKWebView().then {
        $0.isOpaque = false
        $0.scrollView.contentInsetAdjustmentBehavior = .always
    }
    
    private let progressView = UIProgressView().then {
        $0.progressViewStyle = .bar
        $0.tintColor = .label
        $0.sizeToFit()
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
    
    deinit {
        progressObserver?.invalidate()
        webView.stopLoading()
        webView.navigationDelegate = nil
        webView.scrollView.delegate = nil
    }
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        backgroundColor = .backgroundColor
        webView.navigationDelegate = self
        progressObserver = webView.observe(\.estimatedProgress, options: .new) { [weak self] webView, _ in
            self?.progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    private func setupHierarchy() {
        addSubview(webView)
        addSubview(progressView)
    }
    
    private func setupLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        progressView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
        }
    }
    
    private func loadWebsite() {
        guard let url = selectedWebsite else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
}

extension WebView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(1.0, animated: true)
        // 약간의 딜레이를 주어서 프로그레스 바가 완전히 차도록 함
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.progressView.isHidden = true
        }
    }
    
    //    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    //            print("웹뷰 로딩 실패: \(error.localizedDescription)")
    //        }
    //
    //    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    //        print("웹뷰 프로비저널 네비게이션 실패: \(error.localizedDescription)")
    //    }
    //
    //    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    //        if let url = navigationAction.request.url {
    //            print("웹뷰가 리다이렉트 되는 URL: \(url.absoluteString)")
    //        }
    //
    //        decisionHandler(.allow)
    //    }
}

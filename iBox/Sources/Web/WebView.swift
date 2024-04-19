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
    
    var delegate: WebViewDelegate?
    
    private var progressObserver: NSKeyValueObservation?
    
    var selectedWebsite: URL? {
        didSet {
            loadWebsite()
        }
    }
    
    private var refreshControlHeight: CGFloat = 120.0
    private var isActive = false
    
    // MARK: - UI Components

    
    private let webView:WKWebView
    
    private let progressView = UIProgressView().then {
        $0.progressViewStyle = .bar
        $0.tintColor = .label
        $0.sizeToFit()
    }
    
    private var refreshControl: RefreshControl?
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        
        webView = WKWebView(frame: .zero, configuration: config)
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
        webView.isOpaque = false
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
            make.top.leading.trailing.equalToSuperview()
        }
    }
    
    func setupRefreshControl() {
        // pan gesture
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe))
        panGestureRecognizer.delegate = self // UIGestureRecognizerDelegate
        addGestureRecognizer(panGestureRecognizer)
        // refresh control
        let refreshControl = RefreshControl(frame: .init(x: 0, y: -frame.size.height, width: frame.size.width, height: frame.size.height))
        webView.scrollView.addSubview(refreshControl)
        webView.scrollView.backgroundColor = .backgroundColor
        webView.scrollView.delegate = self // UIScrollViewDelegate
        self.refreshControl = refreshControl
    }
    
    private func loadWebsite() {
        guard let url = selectedWebsite else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func handleSwipe(_ gesture: UIPanGestureRecognizer) {
        guard isActive, let refreshControl = refreshControl else { return }
        
        let translation = gesture.translation(in: self)
        if gesture.state == .changed {
            if abs(translation.x) > 60.0 {
                if translation.x > 0 { // 오른쪽 스와이프 : 처음 북마크로 돌아가기
                    refreshControl.setSelected(.back)
                } else { // 왼쪽 스와이프 : 현재 링크 북마크 추가
                    refreshControl.setSelected(.addBookmark)
                }
            } else { // 아래 : 새로고침
                refreshControl.setSelected(.refresh)
            }
        } else if gesture.state == .ended { // 사용자의 터치가 끝났을 때
            switch refreshControl.currentType {
            case .addBookmark:
                guard let url = webView.url else { return }
                delegate?.pushAddBookMarkViewController(url: url)
            case .refresh:
                self.webView.reload()
            case .back:
                loadWebsite()
            case .none: break
            }
            // 제스처 완료 후 초기화
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                refreshControl.clear()
            }
        }
        // 제스처 초기화
        if gesture.state == .ended || gesture.state == .cancelled {
            gesture.setTranslation(CGPoint.zero, in: self)
            refreshControl.currentType = nil
        }
    }
    
}

extension WebView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // 로딩 시작 시 프로그레스 바를 보여주고 진행률 초기화
        progressView.isHidden = false
        progressView.setProgress(0.0, animated: false)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(1.0, animated: true)
        // 약간의 딜레이 후 프로그레스 바를 숨김
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.progressView.isHidden = true
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // "새 창으로 열기" 링크 WebView 내에서 열기
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        decisionHandler(.allow)
    }
    
}


extension WebView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -refreshControlHeight {
            isActive = true
        } else {
            isActive = false
        }
    }
    
}

extension WebView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // 다른 제스처 인식기와 동시에 인식되도록 허용
        return true
    }
    
}

//
//  ErrorPageViewController.swift
//  iBox
//
//  Created by Chan on 4/18/24.
//

import UIKit

class ErrorPageViewController: UIViewController {
    
    override func loadView() {
        self.view = ErrorPageView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let errorPageView = view as? ErrorPageView {
            errorPageView.retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        }
    }

    func configureWithError(_ error: Error, url: URL) {
        if let errorPageView = view as? ErrorPageView {
            errorPageView.configure(with: error, url: url)
        }
    }

    @objc private func retryButtonTapped() {
        dismiss(animated: true, completion: {
            // 재시도 로직 구현
        })
    }
}

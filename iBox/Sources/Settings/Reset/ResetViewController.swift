//
//  ResetViewController.swift
//  iBox
//
//  Created by jiyeon on 3/14/24.
//

import UIKit

protocol ResetViewDelegate {
    func showAlert()
}

class ResetViewController: BaseViewController<ResetView>, BaseViewControllerProtocol {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        guard let contentView = contentView as? ResetView else { return }
        contentView.delegate = self
    }
    
    // MARK: - BaseViewControllerProtocol
    
    func setupNavigationBar() {
        setNavigationBarTitleLabelText("데이터 초기화")
        setNavigationBarTitleLabelFont(.subTitlefont)
        setNavigationBarBackButtonHidden(false)
    }
    
}

extension ResetViewController: ResetViewDelegate {
    
    func showAlert() {
        let alertController = UIAlertController(title: "경고", message: "이 작업은 되돌릴 수 없습니다. 계속하려면 \"iBox\"라고 입력해 주세요.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self else { return }
            if let textField = alertController.textFields?.first, let text = textField.text, text == "iBox" {
                self.resetData()
            } else {
                self.showAlert()
            }
        }
        
        confirmAction.isEnabled = false
        confirmAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alertController.addAction(confirmAction)
        
        alertController.addTextField() { textField in
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:
                                                    {_ in
                let isTextMatch = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "iBox"
                
                confirmAction.isEnabled = isTextMatch
            })
            
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func resetData() {
        DefaultData.insertDefaultDataIfNeeded(true) {
            UserDefaultsManager.favoriteId = nil
            WebViewPreloader.shared.setFavoriteUrl(url: nil)
            NotificationCenter.default.post(name: .didResetData, object: nil)
            DispatchQueue.main.async {
                let successView = ResetSuccessView(frame: self.view.bounds)
                successView.delegate = self
                self.view.addSubview(successView)
                successView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
    }
}

// MARK: - ResetSuccessView

extension ResetViewController: ResetSuccessViewDelegate {

    func didCompleteReset() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension Notification.Name {
    static let didResetData = Notification.Name("didResetData")
}

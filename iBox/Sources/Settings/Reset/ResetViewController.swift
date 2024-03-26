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
        alertController.addTextField()
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            if let textField = alertController.textFields?.first, let text = textField.text, text == "iBox" {
                print("정말로 초기화를 해버렷당")
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showAlert()
            }
        }
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

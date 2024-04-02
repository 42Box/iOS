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
            if let textField = alertController.textFields?.first, let text = textField.text, text == "iBox" {
                self?.resetData()
                self?.navigationController?.popViewController(animated: true)
            } else {
                self?.showAlert()
            }
        }
        confirmAction.isEnabled = false
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
    
    private func storeDataHandler(defaultData: [Folder]) {
        DispatchQueue.main.async {
            CoreDataManager.shared.deleteAllFolders()
            CoreDataManager.shared.addInitialFolders(defaultData)
            UserDefaultsManager.isDefaultDataInserted = true
        }
    }
    
    private func resetHandler() {
        let urlString = "https://raw.githubusercontent.com/42Box/versioning/main/raw.json"
        
        NetworkManager.shared.fetchModel(from: urlString, modelType: VersionInfo.self) { result in
            switch result {
            case .success(let model):
                if let defaultList = model.url.filter({ $0.id == 0 }).first?.defaultList?.first?.list {
                    var bookmarks = [Bookmark]()
                    for item in defaultList {
                        if let url = URL(string: item.url) {
                            let bookmark = Bookmark(id: UUID(), name: item.name ?? "", url: url)
                            bookmarks.append(bookmark)
                        }
                    }
                    
                    let defaultData = [
                        Folder(id: UUID(), name: "42 폴더", bookmarks: bookmarks)
                    ]
                    
                    self.storeDataHandler(defaultData: defaultData)
                    
                    print("success")
                }
            case .failure(let error):
                print("Error fetching version info: \(error.localizedDescription)")
                
                let defaultData = [
                    Folder(id: UUID(), name: "42 폴더", bookmarks: [
                        Bookmark(id: UUID(), name: "42 Intra", url: URL(string: "https://profile.intra.42.fr/")!),
                        Bookmark(id: UUID(), name: "집현전", url: URL(string: "https://42library.kr/")!),
                        Bookmark(id: UUID(), name: "42Where", url: URL(string: "https://www.where42.kr/")! ),
                        Bookmark(id: UUID(), name: "42Stat", url: URL(string: "https://stat.42seoul.kr/")!),
                        Bookmark(id: UUID(), name: "24HANE", url: URL(string: "https://24hoursarenotenough.42seoul.kr/")!)
                    ])
                ]
                
                self.storeDataHandler(defaultData: defaultData)
            }
        }
    }
    
    private func resetData() {
        //        https://my-json-server.typicode.com/42Box/versioning/version/1
        
        resetHandler()
        UserDefaultsManager.favoriteId = nil
        WebViewPreloader.shared.setFavoriteUrl(url: nil)
        NotificationCenter.default.post(name: .didResetData, object: nil)
    }
    
}

extension Notification.Name {
    static let didResetData = Notification.Name("didResetData")
}

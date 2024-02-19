//
//  ShareViewController.swift
//  iBoxWebShareExtension
//
//  Created by Chan on 2/8/24.
//

import UIKit
import Social
import UniformTypeIdentifiers
import SnapKit

@objc(CustomShareViewController)
class CustomShareViewController: UIViewController {
    
    var backgroundView = ShareExtensionBackGroundView()
    var dataURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        extractSharedURL()
    }
    
    func configureUI() {
        self.view.addSubview(backgroundView)
        backgroundView.delegate = self
        backgroundView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(20)
            make.center.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    func getAppGroupUserDefaults() {
        let defaults = UserDefaults(suiteName: "group.com.iBox")
        if let data = defaults?.string(forKey: "share") {
            print("ShareViewController: URL 가져오기: \(data)")
        }
    }
    
    func hideExtensionWithCompletionHandler(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationController?.view.transform = CGAffineTransform(translationX: 0, y:self.navigationController!.view.frame.size.height)
        }, completion: completion)
    }
    
    // MARK: IBAction
    
    @IBAction func cancel() {
        self.hideExtensionWithCompletionHandler(completion: { _ in
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        })
    }
    
    @IBAction func save() {
        if dataURL != "" {
            let sharedData = dataURL
            print(sharedData)
            let defaults = UserDefaults(suiteName: "group.com.iBox")
            defaults?.set(sharedData, forKey: "shareData")
        } else {
          print("저장에 실패하였습니다.")
        }

        self.hideExtensionWithCompletionHandler(completion: { _ in
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        })
    }

    
    @IBAction func openApp() {
        if dataURL != "" {
            let sharedData = dataURL
            print(sharedData)
            let defaults = UserDefaults(suiteName: "group.com.iBox")
            defaults?.set(sharedData, forKey: "shareData")
            
            let url = URL(string: "iBox://")!
            self.extensionContext?.open(url, completionHandler: { success in
                if success {
                    print("iBox 앱이 성공적으로 열렸습니다.")
                } else {
                    print("iBox 앱을 열 수 없습니다.")
                }
                self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            })
        } else {
            print("data url 전송에 실패하였습니다.")
            self.hideExtensionWithCompletionHandler(completion: { _ in
                self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            })
        }
    }

    func extractSharedURL() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else { return }
        
        for attachment in extensionItem.attachments ?? [] {
            if attachment.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                attachment.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { [weak self] (data, error) in
                    DispatchQueue.main.async {
                        if let url = data as? URL, error == nil {
                            self?.dataURL = url.absoluteString
                            self?.backgroundView.updateLinkLabel(with: url.absoluteString)
                            print("Shared URL: \(url.absoluteString)")
                        } else {
                            print("Failed to retrieve URL: \(String(describing: error))")
                        }
                    }
                }
                break
            }
        }
    }
}

extension CustomShareViewController: ShareExtensionBackGroundViewDelegate {
    
    func didTapCancel() {
        cancel()
    }
    
    func didTapSave() {
        save()
    }
    
    func didTapOpenApp() {
        openApp()
    }
    
}

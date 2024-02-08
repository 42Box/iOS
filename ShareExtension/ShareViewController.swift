//
//  ShareViewController.swift
//  iBoxWebShareExtension
//
//  Created by Chan on 2/8/24.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: UIViewController {
    
    private let appURLString = "iBox://"
    private let groupName = "group.com.ibox"
    
    @IBOutlet weak var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let itemProvider = extensionItem.attachments?.first as? NSItemProvider else {
            return
        }
        
        // URL 타입의 데이터 로드
        if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
            itemProvider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil) { (item, error) in
                DispatchQueue.global().async {
                    if let url = item as? URL {
                        // 로드된 URL 처리
                        print("Loaded URL: \(url)")
                    } else if let error = error {
                        // 에러 처리
                        print("Error loading URL: \(error.localizedDescription)")
                    }
                }
            }
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
        self.hideExtensionWithCompletionHandler(completion: { _ in
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        })
        // UserDefaults에 데이터 저장
        if let data = self.label?.text {
            let defaults = UserDefaults(suiteName: groupName)
            defaults?.set(data, forKey: "share")
            defaults?.synchronize()
            print("ShareViewController: URL 저장 !")
        }
        // 원래 앱 열기
        if let appURL = URL(string: appURLString) {
            self.view.window?.windowScene?.open(appURL, options: nil)
        }
    }

}

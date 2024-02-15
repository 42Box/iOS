//
//  ShareViewController.swift
//  iBoxWebShareExtension
//
//  Created by Chan on 2/8/24.
//

import UIKit
import Social

@objc(CustomShareViewController)
class CustomShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1: Set the background and call the function to create the navigation bar
        self.view.backgroundColor = .systemGray6
        setupNavBar()
    }

    // 2: Set the title and the navigation items
    private func setupNavBar() {
        self.navigationItem.title = "My app"

        let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        self.navigationItem.setLeftBarButton(itemCancel, animated: false)

        let itemDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        self.navigationItem.setRightBarButton(itemDone, animated: false)
    }

    // 3: Define the actions for the navigation items
    @objc private func cancelAction () {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }

    @objc private func doneAction() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}



//class ShareViewController: SLComposeServiceViewController {
//
//    override func isContentValid() -> Bool {
//        // Do validation of contentText and/or NSExtensionContext attachments here
//        
//        // contentText : 유저가 공유하기 창을 눌러 넘어온 문자열 값(상수)
//        if let currentMessage = contentText{
//            let currentMessageLength = currentMessage.count
//            // charactersRemaining : 문자열 길이 제한 값(상수)
//            charactersRemaining = (100 - currentMessageLength) as NSNumber
//            
//            print("currentMessage : \(currentMessage) // 길이 : \(currentMessageLength) // 제한 : \(charactersRemaining)")
//            if Int(charactersRemaining) < 0 {
//                print("100자가 넘었을때는 공유할 수 없다!")
//                return false
//            }
//        }
//        return true
//    }
//
//    override func didSelectPost() {
//        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
//    
//        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
//        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
//    }
//
//    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
//    override func configurationItems() -> [Any]! {
//        let item = SLComposeSheetConfigurationItem()
//        
//        item?.title = "여기는 제목입니다"
//        // item?.tapHandler : 유저가 터치했을 때 호출되는 핸들러
//        return [item]
//    }
//}


//class ShareViewController: UIViewController {
//    
//    private let appURLString = "iBox://"
//    private let groupName = "group.com.ibox"
//    
//    @IBOutlet weak var label: UILabel?
////    
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        
////        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
////              let itemProvider = extensionItem.attachments?.first as? NSItemProvider else {
////            return
////        }
////        
////        // URL 타입의 데이터 로드
////        if itemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
////            itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { (item, error) in
////                DispatchQueue.main.async {
////                    if let url = item as? URL {
////                        // 로드된 URL 처리
////                        print("Loaded URL: \(url)")
////                    } else if let error = error {
////                        // 에러 처리
////                        print("Error loading URL: \(error.localizedDescription)")
////                    }
////                }
////            }
////        }
////    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // 1: Set the background and call the function to create the navigation bar
//        self.view.backgroundColor = .systemGray6
//        setupNavBar()
//    }
//
//    // 2: Set the title and the navigation items
//    private func setupNavBar() {
//        self.navigationItem.title = "My app"
//
//        let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
//        self.navigationItem.setLeftBarButton(itemCancel, animated: false)
//
//        let itemDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
//        self.navigationItem.setRightBarButton(itemDone, animated: false)
//    }
//
//    // 3: Define the actions for the navigation items
//    @objc private func cancelAction () {
//        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
//        extensionContext?.cancelRequest(withError: error)
//    }
//
//    @objc private func doneAction() {
//        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
//    }
//    
//    func hideExtensionWithCompletionHandler(completion: @escaping (Bool) -> Void) {
//        UIView.animate(withDuration: 0.3, animations: {
//            self.navigationController?.view.transform = CGAffineTransform(translationX: 0, y:self.navigationController!.view.frame.size.height)
//        }, completion: completion)
//    }
//    
//    // MARK: IBAction
//    
////    @IBAction func cancel() {
////        self.hideExtensionWithCompletionHandler(completion: { _ in
////            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
////        })
////    }
////    
////    @IBAction func save() {
////        self.hideExtensionWithCompletionHandler(completion: { _ in
////            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
////        })
////        // UserDefaults에 데이터 저장
////        if let data = self.label?.text {
////            let defaults = UserDefaults(suiteName: groupName)
////            defaults?.set(data, forKey: "share")
////            // UserDefaults의 synchronize() 메소드는 더 이상 필요하지 않습니다. iOS에서는 자동으로 동기화됩니다.
////            print("ShareViewController: URL 저장 !")
////        }
////        // 메인 앱으로 돌아가는 UI 제공 또는 안내 메시지 표시
////        // 예: 사용자에게 메인 앱을 열도록 요청하는 Alert 표시
////    }
//}

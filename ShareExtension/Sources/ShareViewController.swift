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
    
    var dataURL: String?
    var panelView = ShareExtensionPanelView()
    var modalView: UIView = {
        let modalview = UIView()
        modalview.backgroundColor = .clear
        return modalview
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperty()
        setupHierarchy()
        setupLayout()
        setupModal()
        extractSharedURL()
    }
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        panelView.delegate = self
    }
    
    private func setupHierarchy() {
        view.addSubview(modalView)
        modalView.addSubview(panelView)
    }
    
    private func setupLayout() {
        modalView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        panelView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.centerY.equalToSuperview().inset(20)
            make.height.equalTo(140)
        }
    }
    
    private func setupModal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap(_:)))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        modalView.addGestureRecognizer(tapGesture)
    }
    
    func hideExtensionWithCompletionHandler(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationController?.view.transform = CGAffineTransform(translationX: 0, y:self.navigationController!.view.frame.size.height)
        }, completion: completion)
    }
    
    func extractSharedURL() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else {
            print("No extension items found.")
            return
        }
        
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            for attachment in item.attachments ?? [] {
                if attachment.hasItemConformingToTypeIdentifier("public.plain-text") {
                    attachment.loadItem(forTypeIdentifier: "public.plain-text", options: nil) { (data, error) in
                        DispatchQueue.main.async {
                            if let text = data as? String {
                                self.extractURL(fromText: text)
                            } else {
                                print("Error loading text: \(String(describing: error))")
                            }
                        }
                    }
                }
            }
        }
        
        for attachment in extensionItem.attachments ?? [] {
            if attachment.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                attachment.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { [weak self] (data, error) in
                    DispatchQueue.main.async {
                        if let url = data as? URL, error == nil {
                            self?.dataURL = url.absoluteString
                            print("Shared URL: \(url.absoluteString)")
                        } else {
                            print("Failed to retrieve URL: \(String(describing: error))")
                        }
                    }
                }
                break
            } else {
                print("Attachment does not conform to URL type.")
            }
        }
    }
    
    private func extractURL(fromText text: String) {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf8.count))
        
        if let firstMatch = matches?.first, let range = Range(firstMatch.range, in: text), let url = URL(string: String(text[range])) {
            print("Extracted URL: \(url)")
            self.dataURL = url.absoluteString
        } else {
            print("No URL found in text")
        }
    }
    
    // MARK: IBAction
    
    @IBAction func cancel() {
        self.hideExtensionWithCompletionHandler(completion: { _ in
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        })
    }
    
    @objc func openURL(_ url: URL) -> Bool {
        self.hideExtensionWithCompletionHandler(completion: { _ in
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        })
        
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
    
    @objc func handleBackgroundTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        if !panelView.frame.contains(location) {
            cancel()
        }
    }
}

extension CustomShareViewController: ShareExtensionPanelViewDelegate {
    
    func didTapCancel() {
        cancel()
    }
    
    func didTapOpenApp() {
        guard let sharedURL = dataURL else {
            print("Share extension error")
            return
        }
        
        let urlString = "iBox://url?data=\(sharedURL)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let openUrl = URL(string: urlString) {
            if self.openURL(openUrl) {
                print("iBox 앱이 성공적으로 열렸습니다.")
            } else {
                print("iBox 앱을 열 수 없습니다.")
            }
        } else {
            print("url error")
            // 해당 url은 사용할 수 없음을 보여주는 뷰를 만들어야함.
        }
    }
}

extension CustomShareViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

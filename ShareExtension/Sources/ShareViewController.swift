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
import SwiftSoup

@objc(CustomShareViewController)
class CustomShareViewController: UIViewController {
    
    var dataURL: String?
    var backgroundView = ShareExtensionBackGroundView()
    var modalView: UIView = {
        let modalview = UIView()
        modalview.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
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
        backgroundView.delegate = self
    }
    
    private func setupHierarchy() {
        view.addSubview(modalView)
        modalView.addSubview(backgroundView)
    }
    
    private func setupLayout() {
        modalView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        backgroundView.snp.makeConstraints { make in
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
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else { return }
        
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
            }
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
        if !backgroundView.frame.contains(location) {
            cancel()
        }
    }
}

extension CustomShareViewController: ShareExtensionBackGroundViewDelegate {
    
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

//
//  ShareViewController.swift
//  iBoxWebShareExtension
//
//  Created by Chan on 2/8/24.
//

import UIKit
import Social
import UniformTypeIdentifiers

@objc(CustomShareViewController)
class CustomShareViewController: UIViewController {
    var label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        extractSharedURL()
    }
    
    func setupUI() {
        let shareView = UIView()
        shareView.backgroundColor = .white
        self.view.addSubview(shareView)
        
        // shareView Auto Layout 설정
        shareView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shareView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            shareView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            shareView.widthAnchor.constraint(equalToConstant: 500),
            shareView.heightAnchor.constraint(equalToConstant: 500)
        ])
        
        // Label 설정
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, World!"
        label.textColor = .black
        label.textAlignment = .center
        shareView.addSubview(label)
        
        // Label 제약 조건 추가
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: shareView.topAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: shareView.centerXAnchor),
            label.widthAnchor.constraint(equalToConstant: 200),
            label.heightAnchor.constraint(equalToConstant: 21)
        ])
        
        // Cancel Button 설정 및 제약 조건 추가
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        shareView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            cancelButton.centerXAnchor.constraint(equalTo: shareView.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 200),
            cancelButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Save Button 설정 및 제약 조건 추가
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        shareView.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: shareView.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Open App Button 설정 및 제약 조건 추가
        let saveOpenAppButton = UIButton(type: .system)
        saveOpenAppButton.setTitle("Open App", for: .normal)
        saveOpenAppButton.translatesAutoresizingMaskIntoConstraints = false
        saveOpenAppButton.addTarget(self, action: #selector(openApp), for: .touchUpInside)
        shareView.addSubview(saveOpenAppButton)
        
        NSLayoutConstraint.activate([
            saveOpenAppButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            saveOpenAppButton.centerXAnchor.constraint(equalTo: shareView.centerXAnchor),
            saveOpenAppButton.widthAnchor.constraint(equalToConstant: 200),
            saveOpenAppButton.heightAnchor.constraint(equalToConstant: 40)
        ])
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
        self.hideExtensionWithCompletionHandler(completion: { _ in
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        })
    }

    @IBAction func openApp() {
        let url = URL(string: "iBox://")!
        self.extensionContext?.open(url, completionHandler: nil)
    }

    @IBAction func openAppWithSharedDataAndCompletionAndErrorAndCompletion() {
        let url = URL(string: "iBox://")!
        self.extensionContext?.open(url, completionHandler: { success in
            print("ShareViewController: Open App with shared data and completion and error and completion: \(success)")
        })
    }
    
    func extractSharedURL() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else { return }
        
        for attachment in extensionItem.attachments ?? [] {
            if attachment.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                attachment.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { [weak self] (data, error) in
                    DispatchQueue.main.async {
                        if let url = data as? URL, error == nil {
                            // URL을 UILabel에 표시
                            self?.label.text = url.absoluteString
                            print("공유된 URL: \(url.absoluteString)")
                        } else {
                            // 에러 처리
                            print("URL을 가져오는 데 실패했습니다: \(String(describing: error))")
                        }
                    }
                }
                break // 첫 번째 URL 항목을 찾으면 반복 중단
            }
        }
    }
}

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
    
    var backgroundView = ShareExtensionBackGroundView()
    var dataURL: String?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperty()
        setupHierarchy()
        setupLayout()
        extractSharedURL()
    }
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        backgroundView.delegate = self
    }
    
    private func setupHierarchy() {
        view.addSubview(backgroundView)
    }
    
    private func setupLayout() {
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
    
    func fetchAndParseMetadata(from url: URL, completion: @escaping (Metadata) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch data: \(String(describing: error))")
                return
            }
            
            let encodingName = (response as? HTTPURLResponse)?.textEncodingName ?? "utf-8"
            let encoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding(encodingName as CFString)))

            if let htmlContent = String(data: data, encoding: encoding) {
                do {
                    let doc: Document = try SwiftSoup.parse(htmlContent)
                    let title: String? = try doc.title()
                    
                    let faviconSelectors = ["link[rel='shortcut icon']", "link[rel='icon']", "link[rel='apple-touch-icon']"]
                    var faviconUrl: String? = nil
                    
                    for selector in faviconSelectors {
                        if let faviconLink: Element = try doc.select(selector).first() {
                            if var href = try? faviconLink.attr("href"), !href.isEmpty {
                                if href.starts(with: "/") {
                                    href = url.scheme! + "://" + url.host! + href
                                } else if !href.starts(with: "http") {
                                    href = url.scheme! + "://" + url.host! + "/" + href
                                }
                                faviconUrl = href
                                break
                            }
                        }
                    }
                    
                    if faviconUrl == nil {
                        faviconUrl = url.scheme! + "://" + url.host! + "/favicon.ico"
                    }

                    let decodedUrlString = url.absoluteString.removingPercentEncoding ?? url.absoluteString
                    let metadata = Metadata(title: title, faviconUrl: faviconUrl, url: decodedUrlString)

                    DispatchQueue.main.async {
                        completion(metadata)
                    }
                } catch {
                    print("Failed to parse HTML: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

extension CustomShareViewController: ShareExtensionBackGroundViewDelegate {
    
    func didTapCancel() {
        cancel()
    }
    
    func didTapOpenApp() {
        guard let sharedURL = dataURL, let url = URL(string: sharedURL) else {
            print("Share extension error")
            return
        }
        fetchAndParseMetadata(from: url) { metadata in
            dump(metadata)
            let encodedTitle = metadata.title?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            let encodedData = metadata.url?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            let encodedFaviconUrl = metadata.faviconUrl?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            let urlString = "iBox://url?title=\(encodedTitle)&data=\(encodedData)&faviconUrl=\(encodedFaviconUrl)"
            
            if let openUrl = URL(string: urlString) {
                if self.openURL(openUrl) {
                    print("iBox 앱이 성공적으로 열렸습니다.")
                } else {
                    print("iBox 앱을 열 수 없습니다.")
                }
            }
        }
    }
}

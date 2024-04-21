//
//  URLDataManager.swift
//  iBox
//
//  Created by 최종원 on 3/5/24.
//

import UIKit

import SwiftSoup

class AddBookmarkManager {
    static let shared = AddBookmarkManager()
    
    @Published var isFetching: Bool = false
    @Published var incomingTitle: String?
    @Published var incomingData: String?
    @Published var incomingFaviconUrl: String?
    @Published var incomingError: BookmarkError?
    
    private init() {}
    
    private func update(with data: (title: String?, data: String?, faviconUrl: String?)) {
        DispatchQueue.main.async {
            self.isFetching = false
            self.incomingTitle = data.title?.removingPercentEncoding
            self.incomingData = data.data?.removingPercentEncoding
            self.incomingFaviconUrl = data.faviconUrl?.removingPercentEncoding
        }
    }
    
    private func parseHTML(_ html: String, _ url: URL) {
        do {
            let doc = try SwiftSoup.parse(html)
            let title = try doc.title()
            let faviconLink = try doc.select("link[rel='icon']").first()?.attr("href")
            
            self.update(with: (title: title, data: url.absoluteString, faviconUrl: faviconLink))
        } catch {
            self.isFetching = false
            self.incomingError = .parseError
        }
    }
    
    private func extractDataParameter(from url: URL) -> String? {
        let urlString = url.absoluteString
        
        guard let range = urlString.range(of: "url?data=") else {
            return nil
        }

        let dataParameter = urlString[range.upperBound...]
        return String(dataParameter).removingPercentEncoding
    }
    
    private func fetchWebsiteDetails(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                self?.isFetching = false
                self?.incomingError = .htmlError
                return
            }
            
            let encodingName = (response as? HTTPURLResponse)?.textEncodingName ?? "utf-8"
            let encoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding(encodingName as CFString)))

            guard let html = String(data: data, encoding: encoding) else {
                self?.isFetching = false
                self?.incomingError = .decodeError
                return
            }
            
            self?.parseHTML(html, url)
        }
        task.resume()
    }
    
    func navigateToAddBookmarkView(from url: URL, in tabBarController: UITabBarController) {
        guard url.scheme == "iBox", let urlString = extractDataParameter(from: url) else { return }
        guard let url = URL(string: urlString) else { return }
        
        incomingTitle = nil
        incomingData = nil
        incomingFaviconUrl = nil
        isFetching = true
        fetchWebsiteDetails(from: url)
        
        tabBarController.selectedIndex = 0
        
        DispatchQueue.main.async {
            guard let navigationController = tabBarController.selectedViewController as? UINavigationController,
                  let boxListViewController = navigationController.viewControllers.first as? BoxListViewController else {
                return
            }
            boxListViewController.shouldPresentModalAutomatically = true
        }
    }
    
}

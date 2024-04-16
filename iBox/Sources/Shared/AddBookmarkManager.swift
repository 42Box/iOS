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
    
    @Published var incomingTitle: String?
    @Published var incomingData: String?
    @Published var incomingFaviconUrl: String?
    
    private init() {}
    
    private func update(with data: (title: String?, data: String?, faviconUrl: String?)) {
        DispatchQueue.main.async {
            self.incomingTitle = data.title
            self.incomingData = data.data
            self.incomingFaviconUrl = data.faviconUrl
        }
    }
    
    private func parseHTML(_ html: String, _ url: URL) {
        do {
            let doc = try SwiftSoup.parse(html)
            let title = try doc.title()
            let faviconLink = try doc.select("link[rel='icon']").first()?.attr("href")
            
            self.update(with: (title: title, data: url.absoluteString, faviconUrl: faviconLink))
            
        } catch {
            print("Error parsing HTML: \(error)")
        }
    }
    
    private func extractDataParameter(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }
        return queryItems.first { $0.name == "data" }?.value
    }
    
    private func fetchWebsiteDetails(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil,
                  let html = String(data: data, encoding: .utf8) else {
                print("Error downloading HTML: \(String(describing: error))")
                return
            }
            
            self?.parseHTML(html, url)
        }
        task.resume()
    }
    
    func navigateToAddBookmarkView(from url: URL, in tabBarController: UITabBarController) {
        guard url.scheme == "iBox", let urlString = extractDataParameter(from: url) else { return }
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
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

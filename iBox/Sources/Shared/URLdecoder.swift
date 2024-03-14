//
//  URLdecoder.swift
//  iBoxShareExtension
//
//  Created by 김찬희 on 2024/03/14.
//

import Foundation

class URLdecoder {
    
    static func handleCustomURL(_ url: URL) {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        
        let title = urlComponents.queryItems?.first(where: { $0.name == "title" })?.value
        let data = urlComponents.queryItems?.first(where: { $0.name == "data" })?.value
        let faviconUrl = urlComponents.queryItems?.first(where: { $0.name == "faviconUrl" })?.value
        
        print("Title: \(title ?? "N/A")")
        print("Data URL: \(data ?? "N/A")")
        print("Favicon URL: \(faviconUrl ?? "N/A")")
    }
    
}

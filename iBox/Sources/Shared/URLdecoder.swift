//
//  URLdecoder.swift
//  iBoxShareExtension
//
//  Created by 김찬희 on 2024/03/14.
//

import Foundation

class URLdecoder {
        static func handleCustomURL(_ url: URL) -> (title: String?, data: String?, faviconUrl: String?) {
            guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return (nil, nil, nil) }
    
            let title = urlComponents.queryItems?.first(where: { $0.name == "title" })?.value
            let data = urlComponents.queryItems?.first(where: { $0.name == "data" })?.value
            let faviconUrl = urlComponents.queryItems?.first(where: { $0.name == "faviconUrl" })?.value
    
            return (title, data, faviconUrl)
        }
}

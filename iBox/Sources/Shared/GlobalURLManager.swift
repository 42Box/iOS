//
//  GlobalURLManager.swift
//  iBox
//
//  Created by 최종원 on 3/5/24.
//

import Foundation

class URLDataManager {
    static let shared = URLDataManager()
    
    var incomingTitle: String?
    var incomingData: String?
    var incomingFaviconUrl: String?

    private init() {}

    func update(with data: (title: String?, data: String?, faviconUrl: String?)) {
        incomingTitle = data.title
        incomingData = data.data
        incomingFaviconUrl = data.faviconUrl
    }
}

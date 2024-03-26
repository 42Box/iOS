//
//  WebCacheManager.swift
//  iBox
//
//  Created by jiyeon on 3/26/24.
//

import UIKit

class UUIDWrapper: NSObject {
    let uuid: UUID
    
    init(uuid: UUID) {
        self.uuid = uuid
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? UUIDWrapper else { return false }
        return uuid == other.uuid
    }
    
    override var hash: Int {
        return uuid.hashValue
    }
}

class WebCacheManager {
    
    static let shared = WebCacheManager()
    
    private let cache = NSCache<UUIDWrapper, WebViewController>()
    
    private init() {}
    
    func cacheData(forKey uuid: UUID, viewController: WebViewController) {
        let wrapper = UUIDWrapper(uuid: uuid)
        cache.setObject(viewController, forKey: wrapper)
    }
    
    func viewControllerForKey(_ uuid: UUID) -> WebViewController? {
        let wrapper = UUIDWrapper(uuid: uuid)
        return cache.object(forKey: wrapper)
    }
    
}

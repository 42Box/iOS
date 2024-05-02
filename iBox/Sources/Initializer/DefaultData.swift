//
//  DefaultData.swift
//  iBox
//
//  Created by Chan on 4/17/24.
//

import Foundation


class DefaultData {
    
    static func insertDefaultDataIfNeeded(_ isReset: Bool = false, completion: (() -> Void)? = nil) {
        let isDefaultDataInserted = UserDefaultsManager.isDefaultDataInserted
        if !isDefaultDataInserted || isReset {
            fetchDefaultData { defaultFolders in
                DispatchQueue.main.async {
                    CoreDataManager.shared.deleteAllFolders()
                    CoreDataManager.shared.addInitialFolders(defaultFolders)
                    UserDefaultsManager.isDefaultDataInserted = true
                    completion?()
                }
            }
        } else {
            completion?()
        }
    }
    
    static func fetchDefaultData(completion: @escaping ([Folder]) -> Void) {
        let localDic: [String : String] = ["Seoul" : "default-kr", "default" : "default"]
        let cityName = "Seoul"
        let local = localDic[cityName] ?? "default"
        
        let url = URL(string: "https://raw.githubusercontent.com/42Box/versioning/main/\(local).json")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching default data: \(String(describing: error))")
                completion(DefaultDataLoader.defaultData)
                return
            }
            
            do {
                let folderData = try JSONDecoder().decode(FolderData.self, from: data)
                let folders = [Folder(id: UUID(), name: "42 \(cityName)", bookmarks: folderData.list.map { Bookmark(id: UUID(), name: $0.name, url: URL(string: $0.url)!) })]
                if let defaultURLData = URL(string: folderData.favorite) {
                    DefaultDataLoader.defaultURL = defaultURLData
                }
                completion(folders)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(DefaultDataLoader.defaultData)
            }
        }.resume()
    }
}

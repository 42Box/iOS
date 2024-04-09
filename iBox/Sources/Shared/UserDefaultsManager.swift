//
//  UserDefaultsManager.swift
//  iBox
//
//  Created by jiyeon on 1/8/24.
//

import Foundation

final class UserDefaultsManager {
    
    @UserDefaultsData(key: "theme", defaultValue: Theme.system)
    static var theme: Theme
    
    @UserDefaultsData(key: "favoriteId", defaultValue: nil)
    static var favoriteId: UUID?
    
    @UserDefaultsData(key: "homeTabIndex", defaultValue: 0)
    static var homeTabIndex: Int
    
    @UserDefaultsData(key: "isDefaultDataInserted", defaultValue: false)
    static var isDefaultDataInserted: Bool
    
    @UserDefaultsData(key: "isHaptics", defaultValue: true)
    static var isHaptics: Bool
    
    @UserDefaultsData(key: "isPreload", defaultValue: false)
    static var isPreload: Bool
    
    @UserDefaultsData(key: "selectedFolderId", defaultValue: nil)
    static var selectedFolderId: UUID?

}

@propertyWrapper
struct UserDefaultsData<Value: Codable> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard
    
    var wrappedValue: Value {
        get {
            guard let data = container.object(forKey: key) as? Data else {
                return defaultValue
            }
            do {
                let value = try JSONDecoder().decode(Value.self, from: data)
                return value
            } catch {
                print("Error decoding UserDefaults data for key \(key): \(error)")
                return defaultValue
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                container.set(data, forKey: key)
            } catch {
                print("Error encoding UserDefaults data for key \(key): \(error)")
            }
        }
    }
}

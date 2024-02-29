//
//  UserDefaultsManager.swift
//  iBox
//
//  Created by jiyeon on 1/8/24.
//

import Foundation

enum UserDefaultsAccessKey: String {
    case theme          // 다크 모드
    case favorite       // 즐겨찾기
    case homeTab        // 첫 화면
}

final class UserDefaultsManager {
    static let theme = UserDefaultValue(
        key: .theme,
        defaultValue: Theme.system
    )
    static let favorite = UserDefaultValue(
        key: .favorite,
        defaultValue: Bookmark(name: "42 Intra", url: "https://profile.intra.42.fr/")
    )
    static let homeTabIndex = UserDefaultValue(
        key: .homeTab,
        defaultValue: 0
    )
}

class UserDefaultValue<T: Codable> {
    
    // MARK: - properties
    
    /// UserDefaults 항목과 연결된 키
    private var key: UserDefaultsAccessKey
    
    /// UserDefaults에서 값이 찾아지지 않을 경우 사용할 기본값
    private var defaultValue: T
    
    /// UserDefaults에 저장된 현재 값
    var value: T {
        get {
            getObject() ?? defaultValue
        } set {
            saveObject(newValue)
        }
    }
    
    // MARK: - initializer
    
    /// 키와 기본값을 사용하여 UserDefaultValue를 초기화
    init(key: UserDefaultsAccessKey, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
        if getObject() == nil { // 처음 생성될 때 디폴트값 저장
            saveObject(defaultValue)
        }
    }
    
    // MARK: - functions
    
    /// UserDefaults에서 Codable 객체를 검색
    private func getObject() -> T? {
        guard let json = UserDefaults.standard.string(forKey: key.rawValue),
              let data = json.data(using: .utf8),
              let object = try? JSONDecoder().decode(T.self, from: data)
        else {
            return nil
        }
        return object
    }
    
    /// UserDefaults에 Codable 객체를 저장
    private func saveObject(_ value: T?) {
        guard let value = value,
              let json = try? JSONEncoder().encode(value),
              let data = String(data: json, encoding: .utf8)
        else {
            removeValue()
            return
        }
        UserDefaults.standard.set(data, forKey: key.rawValue)
    }
    
    /// 키와 관련된 항목을 UserDefaults에서 제거
    private func removeValue() {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
}

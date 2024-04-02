//
//  Versioning.swift
//  iBox
//
//  Created by Chan on 2/29/24.
//

// MARK: - VersionInfo
struct VersionInfo: Codable {
    let version: [Version]
    let storeUrl: String
    let url: [URLUpdate]
}

// MARK: - URLUpdate
struct URLUpdate: Codable {
    let id: Int
    let defaultList: [URLList]?
    let remove: [URLList]?
    let add: [URLList]?
    let fix: [FixList]?

    enum CodingKeys: String, CodingKey {
        case id
        case defaultList = "default"
        case remove, add, fix
    }
}

// MARK: - URLList
struct URLList: Codable {
    let list: [URLItem]
}

// MARK: - URLItem
struct URLItem: Codable {
    let name: String?
    let url: String
}

// MARK: - FixList
struct FixList: Codable {
    let list: [FixItem]
}

// MARK: - FixItem
struct FixItem: Codable {
    let from: String
    let to: String
}

// MARK: - Version
struct Version: Codable {
    let id: Int
    let latestVersion, minRequiredVersion: String
}

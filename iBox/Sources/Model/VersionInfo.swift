//
//  Versioning.swift
//  iBox
//
//  Created by Chan on 2/29/24.
//

// MARK: - VersionInfo
struct VersionInfo: Codable {
    let version: [Version]
    let url: URLClass
}

// MARK: - URLClass
struct URLClass: Codable {
    let updateURL: String?

    enum CodingKeys: String, CodingKey {
        case updateURL = "updateUrl"
    }
}

// MARK: - Version
struct Version: Codable {
    let id: Int
    let latestVersion, minRequiredVersion: String
}

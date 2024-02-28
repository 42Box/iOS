//
//  Versioning.swift
//  iBox
//
//  Created by Chan on 2/29/24.
//

struct VersionInfo: Codable {
    let latestVersion: String
    let minRequiredVersion: String
    let updateUrl: String
}

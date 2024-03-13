//
//  AccessToken.swift
//  iBox
//
//  Created by Chan on 3/10/24.
//

import Foundation

struct AccessToken: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let refreshToken: String
    let scope: String
    let createdAt: Int
    let secretValidUntil: Int?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
        case createdAt = "created_at"
        case secretValidUntil = "secret_valid_until"
    }
}

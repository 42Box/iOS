//
//  URL+extension.swift
//  iBox
//
//  Created by Chan on 3/10/24.
//

import Foundation

extension URL {
    static func encodedParameters(for parameters: [String: String?]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: parameters, options: [])
    }
}

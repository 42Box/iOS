//
//  GlobalURLManager.swift
//  iBox
//
//  Created by 최종원 on 3/5/24.
//

import Foundation

class GlobalURLManager {
    static let shared = GlobalURLManager()

    var incomingURL: URL?

    private init() {}
}

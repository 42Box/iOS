//
//  AppStateManager.swift
//  iBox
//
//  Created by Chan on 3/2/24.
//

import Combine

class AppStateManager {
    static let shared = AppStateManager()
    
    @Published var isVersionCheckCompleted: VersionCheckCode = .initial
    
}

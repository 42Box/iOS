//
//  AppStateManager.swift
//  iBox
//
//  Created by Chan on 3/2/24.
//

import Combine

class AppStateManager {
    static let shared = AppStateManager()
    
    @Published var versionCheckCompleted: VersionCheckCode = .initial
    var currentViewErrorState: ViewErrorCode = .normal

    // 여기서 오류 상태를 업데이트하면 됩니다.
    func updateViewError(_ error: ViewErrorCode) {
        currentViewErrorState = error
    }
}

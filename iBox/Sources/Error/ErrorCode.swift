//
//  ErrorCode.swift
//  iBox
//
//  Created by Chan on 4/23/24.
//

import Foundation

enum ViewErrorCode: Equatable {
    case normal
    case unknown
    case webContentProcessTerminated
    case webViewInvalidated
    case javaScriptExceptionOccurred
    case javaScriptResultTypeIsUnsupported
    case networkError(URLError)
}

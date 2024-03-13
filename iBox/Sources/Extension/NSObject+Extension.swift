//
//  NSObject+extension.swift
//  iBox
//
//  Created by Chan on 3/12/24.
//

import Foundation

extension Then where Self: NSObject {
    
    func then(block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
    
}

extension NSObject: Then {}


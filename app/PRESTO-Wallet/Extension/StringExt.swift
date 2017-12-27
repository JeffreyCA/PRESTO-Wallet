//
//  StringExt.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2017-12-25.
//  Copyright © 2017 JeffreyCA. All rights reserved.
//

import Foundation

extension String {
    public func isAlphanumeric() -> Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    public func containsLetter() -> Bool {
        return !isEmpty && range(of: "[a-zA-Z]", options: .regularExpression) != nil
    }
    
    public func containsNumber() -> Bool {
        return !isEmpty && range(of: "[0-9]", options: .regularExpression) != nil
    }
}


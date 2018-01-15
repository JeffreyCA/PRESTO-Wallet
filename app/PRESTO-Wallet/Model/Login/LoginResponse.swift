//
//  LoginResponse.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2017-12-26.
//  Copyright © 2017 JeffreyCA. All rights reserved.
//

import Foundation

enum LoginResponse: Error {
    case LOGIN_SUCCESS
    case LOGIN_FAILURE(String)

    func get() -> String {
        switch self {
        case .LOGIN_SUCCESS:
            return "Success"
        case .LOGIN_FAILURE(let msg):
            return msg
        }
    }
}

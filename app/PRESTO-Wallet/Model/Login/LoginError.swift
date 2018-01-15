//
//  LoginError.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2017-12-25.
//  Copyright © 2017 JeffreyCA. All rights reserved.
//

enum LoginError: String, Error {
    case PASSWORD_REQUIREMENTS = "Your password must contain a minimum of one letter, one number, and be a minimum of six characters in length."
    case USERNAME_REQUIREMENTS = "Your username must contain only letters and numbers, and be a minimum of six characters in length."

    func get() -> String {
        return self.rawValue
    }
}

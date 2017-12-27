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
    case INVALID_CREDENTIALS = "You could not be logged in to your online account. Please check your username and password and try again."
    case CONNECTION_TIMEOUT = "Your connection to PRESTO website has timed out. Please try again later."
    case SERVER_DISRUPTION = "Could not connect to PRESTO website. Please try again later."

    func get() -> String {
        return self.rawValue
    }
}

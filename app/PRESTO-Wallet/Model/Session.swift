//
//  Session.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2017-12-25.
//  Copyright © 2017 JeffreyCA. All rights reserved.
//

import Foundation
import Alamofire

class Session {
    static func login(username: String, password: String) {
        print("Login: \(username), \(password)")
        let urlString = "https://www.prestocard.ca/api/sitecore/AFMSAuthentication/SignInWithAccount"
        let urlString2 = "https://www.prestocard.ca/en/dashboard/"

        Alamofire.request(urlString, method: .post, parameters: ["anonymousOrderACard": "false", "custSecurity": ["Login": username, "Password": password]], encoding: JSONEncoding.default, headers: nil).responseJSON { response in

            if let json = response.result.value {
                Alamofire.request(urlString2, method: .get, encoding: JSONEncoding.default, headers: nil).responseString { response in
                    if let html = response.result.value {
                       print(html)
                    }
                }
            }
        }
    }
}

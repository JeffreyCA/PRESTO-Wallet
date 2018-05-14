//
//  LoginService.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2017-12-25.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import Foundation
import Alamofire
import SwiftSoup

protocol LoginService {
    var delegate: LoginServiceDelegate? { get }
    // func login(withUsername username: String?, password: String?)
}

// Delegate for the LoginService
protocol LoginServiceDelegate: class {
    func loginSuccessful()
    func handle(error: String)
}

// The class is responsible for validating form input and consequently attempt to login.
class LoginServiceHandler: LoginService {
    weak var delegate: LoginServiceDelegate?

    private enum Constants {
        static let USERNAME_MIN_LENGTH = 6
        static let PASSWORD_MIN_LENGTH = 6
        static let DEFAULT_ERROR = "Error encountered."
    }

    init(delegate: LoginServiceDelegate) {
        self.delegate = delegate
    }

    func login(withUsername username: String?, password: String?) {
        let result = validateForm(userName: username ?? "", password: password ?? "")

        if result.isEmpty {
            loginWithUsernamePassword(username: username!, password: password!)
        } else {
            self.delegate?.handle(error: convertLoginResponseToString(array: result))
        }
    }

    private func loginWithUsernamePassword(username: String, password: String) {
        Alamofire.request(APIConstant.BASE_URL + APIConstant.LOGIN_PATH, method: .post,
            parameters: ["anonymousOrderACard": "false", "custSecurity": ["Login": username, "Password": password]],
            encoding: JSONEncoding.default, headers: nil).responseJSON { response in

            let loginResponse = self.getLoginResponse(response: response)

            switch loginResponse {
            case .LOGIN_SUCCESS:
                print("Success")
                // Handle login success
                self.delegate?.loginSuccessful()
            case .LOGIN_FAILURE(let error):
                print(error)
                // Handle login error
                self.delegate?.handle(error: error)
            }
        }
    }

    private func loadDashboard() {
        Alamofire.request(APIConstant.BASE_URL + APIConstant.DASHBOARD_PATH, method: .get, encoding: JSONEncoding.default, headers: nil).responseString { response in
            if let html = response.result.value {
                do {
                    let doc: Document = try SwiftSoup.parse(html)
                } catch Exception.Error(let type, let message) {
                    print(message)
                } catch {
                    print("error")
                }
            }
        }
    }
}

fileprivate extension LoginServiceHandler {
    private func getLoginResponse(response: DataResponse<Any>) -> LoginResponse {
        if let result = response.result.value as? [String: String] {
            if result["Result"] == "success" {
                return LoginResponse.LOGIN_SUCCESS
            }
        }

        return LoginResponse.LOGIN_FAILURE(response.result.value as? String ?? Constants.DEFAULT_ERROR)
    }

    func convertLoginResponseToString(array: [LoginError]) -> String {
        var errorMsg: String = String()
        var appendNewLine: Bool = false

        for error in array {
            if appendNewLine {
                errorMsg.append("\n\n")
            } else {
                appendNewLine = true
            }

            errorMsg.append(error.rawValue)
        }

        return errorMsg
    }

    func validateForm(userName username: String, password: String) -> [LoginError] {
        var errors: [LoginError] = Array()

        // Check username requirements
        if !(username.count >= Constants.USERNAME_MIN_LENGTH && username.isAlphanumeric()) {
            errors.append(LoginError.USERNAME_REQUIREMENTS)
        }

        // Check password requirements
        if !(password.count >= Constants.PASSWORD_MIN_LENGTH && password.isAlphanumeric()
            && password.containsLetter() && password.containsNumber()) {
            errors.append(LoginError.PASSWORD_REQUIREMENTS)
        }

        return errors
    }
}

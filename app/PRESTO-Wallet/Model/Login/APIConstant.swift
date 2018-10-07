//
//  APIConstant.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2017-12-26.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

struct APIConstant {
    static let BASE_URL = "https://www.prestocard.ca"
    static let LOGIN_PATH = "/api/sitecore/AFMSAuthentication/SignInWithAccount"
    static let LOGOUT_PATH = "/api/sitecore/AFMSAuthentication/Logout"
    static let TRANSACTION_CSV_PATH = "/api/sitecore/Paginator/CardActivityExportCSV"
    static let DASHBOARD_PATH = "/en/dashboard/"
    static let DASHBOARD_CARD_ACTIVITY_PATH = "/en/dashboard/card-activity"
    static let DASHBOARD_CARD_ACTIVITY_FILTERED_PATH = "/api/sitecore/Paginator/CardActivityFilteredIndex"
}

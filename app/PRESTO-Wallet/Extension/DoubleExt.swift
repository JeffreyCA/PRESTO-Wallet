//
//  DoubleExt.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2017-12-30.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import Foundation

extension Double {
    var formattedAsCad: String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_CA")
        return currencyFormatter.string(from: NSNumber(value: self))!
    }
}

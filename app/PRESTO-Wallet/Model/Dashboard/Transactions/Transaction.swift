//
//  Transaction.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2017-12-30.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import Foundation

class Transaction {
    var agency: TransitAgency
    var amount: Double
    var balance: Double
    var date: Date
    var discount: Double
    var location: String

    init(agency: TransitAgency?, amount: Double?, balance: Double?, date: Date?, discount: Double?, location: String?) {
        self.agency = agency ?? TransitAgency.PRESTO
        self.amount = amount ?? 0.99
        self.balance = balance ?? 20.00
        self.date = date ?? Date()
        self.discount = discount ?? 0.99
        self.location = location ?? "Location"
    }
}

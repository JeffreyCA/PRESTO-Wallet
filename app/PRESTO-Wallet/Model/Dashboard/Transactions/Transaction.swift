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
    var type: String
    var serviceClass: String

    var expanded: Bool

    init(csvData: [String]) {
        // Date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy h:mm:ss a"

        let lower = csvData[1].lowercased()
        // Assign appropriate transit agency
        if lower.contains("brampton") {
            self.agency = .BRAMPTON
        } else if lower.contains("burlington") {
            self.agency = .BURLINGTON
        } else if lower.contains("durham") {
            self.agency = .DURHAM
        } else if lower.contains("go") {
            self.agency = .GO
        } else if lower.contains("hamilton") {
            self.agency = .HAMILTON
        } else if lower.contains("miway") {
            self.agency = .MI_WAY
        } else if lower.contains("oakville") {
            self.agency = .OAKVILLE
        } else if lower.contains("oc") {
            self.agency = .OC_TRANSPO
        } else if lower.contains("presto") {
            self.agency = .PRESTO
        } else if lower.contains("toronto") {
            self.agency = .TTC
        } else if lower.contains("up") {
            self.agency = .UP_EXPRESS
        } else if lower.contains("york") {
            self.agency = .YRT_VIVA
        } else {
            self.agency = .PRESTO
        }

        self.date = dateFormatter.date(from: csvData[0]) ?? Date()
        self.location = csvData[2]
        self.type = csvData[3]
        self.serviceClass = csvData[4]
        self.discount = Double(csvData[5].replacingOccurrences(of: "$", with: "")) ?? 0
        self.amount = Double(csvData[6].replacingOccurrences(of: "$", with: "")) ?? 0
        self.balance = Double(csvData[7].replacingOccurrences(of: "$", with: "")) ?? 0
        self.expanded = false

        if self.type.lowercased().contains("load") {
            // Show card reloads as PRESTO agency
            self.agency = .PRESTO
        } else if self.type.lowercased().contains("fare") {
            // Show fare payments as negative amount
            self.amount *= -1
        }
    }

    init(agency: TransitAgency?, amount: Double?, balance: Double?, date: Date?, discount: Double?, location: String?, type: String?, serviceClass: String?) {
        self.date = date ?? Date()
        self.agency = agency ?? TransitAgency.PRESTO
        self.location = location ?? "Location"
        self.type = type ?? ""
        self.serviceClass = serviceClass ?? ""
        self.discount = discount ?? 0.99
        self.amount = amount ?? 0.99
        self.balance = balance ?? 20.00
        self.expanded = false
    }
}

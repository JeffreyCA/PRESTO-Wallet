//
//  FilterOptions.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2018-01-14.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import Foundation

class FilterOptions {
    var startDate: Date?
    var endDate: Date?
    var agencies: [FilterTransitAgency]?

    init(startDate: Date, endDate: Date, agencies: [FilterTransitAgency]) {
        self.startDate = startDate
        self.endDate = endDate
        self.agencies = agencies
    }
}

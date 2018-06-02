//
//  FilterTransitAgency.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2018-01-14.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import Foundation

// Wrapper class to store selected state of transit agency for filtering.
class FilterTransitAgency: Equatable {
    var agency: TransitAgency
    var enabled: Bool

    init(agency: TransitAgency, enabled: Bool) {
        self.agency = agency
        self.enabled = enabled
    }

    static func == (lhs: FilterTransitAgency, rhs: FilterTransitAgency) -> Bool {
        return lhs.agency == rhs.agency && lhs.enabled == rhs.enabled
    }
}

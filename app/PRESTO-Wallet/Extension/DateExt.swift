//
//  DateExt.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2018-05-13.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import Foundation

extension Date {
    func isBetween(_ startDate: Date, _ endDate: Date) -> Bool {
        return (min(startDate, endDate) ... max(startDate, endDate)).contains(self)
    }
}

//
//  DateExtTest.swift
//  PRESTO-WalletTests
//
//  Created by Jeffrey on 2018-05-13.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import XCTest
@testable import PRESTO_Wallet

class DateExtTest: XCTestCase {
    var firstDate: Date!
    var secondDate: Date!
    var targetDate: Date!

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSameDay() {
        firstDate = Date()
        targetDate = firstDate
        secondDate = firstDate
        XCTAssert(targetDate.isBetween(firstDate, secondDate))
        XCTAssert(targetDate.isBetween(secondDate, firstDate))
    }
    
    func testSameDayNotInRange() {
        targetDate = Date()
        firstDate = Calendar.current.date(byAdding: .day, value: -1, to: targetDate)
        secondDate = firstDate
        XCTAssertFalse(targetDate.isBetween(firstDate, secondDate))
        XCTAssertFalse(targetDate.isBetween(secondDate, firstDate))
    }

    func testFirstDateSame() {
        targetDate = Date()
        firstDate = targetDate
        secondDate = Calendar.current.date(byAdding: .day, value: -1, to: targetDate)
        XCTAssert(targetDate.isBetween(firstDate, secondDate))
        XCTAssert(targetDate.isBetween(secondDate, firstDate))
    }
    
    func testSecondDateSame() {
        targetDate = Date()
        secondDate = targetDate
        firstDate = Calendar.current.date(byAdding: .day, value: -1, to: targetDate)
        XCTAssert(targetDate.isBetween(firstDate, secondDate))
        XCTAssert(targetDate.isBetween(secondDate, firstDate))
    }
    
    func testDifferentWithinRange() {
        targetDate = Date()
        firstDate = Calendar.current.date(byAdding: .day, value: -1, to: targetDate)
        secondDate = Calendar.current.date(byAdding: .day, value: 1, to: targetDate)
        XCTAssert(targetDate.isBetween(firstDate, secondDate))
        XCTAssert(targetDate.isBetween(secondDate, firstDate))
    }
    
    func testDifferentBeforeTarget() {
        targetDate = Date()
        firstDate = Calendar.current.date(byAdding: .day, value: -7, to: targetDate)
        secondDate = Calendar.current.date(byAdding: .day, value: -1, to: targetDate)
        XCTAssertFalse(targetDate.isBetween(firstDate, secondDate))
        XCTAssertFalse(targetDate.isBetween(secondDate, firstDate))
    }
    
    func testDifferentAfterTarget() {
        targetDate = Date()
        firstDate = Calendar.current.date(byAdding: .day, value: 1, to: targetDate)
        secondDate = Calendar.current.date(byAdding: .day, value: 7, to: targetDate)
        XCTAssertFalse(targetDate.isBetween(firstDate, secondDate))
        XCTAssertFalse(targetDate.isBetween(secondDate, firstDate))
    }
}

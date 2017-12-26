//
//  StringExtensionTests.swift
//  PRESTO-WalletTests
//
//  Created by Jeffrey on 2017-12-25.
//  Copyright © 2017 JeffreyCA. All rights reserved.
//

import XCTest
@testable import PRESTO_Wallet

class StringExtension: XCTestCase {
    var testString: String!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        testString = nil
        super.tearDown()
    }
    
    func testBlankString() {
        testString = ""
        XCTAssertFalse(testString.containsLetter())
        XCTAssertFalse(testString.containsNumber())
        XCTAssertFalse(testString.isAlphanumeric())
    }
    
    func testStringContainsLetter() {
        testString = "Abc"
        XCTAssert(testString.containsLetter())
        XCTAssert(testString.isAlphanumeric())
        XCTAssertFalse(testString.containsNumber())
    }
    
    func testStringContainsNumber() {
        testString = "109"
        XCTAssert(testString.containsNumber())
        XCTAssert(testString.isAlphanumeric())
        XCTAssertFalse(testString.containsLetter())
    }
    
    func testStringAlphanumeric() {
        testString = "1a"
        XCTAssert(testString.containsLetter())
        XCTAssert(testString.containsNumber())
        XCTAssert(testString.isAlphanumeric())
    }
    
    func testStringNonAlphanumeric() {
        testString = " Abc1 09!@*() "
        XCTAssert(testString.containsLetter())
        XCTAssert(testString.containsNumber())
        XCTAssertFalse(testString.isAlphanumeric())
    }
    
    func testStringStrictlyNonAlphaNumeric() {
        testString = " ./?"
        XCTAssertFalse(testString.containsLetter())
        XCTAssertFalse(testString.containsNumber())
        XCTAssertFalse(testString.isAlphanumeric())
    }
    
    func testStringBlankSpace() {
        testString = " "
        XCTAssertFalse(testString.containsLetter())
        XCTAssertFalse(testString.containsNumber())
        XCTAssertFalse(testString.isAlphanumeric())
    }
}

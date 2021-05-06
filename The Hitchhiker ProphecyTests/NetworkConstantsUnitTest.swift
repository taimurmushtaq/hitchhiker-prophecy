//
//  NetworkConstantsUniTest.swift
//  The Hitchhiker ProphecyTests
//
//  Created by Taimur Mushtaq on 06/05/2021.
//  Copyright © 2021 SWVL. All rights reserved.
//

import XCTest

class NetworkConstantsUnitTest: XCTestCase {
    func testMD5HashValue() {
        XCTAssertEqual(NetworkConstants.getHashValue(ts: ""), "384bec93b7c1a61aa4e4b7366d7b4adf")
        XCTAssertEqual(NetworkConstants.getHashValue(ts: "1"), "6d9ff321d28b685aaa060d8d7131383b")
        XCTAssertEqual(NetworkConstants.getHashValue(ts: "1234"), "43f5ece7345d6e491f54d36b49988fe8")
    }
}

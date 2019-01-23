//
//  FastEyeTests.swift
//  FastEyeTests
//
//  Created by Nicholas Allio on 23/01/2019.
//  Copyright © 2019 Nicholas Allio. All rights reserved.
//

import XCTest

@testable import FastEye

class GameManagerTests: XCTestCase {

    var gmTest: GameManager!
    
    override func setUp() {
        super.setUp()
        gmTest = GameManager()
    }

    override func tearDown() {
        gmTest = nil
        super.tearDown()
    }

    func testGameManager() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(1 == 1, "1 equals 1")
        XCTAssert(1 == 0, "1 not equals 0")
    }

}

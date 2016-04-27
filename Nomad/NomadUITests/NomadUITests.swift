//
//  NomadUITests.swift
//  NomadUITests
//
//  Created by Kristin Beese on 4/27/16.
//  Copyright © 2016 Team 9. All rights reserved.
//

import XCTest

class NomadUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        sleep(1)
        snapshot("0-home")
        
        let app = XCUIApplication()
        app.buttons["my adventures"].tap()
        
        snapshot("1-adventures")

        let tablesQuery = app.tables
        tablesQuery.staticTexts["Sample: Paris and London! with Carolyn, and me Fri, June 12, 2015 - Wed, June 17, 2015"].tap()

        snapshot("2-trip")
        
        tablesQuery.staticTexts["View Map 🗺"].tap()
        
        sleep(2)
        snapshot("3-map")

        app.navigationBars["Map"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
        
        app.swipeUp()
        app.swipeUp()
        
        app.tables.staticTexts["Love Locks Sat, June 13, 2015 at 12:44 PM"].tap()

        sleep(2)
        snapshot("4-trip")
    }
    
}

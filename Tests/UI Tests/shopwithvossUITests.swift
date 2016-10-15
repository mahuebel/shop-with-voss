//
//  shopwithvossUITests.swift
//  shopwithvossUITests
//
//  Created by Chris Voss on 10/15/16.
//  Copyright © 2016 Voss Creative. All rights reserved.
//

import XCTest

class shopwithvossUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCartEditing() {
        let app = XCUIApplication()
        let addToCartButton = app.buttons["Add to cart"]
        addToCartButton.tap()
        addToCartButton.tap()
        addToCartButton.tap()
        app.otherElements["Your cart"].tap()
        
        XCTAssertTrue(app.buttons["Check out ($2.85)"].exists)
        
        app.navigationBars["Cart (3)"].buttons["Edit"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.children(matching: .cell).element(boundBy: 1).buttons["Delete Peas, $0.95"].tap()
        tablesQuery.buttons["Delete"].tap()
        
        XCTAssertTrue(app.buttons["Check out ($1.90)"].exists)

        let cart2NavigationBar = app.navigationBars["Cart (2)"]
        cart2NavigationBar.buttons["Done"].tap()
        cart2NavigationBar.buttons["Cancel"].tap()
    }
    
}

//
//  PriceFormatterTests.swift
//  shopwithvoss
//
//  Created by Chris Voss on 10/15/16.
//  Copyright © 2016 Voss Creative. All rights reserved.
//

import XCTest
@testable import Shop

class PriceFormatterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFormatting() {
        let formatter = PriceFormatter()

        XCTAssertEqual(formatter.formattedPrice(for: 199), "$1.99")
        XCTAssertEqual(formatter.formattedPrice(for: 19900), "$199.00")
        XCTAssertEqual(formatter.formattedPrice(for: 1990042), "$19,900.42")
        XCTAssertEqual(formatter.formattedPrice(for: 42), "$0.42")
    }
    
}

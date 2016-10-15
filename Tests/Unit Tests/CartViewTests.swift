//
//  CartViewTests.swift
//  shopwithvoss
//
//  Created by Chris Voss on 10/15/16.
//  Copyright © 2016 Voss Creative. All rights reserved.
//

import XCTest
@testable import Shop

class CartViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShadowAdded() {
        let view = CartView(backgroundColor: .blue, width: 1000)
        XCTAssertTrue(view.layer.shadowOpacity > 0)
    }
}

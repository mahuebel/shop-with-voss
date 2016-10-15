//
//  ProductTests.swift
//  shopwithvoss
//
//  Created by Chris Voss on 10/15/16.
//  Copyright © 2016 Voss Creative. All rights reserved.
//

import XCTest
@testable import Shop

class ProductTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEquatable() {
        let p1 = Product(name: "Product A", details: "", price: 100, videoURL: nil)
        let p2 = Product(name: "Product B", details: "", price: 100, videoURL: nil)
        let p3 = Product(name: "Product A", details: "", price: 200, videoURL: nil)
        
        XCTAssertEqual(p1, p3)
        XCTAssertNotEqual(p1, p2)
        XCTAssertNotEqual(p2, p3)
    }
    
}

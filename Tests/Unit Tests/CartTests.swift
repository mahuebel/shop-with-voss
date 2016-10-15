//
//  CartTests.swift
//  shopwithvoss
//
//  Created by Chris Voss on 10/15/16.
//  Copyright © 2016 Voss Creative. All rights reserved.
//

import XCTest
@testable import Shop

class CartTests: XCTestCase {
    
    let cart = Cart()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEditing() {
        let product = Product(name: "Test", details: "", price: 199, videoURL: nil)
        XCTAssertEqual(cart.count, 0)
        cart.add(product)
        XCTAssertEqual(cart.count, 1)
        cart.remove(at: 0)
        XCTAssertEqual(cart.count, 0)
    }
    
    func testDetails() {
        let product1 = Product(name: "Test 1", details: "", price: 199, videoURL: nil)
        let product2 = Product(name: "Test 2", details: "", price: 42, videoURL: nil)
        let product3 = Product(name: "Test 3", details: "", price: 1999, videoURL: nil)

        XCTAssertEqual(cart.totalPrice, 0)
        cart.add(product1)
        XCTAssertEqual(cart.totalPrice, product1.price)
        cart.add(product2)
        XCTAssertEqual(cart.totalPrice, product1.price + product2.price)
        cart.add(product3)
        XCTAssertEqual(cart.totalPrice, product1.price + product2.price + product3.price)
        cart.remove(at: 0)
        XCTAssertEqual(cart.totalPrice, product2.price + product3.price)
        
        let first = cart.product(at: 0)
        XCTAssertEqual(first.name, "Test 2")
    }
    
    func testDuplicateProducts() {
        let product = Product(name: "Test", details: "", price: 199, videoURL: nil)

        XCTAssertEqual(cart.count, 0)
        cart.add(product)
        cart.add(product)
        XCTAssertEqual(cart.count, 2)
    }
}

//
//  NetworkTests.swift
//  shopwithvoss
//
//  Created by Chris Voss on 10/16/16.
//  Copyright © 2016 Voss Creative. All rights reserved.
//

import XCTest
@testable import Shop

class MockService: CurrencyConversionService {
    let currenciesListEndpoint: URL?
    var realtimeRatesEndpoint: URL?
    
    init() {
        currenciesListEndpoint = Bundle(for: MockService.self).url(forResource: "list", withExtension: "json")
        realtimeRatesEndpoint = Bundle(for: MockService.self).url(forResource: "rates", withExtension: "json")
    }
}

class MockSession: Session {
    var response: URLResponse?
    var data: Data?
    var error: NSError?

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> SessionDataTask {
        
        completionHandler(data, response, error)

        return MockTask()
    }
}

class MockTask: SessionDataTask {
    func resume() {
        
    }
}

class FetchCurrenciesOperationTests: XCTestCase {
    
    let service = MockService()
    
    override func setUp() {
        super.setUp()        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSuccess() {
        let expectation = self.expectation(description: "Should fetch currencies")
        let url = service.currenciesListEndpoint!
        let session = MockSession()
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.data = try! Data(contentsOf: url)
        session.response = response
        
        let operation = FetchCurrenciesOperation(url: url, session: session)
        
        operation.fetchedCurrenciesHandler = { currencies in
            expectation.fulfill()
            
            XCTAssertEqual(currencies.count, 168)
        }
        
        operation.errorHandler = { error in
            XCTFail(error?.localizedDescription ?? "Failed")
        }
        
        OperationQueue.main.addOperation(operation)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testBadStatusCode() {
        let expectation = self.expectation(description: "Should fail")
        let url = service.currenciesListEndpoint!
        let session = MockSession()
        let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
        session.data = try! Data(contentsOf: url)
        session.response = response
        
        let operation = FetchCurrenciesOperation(url: url, session: session)
        
        operation.fetchedCurrenciesHandler = { currencies in
            XCTFail()
        }
        
        operation.errorHandler = { error in
            expectation.fulfill()
        }
        
        OperationQueue.main.addOperation(operation)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testError() {
        let expectation = self.expectation(description: "Should fail")
        let url = service.currenciesListEndpoint!
        let session = MockSession()
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.data = try! Data(contentsOf: url)
        session.response = response
        session.error = NSError(domain: "test", code: 101, userInfo: nil)
        
        let operation = FetchCurrenciesOperation(url: url, session: session)
        
        operation.fetchedCurrenciesHandler = { currencies in
            XCTFail()
        }
        
        operation.errorHandler = { error in
            expectation.fulfill()
        }
        
        OperationQueue.main.addOperation(operation)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
}

class FetchRealtimeRatesOperationTests: XCTestCase {
    
    let service = MockService()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSuccess() {
        let expectation = self.expectation(description: "Should fetch rates")
        let url = service.realtimeRatesEndpoint!
        let session = MockSession()
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.data = try! Data(contentsOf: url)
        session.response = response
        
        let operation = FetchRealtimeRatesOperation(session: session, currencyCodes: ["TEST"], url: url)
        
        operation.fetchedRatesHandler = { rates in
            expectation.fulfill()
            
            XCTAssertEqual(rates["USDEUR"], 0.911404)
        }
        
        operation.errorHandler = { error in
            XCTFail(error?.localizedDescription ?? "Failed")
        }
        
        OperationQueue.main.addOperation(operation)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testBadStatusCode() {
        let expectation = self.expectation(description: "Should fail")
        let url = service.realtimeRatesEndpoint!
        let session = MockSession()
        let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
        session.data = try! Data(contentsOf: url)
        session.response = response
        
        let operation = FetchRealtimeRatesOperation(session: session, currencyCodes: ["TEST"], url: url)
        
        operation.fetchedRatesHandler = { rates in
            XCTFail()
        }
        
        operation.errorHandler = { error in
            expectation.fulfill()
        }
        
        OperationQueue.main.addOperation(operation)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testError() {
        let expectation = self.expectation(description: "Should fail")
        let url = service.realtimeRatesEndpoint!
        let session = MockSession()
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.data = try! Data(contentsOf: url)
        session.response = response
        session.error = NSError(domain: "test", code: 101, userInfo: nil)
        
        let operation = FetchRealtimeRatesOperation(session: session, currencyCodes: ["TEST"], url: url)
        
        operation.fetchedRatesHandler = { rates in
            XCTFail()
        }
        
        operation.errorHandler = { error in
            expectation.fulfill()
        }
        
        OperationQueue.main.addOperation(operation)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
}

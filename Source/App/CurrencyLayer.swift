//
// CurrencyLayer.swift
//
// MIT License
//
// Copyright (c) 2016 Chris Voss
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation
import os

/// A service that can provide currency codes and rates
public protocol CurrencyConversionService {
    var currenciesListEndpoint: URL? { get }
    var realtimeRatesEndpoint: URL? { get }
}

/// Client that interacts with the [CurrencyLayer](https://currencylayer.com/) service. NOTE: Only supports functionality needed for the demo app
final public class CurrencyLayer: CurrencyConversionService {
    
    // MARK: - Initialization
    
    public init(accessKey: String) {
        self.accessKey = accessKey
    }
    
    // MARK: - Fetch data
    
    public typealias FailureHandler = ((Error?) -> Void)
    public typealias SuccessHandler = (([String : String]) -> Void)
    public typealias RateSuccessHandler = (([String : Double]) -> Void)
    
    // MARK: - Endpoints
    
    lazy public var currenciesListEndpoint: URL? = {
        guard let url = self.buildURL(for: "/api/list") else {
            os_log("bad url")
            return nil
        }
        
        return url
    }()
    
    lazy public var realtimeRatesEndpoint: URL? = {
        guard let url = self.buildURL(for: "/api/live") else {
                os_log("bad url")
                return nil
        }
        
        return url
    }()
    
    internal func buildURL(for path: String) -> URL? {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.path = path
        
        let items = [
            URLQueryItem(name: "access_key", value: accessKey),
            URLQueryItem(name: "format", value: "1"), // for json support
        ]

        components?.queryItems = items
        
        guard let url = components?.url else {
            os_log("Invalid url")
            return nil
        }
        
        return url
    }
    
    // MARK: - Private
    
    fileprivate let baseURL: URL = URL(string: "http://apilayer.net/")!
    
    /// API Key
    fileprivate let accessKey: String
}

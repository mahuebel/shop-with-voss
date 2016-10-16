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

/// Client that interacts with the [CurrencyLayer](https://currencylayer.com/) service. NOTE: Only supports functionality needed for the demo app
final public class CurrencyLayer {
    
    public init(accessKey: String, urlSession: URLSession = URLSession.shared) {
        self.accessKey = accessKey
        self.session = urlSession
    }
    
    // MARK: - Fetch data
    
    public typealias FailureHandler = ((Error?) -> Void)
    public typealias SuccessHandler = (([String : String]) -> Void)
    public typealias RateSuccessHandler = (([String : Double]) -> Void)
    
    public func fetchListOfAvailableCurrencies(success: @escaping SuccessHandler, failure: @escaping FailureHandler) {
        
        guard let url = buildURL(for: "/api/list") else {
            os_log("bad url")
            failure(nil)
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                failure(error)
                return
            }
            
            guard let urlResponse = response as? HTTPURLResponse, let data = data else {
                failure(nil)
                return
            }
            
            if urlResponse.statusCode != 200 {
                failure(nil) // TODO: better error handling
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
                if let quotes = json?["currencies"] as? [String : String] {
                    success(quotes)
                } else {
                    failure(nil)
                }
            } catch {
                failure(error)
                return
            }
        }
        
        task.resume()
    }
    
    public func fetchRealTimeRates(for currencyCode: String, success: @escaping RateSuccessHandler, failure: @escaping FailureHandler) {
        
        guard let url = buildURL(for: "/api/live", with: [
            URLQueryItem(name: "currencies", value: currencyCode)
            ]) else {
                os_log("bad url")
                failure(nil)
                return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                failure(error)
                return
            }
            
            guard let urlResponse = response as? HTTPURLResponse, let data = data else {
                failure(nil)
                return
            }
            
            if urlResponse.statusCode != 200 {
                failure(nil) // TODO: better error handling
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
                if let quotes = json?["quotes"] as? [String : Double] {
                    success(quotes)
                } else {
                    failure(nil)
                }
            } catch {
                failure(error)
                return
            }
        }
        
        task.resume()
    }
    
    internal func buildURL(for path: String, with additionalQueryItems: [URLQueryItem]? = nil) -> URL? {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.path = path
        
        var items = [
            URLQueryItem(name: "access_key", value: accessKey),
            URLQueryItem(name: "format", value: "1"), // for json support
        ]
        
        if let additionalQueryItems = additionalQueryItems {
            items += additionalQueryItems
        }
        
        components?.queryItems = items
        
        guard let url = components?.url else {
            os_log("Invalid url")
            return nil
        }
        
        return url
    }
    
    // MARK: - Private
    
    fileprivate let baseURL: URL = URL(string: "http://apilayer.net/")!
    
    fileprivate let session: URLSession
    
    /// API Key
    fileprivate let accessKey: String
}

//
// FetchRealtimeRatesOperation.swift
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

/// Operation that fetches realtime rates for currency codes
final public class FetchRealtimeRatesOperation: Operation {
    
    /// Handler called after rates are fetched from network
    public var fetchedRatesHandler: (([String : Double]) -> Void)?
    
    /// Handler called if an error occurs
    public var errorHandler: ((Error?) -> Void)?
    
    // MARK: - Initialization
    
    /// Returns a new operation that fetches currencies
    public init(session: URLSession = URLSession.shared, currencyCodes: [String]) {
        self.session = session
        self.currencyCodes = currencyCodes
    }
    
    // MARK: - Operation
    
    public override func start() {
        let currencyLayer = CurrencyLayer(accessKey: Prototype.CurrencyLayerKey)
        
        guard let urlWithoutCurrencies = currencyLayer.realtimeRatesEndpoint else {
            errorHandler?(nil)
            return
        }
        
        var components = URLComponents(url: urlWithoutCurrencies, resolvingAgainstBaseURL: false)
        let commaSeperatedCurrencies = currencyCodes.joined(separator: ",")
        components?.queryItems?.append(URLQueryItem(name: "currencies", value: commaSeperatedCurrencies))
        guard let url = components?.url else {
            errorHandler?(nil)
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                self?.errorHandler?(error)
                return
            }
            
            guard let urlResponse = response as? HTTPURLResponse, let data = data else {
                self?.errorHandler?(nil)
                return
            }
            
            if urlResponse.statusCode != 200 {
                self?.errorHandler?(nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
                if let quotes = json?["quotes"] as? [String : Double] {
                    self?.fetchedRatesHandler?(quotes)
                } else {
                    self?.errorHandler?(nil)
                }
            } catch {
                self?.errorHandler?(error)
                return
            }
        }
        
        task.resume()
    }
    
    // MARK: - Private
    
    fileprivate let session: URLSession
    
    fileprivate let currencyCodes: [String]
}

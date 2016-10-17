//
// FetchCurrenciesOperation.swift
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

/// Operation that fetches available currencies to use
final public class FetchCurrenciesOperation: Operation {
    
    /// Handler called after currencies are fetched from network
    public var fetchedCurrenciesHandler: (([String : String]) -> Void)?
    
    /// Handler called if an error occurs
    public var errorHandler: ((Error?) -> Void)?
    
    // MARK: - Initialization
    
    /// Returns a new operation that fetches currencies
    public init(url: URL, session: Session = URLSession.shared) {
        self.session = session
        self.url = url
    }
    
    // MARK: - Operation
    
    public override func main() {
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.errorHandler?(error)
                return
            }
            
            guard let urlResponse = response as? HTTPURLResponse, let data = data else {
                self.errorHandler?(nil)
                return
            }
            
            if urlResponse.statusCode != 200 {
                self.errorHandler?(nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
                if let currencies = json?["currencies"] as? [String : String] {
                    self.fetchedCurrenciesHandler?(currencies)
                } else {
                    self.errorHandler?(nil)
                }
            } catch {
                self.errorHandler?(error)
                return
            }
        }
        
        task.resume()
    }
    
    // MARK: - Private
    
    fileprivate let session: Session
    
    fileprivate let url: URL
}

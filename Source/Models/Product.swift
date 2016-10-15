//
// Product.swift
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

public typealias Cents = Int

/// A product available for purchase
public struct Product {
    
    /// Details about the product
    public let details: String
    
    /// The name of the product
    public let name: String
    
    // The cost of the product (in cents)
    public let price: Cents
    
    // URL to a promotional video about the product
    public let videoURL: URL?
    
    /// Returns a fresh new product
    init(name: String, details: String, price: Cents, videoURL: URL?) {
        self.details = details
        self.name = name
        self.price = price
        self.videoURL = Bundle.main.url(forResource: "test", withExtension: "m4v") // TODO: placeholder
    }
}

extension Product: Equatable { }

public func ==(lhs: Product, rhs: Product) -> Bool {
    return lhs.name == rhs.name
}

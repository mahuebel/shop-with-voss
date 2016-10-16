//
// PriceFormatter.swift
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

/// Formats a price
public final class PriceFormatter {
    
    /// Set the currency code to change the currency locale
    public var currencyCode: String? {
        didSet {
            formatter.currencyCode = currencyCode
        }
    }
    
    /// Set the exchange rate to adjust the cost displayed to the user
    public var exchangeRate = 1.0
    
    /// Returns a user-friendly price for display
    public func formattedPrice(for cents: Int) -> String? {
        let adjustedCents: Double = Double(cents) * exchangeRate
        let dollars: Double = adjustedCents * 0.01
        
        formatter.maximumFractionDigits = dollars < 0.01 ? 6 : 2 // hack to support bitcoin (BTC)
        
        return formatter.string(from: NSNumber(value: dollars))
    }
    
    // MARK: - Private
    
    fileprivate let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter
    }()
}

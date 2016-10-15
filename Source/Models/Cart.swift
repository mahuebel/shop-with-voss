//
// Cart.swift
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

/// A shopping cart that you can add (or remove) items from
final public class Cart {
    
    // MARK: - Editing cart contents
    
    /// Add a product to the cart
    public func add(_ product: Product) {
        products.append(product)
    }
    
    /// Remove a product from the cart
    public func remove(at index: Int) {
        products.remove(at: index)
    }
    
    // MARK: - Cart details
    
    /// The total quantity of products in the cart (not unique products)
    public var count: Int {
        return products.count
    }

    /// Returns the product at a given index
    public func product(at index: Int) -> Product {
        return products[index]
    }
    
    /// Returns the total price of all items in the cart
    var totalPrice: Cents {
        return products.reduce(0, { $0 + $1.price })
    }
    
    // MARK: - Private
    
    fileprivate var products = [Product]()
}

//
// Prototype.swift
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
import UIKit

/// Prototype-specific assets and configuration
internal struct Prototype {
        
    /// Normally you wouldn't want to check your API key in to source control
    static let CurrencyLayerKey = "30b071c13295ef427beaacb287c6d3d9"
    
    /// Colors used in the prototype
    struct Colors {
        static let primary = UIColor(red:0.98, green:0.42, blue:0.22, alpha:1.00)
        static let secondary = UIColor(red:0.14, green:0.18, blue:0.22, alpha:1.00)
    }
    
    /// Products used in the prototype
    struct Products {
        static let beans: Product = {
            return Product(name: NSLocalizedString("Beans", comment: "Beans title"), details: NSLocalizedString("One can of beans", comment: "Beans description"), price: 73, videoURL: nil)
        }()
        
        static let eggs: Product = {
            return Product(name: NSLocalizedString("Eggs", comment: "Eggs title"), details: NSLocalizedString("One dozen eggs", comment: "Eggs description"), price: 210, videoURL: nil)
        }()
        
        static let milk: Product = {
            return Product(name: NSLocalizedString("Milk", comment: "Milk title"), details: NSLocalizedString("One bottle of milk", comment: "Milk description"), price: 130, videoURL: nil)
        }()
        
        static let peas: Product = {
            return Product(name: NSLocalizedString("Peas", comment: "Peas title"), details: NSLocalizedString("One bag of peas", comment: "Peas description"), price: 95, videoURL: nil)
        }()
    }
}

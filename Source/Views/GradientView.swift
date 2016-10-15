//
// GradientView.swift
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

/// Yet another (basic) gradient view (with IBDesignable support)
@IBDesignable class GradientView: UIView {
    
    // MARK: - Public
    
    /// The starting color
    @IBInspectable var from: UIColor = .darkGray {
        didSet {
            setupView()
        }
    }
    
    /// The end color
    @IBInspectable var to: UIColor = .black {
        didSet {
            setupView()
        }
    }
    
    /// The starting point
    @IBInspectable var startPoint: Float = 0.0 {
        didSet {
            setupView()
        }
    }
    
    /// The end point
    @IBInspectable var endPoint: Float = 1.0 {
        didSet {
            setupView()
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    // MARK: - UIView
    
    override class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }

    // MARK: - Private
    
    // Setup the view appearance
    fileprivate func setupView(){
        let colors: Array = [from.cgColor, to.cgColor]
        
        gradientLayer?.colors = colors
        gradientLayer?.locations = [NSNumber(value: startPoint), NSNumber(value: endPoint)]
        
        setNeedsDisplay()
    }
    
    fileprivate var gradientLayer: CAGradientLayer? {
        return layer as? CAGradientLayer
    }
}

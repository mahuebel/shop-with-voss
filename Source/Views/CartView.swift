//
// CartView.swift
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

/// A view that represents the user's shopping cart
final public class CartView: UIView {
    
    // MARK: - Public
    
    /// Handles when the user taps the cart
    public var tapHandler: ((Void) -> Void)?
    
    // MARK: - Initialization
    
    /// Returns a new cart view. The `width` will be used as the width and height of the view since it should only be shown as a circle
    public init(backgroundColor: UIColor = .green, width: CGFloat) {
        super.init(frame: .zero)
        
        cartButton.backgroundColor = backgroundColor
        cartButton.addTarget(self, action: #selector(didTapCartButton(_:)), for: .touchUpInside)
        addSubview(cartButton)
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: width),
            
            cartButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 2),
            cartButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            cartButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2),
            cartButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2)
            ])
        
        addBorder()
        addShadow()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIView
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        updatePath()
    }
    
    // MARK: - Private
    
    fileprivate func addBorder() {
        cartButton.layer.borderWidth = 1
        cartButton.layer.borderColor = UIColor.white.cgColor
    }
    
    fileprivate func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.3
    }
    
    fileprivate let cartButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("cart", for: .normal) // TODO: placeholder
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    @objc fileprivate func didTapCartButton(_ sender: UIButton) {
        tapHandler?()
    }

    fileprivate func updatePath() {
        let cornerRadius = cartButton.frame.size.width / 2
        cartButton.layer.cornerRadius = cornerRadius
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: frame.size.width / 2).cgPath
    }
}

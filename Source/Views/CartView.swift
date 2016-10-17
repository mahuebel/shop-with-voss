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
    
    /// The total cost of items in the cart
    public var total: String? {
        didSet {
            let unwrappedTotal = total ?? ""
            let checkoutString = NSLocalizedString("View cart", comment: "Tap to view cart")
            textLabel.text = "\(unwrappedTotal)\n\(checkoutString)"
        }
    }
    
    // MARK: - Initialization
    
    /// Returns a new cart view. The `width` will be used as the width and height of the view since it should only be shown as a circle
    public init(backgroundColor: UIColor = .green, width: CGFloat) {
        super.init(frame: .zero)
        
        cartButton.backgroundColor = backgroundColor
        cartButton.addTarget(self, action: #selector(didTapCartButton(_:)), for: .touchUpInside)
        addSubview(cartButton)
        addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: width),
            
            cartButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 2),
            cartButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            cartButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2),
            cartButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),
            
            textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 10)
            ])
        
        addBorder()
        addShadow()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Feedback
    
    public func popFeedback() {
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.prepare()
        feedback.impactOccurred()
    }
    
    public func snapFeedback() {
        let feedback = UIImpactFeedbackGenerator(style: .heavy)
        feedback.prepare()
        feedback.impactOccurred()
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
        button.setImage(#imageLiteral(resourceName: "cart"), for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    fileprivate let textLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.adjustsFontForContentSizeCategory = true
        view.font = UIFont.preferredFont(forTextStyle: .caption2)
        view.numberOfLines = 2
        view.shadowColor = UIColor.black
        view.shadowOffset = CGSize(width: 1, height: 1)
        view.textAlignment = .center
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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

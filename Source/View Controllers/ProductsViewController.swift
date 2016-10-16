//
// ProductsViewController.swift
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
import os

/// A view controller that contains pages of products
final public class ProductsViewController: UIPageViewController {
    
    // MARK: - Initialization
    
    public init(products: [Product]) {
        self.products = products
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        dataSource = self
        delegate = self
        
        if let initialViewController = viewController(at: 0) {
            setViewControllers([initialViewController], direction: .forward, animated: false, completion: nil)
        }
        
        productDetailStackView.addArrangedSubview(nameLabel)
        productDetailStackView.addArrangedSubview(priceLabel)
        
        stackView.addArrangedSubview(productDetailStackView)
        stackView.addArrangedSubview(detailsLabel)
        stackView.addArrangedSubview(pageControl)
        stackView.addArrangedSubview(purchaseButton)
        
        view.addSubview(gradientView)
        view.addSubview(stackView)
        view.addSubview(cartView)
        
        NSLayoutConstraint.activate([
            cartView.topAnchor.constraint(equalTo: view.topAnchor, constant: cartEdge),
            cartView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 200), // initially off screen
            
            gradientView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            gradientView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            gradientView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -0),
            gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -0),
            
            pageControl.heightAnchor.constraint(equalToConstant: 10),
            
            purchaseButton.heightAnchor.constraint(equalToConstant: 50),
            
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
            ])
        
        purchaseButton.addTarget(self, action: #selector(didTapAddToCart(_:)), for: .touchUpInside)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(didPanCartView(_:)))
        cartView.addGestureRecognizer(gesture)
        
        pageControl.numberOfPages = products.count
        setup(with: products.first!)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    public override var prefersStatusBarHidden: Bool {
        let weDontWantTheUserToMissAnAmazingDealBecauseTheyRealizeTheyAreGoingToBeLateForWork = true
        
        return weDontWantTheUserToMissAnAmazingDealBecauseTheyRealizeTheyAreGoingToBeLateForWork
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: Cart.cartChanged, object: nil, queue: OperationQueue.main, using: { [weak self] (notification) in
            
            if let weakSelf = self {
                
                let pushBehavior = UIPushBehavior(items: [weakSelf.cartView], mode: UIPushBehaviorMode.instantaneous)
                pushBehavior.pushDirection = CGVector(dx: 2, dy: -4)

                pushBehavior.action = {
                    if pushBehavior.active == false {
                        weakSelf.cartView.snapFeedback()
                        weakSelf.animator.removeBehavior(pushBehavior)
                    }
                }
                weakSelf.animator.addBehavior(pushBehavior)
                
                weakSelf.cartView.total = weakSelf.priceFormatter.formattedPrice(for: weakSelf.cart.totalPrice)
            }
        })
        
        cartView.tapHandler = { [weak self] in
            guard let cart = self?.cart else {
                os_log("No cart available")
                return
            }
            
            let controller = CartViewController(cart: cart)
            let navController = UINavigationController(rootViewController: controller)
            
            self?.present(navController, animated: true, completion: nil)
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if cartSnapBehavior == nil {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
                if let weakSelf = self {
                    weakSelf.cartSnapBehavior = UISnapBehavior(item: weakSelf.cartView, snapTo: CGPoint(x: weakSelf.view.frame.size.width - weakSelf.cartEdge, y: weakSelf.cartEdge * 2))
                    weakSelf.cartSnapBehavior?.damping = 1.0
                    weakSelf.animator.addBehavior(weakSelf.cartSnapBehavior!)
                    weakSelf.cartView.snapFeedback()
                }
            }
        }
    }
    
    // MARK: - Private
    
    fileprivate lazy var animator: UIDynamicAnimator = {
        return UIDynamicAnimator(referenceView: self.view)
    }()
    
    fileprivate let cart = Cart()
    
    fileprivate let cartEdge: CGFloat = 50
    
    fileprivate var cartSnapBehavior: UISnapBehavior?
    
    /// A floating shopping cart button
    fileprivate let cartView: CartView = {
        let view = CartView(backgroundColor: Prototype.Colors.primary.withAlphaComponent(0.8), width: 60) // TODO: UIAppearance
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isAccessibilityElement = true
        view.accessibilityHint = NSLocalizedString("Shows the contents of your cart", comment: "Hint when you tap the shopping cart button")
        view.accessibilityLabel = NSLocalizedString("Your cart", comment: "Shopping cart and number of items in it") // TODO: include number of items in it
        view.total = "$0"
        
        return view
    }()
    
    /// Displays the details about the product
    fileprivate let detailsLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.preferredFont(forTextStyle: .title2)
        view.numberOfLines = 1
        view.textAlignment = .left
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    @objc fileprivate func didPanCartView(_ gesture: UIPanGestureRecognizer) {
        
        let location = gesture.location(in: view)
        
        if gesture.state == .began {
            cartView.popFeedback()
            
            if let snap = cartSnapBehavior {
                animator.removeBehavior(snap)
                cartSnapBehavior = nil
            }
        }
        
        if gesture.state == .ended || gesture.state == .cancelled {
            cartView.snapFeedback()
            
            let x = view.frame.size.width - cartEdge
            cartSnapBehavior = UISnapBehavior(item: cartView, snapTo: CGPoint(x: x, y: max(min(location.y, view.frame.size.height - 250), cartEdge)))
            self.animator.addBehavior(cartSnapBehavior!)
            
            return
        }
        
        cartView.center = location
    }
    
    @objc fileprivate func didTapAddToCart(_ sender: UIButton) {
        sender.isEnabled = false
        
        let label = UILabel(frame: stackView.convert(priceLabel.frame, to: view))
        label.text = priceLabel.text
        label.font = priceLabel.font
        label.textColor = priceLabel.textColor
        
        view.addSubview(label)
        
        let animator = UIViewPropertyAnimator(duration: 1.0, curve: .easeInOut) { [weak self] in
            label.center = self?.cartView.center ?? .zero
            label.alpha = 0.0
            label.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
        
        let product = products[pageControl.currentPage]
        animator.addCompletion { [weak self] (position) in
            self?.cart.add(product)
            label.removeFromSuperview()
        }
        
        animator.startAnimation()
        
        
        sender.isEnabled = true
    }
    
    fileprivate let gradientView: GradientView = {
        let view = GradientView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        
        view.startPoint = 0.5
        view.endPoint = 0.8
        view.from = .clear
        view.to = Prototype.Colors.secondary.withAlphaComponent(0.8)
        
        return view
    }()
    
    fileprivate func index(where videoURL: URL?) -> Int {
        return products.index(where: { (product) -> Bool in
            videoURL == product.videoURL
        }) ?? NSNotFound
    }
    
    /// Displays the name of the product
    fileprivate let nameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.preferredFont(forTextStyle: .title1)
        view.numberOfLines = 1
        view.textAlignment = .left
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    fileprivate let pageControl: UIPageControl = {
        // Overriding the standard page control that `UIPageViewController` provides because there isn't a clean way to reposition it
        let view = UIPageControl(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.currentPage = 0
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    /// Displays the price of the product
    fileprivate let priceLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.preferredFont(forTextStyle: .title1)
        view.numberOfLines = 1
        view.textAlignment = .right
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    /// Used to format the price into a string for display
    fileprivate let priceFormatter = PriceFormatter()
    
    /// Products being displayed
    fileprivate let products: [Product]
    
    /// Stack view used for product details
    let productDetailStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 15
        
        return stackView
    }()
    
    /// Button that adds the product to the cart
    fileprivate let purchaseButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = Prototype.Colors.primary.withAlphaComponent(0.8) // TODO: UIAppearance
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Add to cart", comment: "Prompt to add to cart"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.accessibilityHint = NSLocalizedString("Adds product to your cart", comment: "Hint when you tap the purchase button")
        return button
    }()
    
    fileprivate func setup(with product: Product) {
        nameLabel.text = product.name
        detailsLabel.text = product.details
        priceLabel.text = priceFormatter.formattedPrice(for: product.price)
        
        let index = self.index(where: product.videoURL)
        pageControl.currentPage = index
    }
    
    fileprivate var viewsAreVisible: Bool = false {
        didSet {
            let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn) { [weak self] in
                guard let weakSelf = self else {
                    return
                }
                
                weakSelf.nameLabel.alpha = weakSelf.viewsAreVisible ? 1.0 : 0.0
                weakSelf.detailsLabel.alpha = weakSelf.viewsAreVisible ? 1.0 : 0.0
                weakSelf.priceLabel.alpha = weakSelf.viewsAreVisible ? 1.0 : 0.0
            }
            animator.startAnimation()
        }
    }
    
    /// Stack view that contains the views
    fileprivate let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        
        return stackView
    }()
    
    fileprivate func viewController(at index: Int) -> UIViewController? {
        if index < 0 || index >= products.count {
            return nil
        }
        
        let product = products[index]
        let controller = VideoViewController(url: product.videoURL)
        return controller
    }
}

extension ProductsViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let videoViewController = viewController as? VideoViewController else {
            return nil
        }
        
        let current = index(where: videoViewController.url)
        let controller = self.viewController(at: current + 1)
        
        return controller
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let videoViewController = viewController as? VideoViewController else {
            return nil
        }
        
        let current = index(where: videoViewController.url)
        let controller = self.viewController(at: current - 1)
        
        return controller
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        viewsAreVisible = false
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let controller = pageViewController.viewControllers?.first as? VideoViewController else {
            return
        }
        
        let index = self.index(where: controller.url)
        let product = products[index]
        setup(with: product)
        viewsAreVisible = true
    }
}

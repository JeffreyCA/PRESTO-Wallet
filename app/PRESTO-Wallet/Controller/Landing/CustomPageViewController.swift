//
//  UIPageViewController.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2017-12-17.
//  Copyright © 2017 JeffreyCA. All rights reserved.
//

import UIKit

protocol CustomPageViewDelegate {
    func pageSwitched(customPageViewController: CustomPageViewController)
}

protocol CustomPageViewNavigation {
    func goToNextPage(animated: Bool)
    func goToPreviousPage(animated: Bool)
    func isAtBeginning() -> Bool?
    func isAtEnd() -> Bool?
}

class CustomPageViewController: UIPageViewController {
    var parentDelegate: CustomPageViewDelegate?
    
    internal lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "landing"),
            self.getViewController(withIdentifier: "test")
        ]
    }()
    
    private func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        self.dataSource = self
        self.delegate   = self
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func setGradientBackground() {
        // TOP: #7cba0e
        let topColor = UIColor(red: 0.49, green: 0.73, blue: 0.05, alpha: 1.0)
        // BOTTOM: #2a5e13
        let bottomColor = UIColor(red: 0.27, green: 0.49, blue: 0.07, alpha: 1.0)
        
        let gradientColor: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0/1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColor
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var pageControl : UIPageControl
        var scrollView : UIScrollView
        
        for subView in view.subviews {
            if subView is UIPageControl {
                pageControl = subView as! UIPageControl
                
                pageControl.pageIndicatorTintColor = UIColor.gray
                pageControl.currentPageIndicatorTintColor = UIColor.white
                pageControl.numberOfPages = 2
                pageControl.center = self.view.center
                pageControl.isUserInteractionEnabled = false
                pageControl.layer.position.y = self.view.frame.height - 100;
                
                self.view.addSubview(pageControl)
                self.view.bringSubview(toFront: pageControl)
            }
            
            if subView is UIScrollView {
                scrollView = subView as! UIScrollView
                // Set scrollable region to entire screen
                scrollView.frame = self.view.bounds
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        parentDelegate?.pageSwitched(customPageViewController: self)
    }
}

extension CustomPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // Disable wrapped scrolling
        if let viewControllerIndex = pages.index(of: viewController) {
            let previousIndex = viewControllerIndex - 1
            
            if previousIndex >= 0 {
                return pages[previousIndex]
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // Disable wrapped scrolling
        if let viewControllerIndex = pages.index(of: viewController) {
            let nextIndex = viewControllerIndex + 1
            
            if nextIndex < pages.count {
                return pages[nextIndex]
            }
        }
        
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let identifier = viewControllers?.first {
            if let index = pages.index(of: identifier) {
                return index
            }
        }
        return 0
    }
}

extension CustomPageViewController: UIPageViewControllerDelegate {
}

extension CustomPageViewController: CustomPageViewNavigation {
    func goToNextPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else {
            return
        }
        
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else {
            return
        }
        
        setViewControllers([nextViewController], direction: .forward, animated: animated, completion: nil)
    }
    
    func goToPreviousPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else {
            return
        }
        
        guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else {
            return
        }
        
        setViewControllers([previousViewController], direction: .reverse, animated: animated, completion: nil)
    }
    
    func isAtBeginning() -> Bool? {
        if let currentViewController = self.viewControllers?.first {
            return currentViewController == pages.first
        }
        
        return nil
    }
    
    func isAtEnd() -> Bool? {
        if let currentViewController = self.viewControllers?.first {
            return currentViewController == pages.last
        }
        
        return nil
    }
}


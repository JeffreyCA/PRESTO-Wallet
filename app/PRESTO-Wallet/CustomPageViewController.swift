//
//  UIPageViewController.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2017-12-17.
//  Copyright © 2017 JeffreyCA. All rights reserved.
//

import UIKit

class CustomPageViewController: UIPageViewController {
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "landing"),
            self.getViewController(withIdentifier: "test")
        ]
    }()
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        self.dataSource = self
        self.delegate   = self
        
        if let firstVC = pages.first
        {
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
                scrollView.frame = self.view.bounds
                
            }
        }
    }
}

extension CustomPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return pages.last
        }
        
        guard pages.count > previousIndex else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return pages.first
        }
        
        guard pages.count > nextIndex else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let identifier = viewControllers?.first {
            if let index = pages.index(of: identifier) {
                print("found")
                return index
            }
        }
        return 0
    }
}


extension CustomPageViewController: UIPageViewControllerDelegate { }

extension CustomPageViewController {
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
}

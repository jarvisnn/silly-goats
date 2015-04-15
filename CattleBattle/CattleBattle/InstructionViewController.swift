//
//  InstructionViewController.swift
//  CattleBattle
//
//  Created by kunn on 4/12/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController,UIPageViewControllerDataSource {
        
        // MARK: - Variables
        private var pageViewController: UIPageViewController?
    
        // MARK: - View Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            self.populateControllersLis()
            self.createPageViewController()
            self.setupPageControl()
        }
    
        var controllersList = [PageItemController]()
    
        private func populateControllersLis() {
        for i in 0...2 {
            let controller = storyboard!.instantiateViewControllerWithIdentifier("Instruction\(i+1)") as! PageItemController
            controller.itemIndex = i
            controllersList.append(controller)
            }
        }
    
        private func createPageViewController() {
            
            let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
            pageController.dataSource = self
            
            if !controllersList.isEmpty {
                pageController.setViewControllers([controllersList[0]], direction: .Forward, animated: false, completion: nil)
            }
            
            pageViewController = pageController
            pageViewController!.view.backgroundColor =  UIColor.darkGrayColor()
            self.addChildViewController(pageViewController!)
            self.view.addSubview(pageViewController!.view)
            pageViewController!.didMoveToParentViewController(self)
        }
        
        private func setupPageControl() {
            let appearance = UIPageControl.appearance()
            appearance.pageIndicatorTintColor = UIColor.whiteColor()
            appearance.currentPageIndicatorTintColor = UIColor.darkGrayColor()
            appearance.backgroundColor = UIColor.lightGrayColor()
        }
        
        // MARK: - UIPageViewControllerDataSource
        func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            
            if let itemController = viewController as? PageItemController {
            
                if itemController.itemIndex > 0 {
                    return controllersList[itemController.itemIndex - 1]
                }
            }
            
            return nil
        }
        
        func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            
            if let itemController = viewController as? PageItemController {
                
                if itemController.itemIndex < controllersList.count - 1 {
                    return controllersList[itemController.itemIndex + 1]
                }
            }
            
            return nil
        }
    
        
        // MARK: - Page Indicator
        func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
            return controllersList.count
        }
        
        func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
            return 0
        }
        
}


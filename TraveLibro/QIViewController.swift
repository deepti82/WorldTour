//
//  QIViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 05/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QIViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    let variousViews = ["One", "Two", "Three", "Four", "Five"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDarkBackGround(self)
        
        let myVC = viewControllerAtIndex(0) as! QuickItinerariesViewController
        let viewControllers = [myVC]
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
//        rightButton.addTarget(self, action: #selector(), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRectMake(0, 8, 30, 30)
        
        self.customNavigationBar(leftButton, right: rightButton)
        
        dataSource = self
        
        setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! QuickItinerariesViewController
        var index = vc.pageIndex  as Int
        if((index == 0) || (index == NSNotFound)) {
            
            return nil
        }
        
        index = index - 1
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! QuickItinerariesViewController
        var index = vc.pageIndex  as Int
        if(index == NSNotFound) {
            
            return nil
        }
        
        index = index + 1
        
        if(index == variousViews.count) {
            
            return nil
        }
        
        return viewControllerAtIndex(index)
        
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController {
        
        print("index: \(index)")
        
        if((variousViews.count == 0) || (index >= variousViews.count)) {
            
            return QuickItinerariesViewController()
        }
        
        let myVC = storyboard?.instantiateViewControllerWithIdentifier("quickItinerary") as! QuickItinerariesViewController
        myVC.whichView = variousViews[index]
        myVC.pageIndex = index
        return myVC
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return variousViews.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return 0
    }

}

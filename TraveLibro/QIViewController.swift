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
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
//        rightButton.addTarget(self, action: #selector(), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        dataSource = self
        
        setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! QuickItinerariesViewController
        var index = vc.pageIndex  as Int
        if((index == 0) || (index == NSNotFound)) {
            
            return nil
        }
        
        index = index - 1
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
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
    
    func viewControllerAtIndex(_ index: Int) -> UIViewController {
        
        print("index: \(index)")
        
        if((variousViews.count == 0) || (index >= variousViews.count)) {
            
            return QuickItinerariesViewController()
        }
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "quickItinerary") as! QuickItinerariesViewController
        myVC.whichView = variousViews[index]
        myVC.pageIndex = index
        return myVC
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return variousViews.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return 0
    }

}

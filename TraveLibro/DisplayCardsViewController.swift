//
//  DisplayCardsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 20/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class DisplayCardsViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    let titles = ["Your kind of a holiday", "You travel", "You usually go", "Prefer to travel", "Your ideal holiday type"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDarkBackGround(self)
        
        let myVC = viewControllerAtIndex(0) as! SignupCardsViewController
        let viewControllers = [myVC]
        
        
        dataSource = self
        
        setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! SignupCardsViewController
        var index = vc.pageIndex  as Int
        if((index == 0) || (index == NSNotFound)) {
            
            return nil
        }
        
        index = index - 1
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! SignupCardsViewController
        var index = vc.pageIndex  as Int
        if(index == NSNotFound) {
            
            return nil
        }
        
        index = index + 1
        
        if(index == titles.count) {
            
            return nil
        }
        
        return viewControllerAtIndex(index)
        
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController {
        
        if((self.titles.count == 0) || (index >= self.titles.count)) {
            
                return SignupCardsViewController()
        }
        
        let myVC = storyboard?.instantiateViewControllerWithIdentifier("SignupCardsViewController") as! SignupCardsViewController
        myVC.cardText = titles[index]
        myVC.pageIndex = index
        return myVC
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return titles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
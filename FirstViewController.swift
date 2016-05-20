//
//  FirstViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 20/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIPageViewControllerDataSource {

    var pageIndex: Int
    var pageImages: String
    var viewController = TrialViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! FirstViewController
        var index = vc.pageIndex as Int
        
        if ((index == 0) || (index == NSNotFound)) {
            
            return nil
            
        }
        index -= 1
        let value =  self.viewControllerAtIndex(index)
        return value
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        return nil
        
    }
    
    func viewControllerAtIndex(index: Int) -> TrialViewController {
        
        if((self.pageImages.count == 0) || (index >= self.pageImages.count)) {
            
            return viewController
            
        }
        
        let vc: TrialViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TrialViewController") as! TrialViewController
        vc.imageFile = self.pageImages[index] as! String
        
        return vc
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

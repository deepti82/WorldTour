//
//  NavigationStyle.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 20/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

var checkInMainVC: UIViewController!


extension UIViewController {
    
    func setNavigationBarItem() {
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor(red: 1, green: 1, blue: 1, alpha: 0) ]
        
//        self.navigationController?.navigationBar.translucent = false
        self.addLeftBarButtonWithImage(UIImage(named: "menu_left_icon")!)
        self.navigationController?.toolbar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barStyle = .Black
        
        //self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
        
        
//        let logo = UIImage(named: "ic_action_panther.png")
//        let imageView = UIImageView(image:logo)
        
//        let screenSize: CGRect = UIScreen.mainScreen().bounds
//        imageView.frame = CGRectMake(0,14,50,50);
//        
//        imageView.contentMode = UIViewContentMode.ScaleAspectFit;
//        imageView.center.x  = screenSize.width/2
//        self.navigationController?.view.addSubview(imageView)
    }
    
    func setNavigationBarItemText(text:String) {
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let font = avenirFont
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName : font!]
//        self.navigationController?.navigationBar.translucent = false
        self.addLeftBarButtonWithImage(UIImage(named: "menu_left_icon")!)
        self.navigationController?.toolbar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barTintColor = mainBlueColor
        
        
        //self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
        
        self.navigationController?.navigationBar.topItem!.title = text;
        
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    func setCheckInNavigationBarItem (viewController: UIViewController) {
        
        removeNavigationBarItem()
        
//        let font = UIFont(name: "Font-Awesome", size: 14)
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName : font!]
        
//        let close = String(format: "%C", faicon["close"]!)
//        let next = String(format: "%C", faicon["next"]!)
        
        checkInMainVC = viewController
        
        print("storyboard: \(self.navigationController)")
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.toolbar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barStyle = .Black
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "close_fa"), style: .Plain, target: self, action: #selector(UIViewController.closeController(_:)))
        let rightButton = UIBarButtonItem(image: UIImage(named: "arrow_next_fa"), style: .Plain, target: self, action: #selector(UIViewController.nextController(_:)))
        
        self.navigationItem.setLeftBarButtonItem(leftButton, animated: true)
        self.navigationItem.setRightBarButtonItem(rightButton, animated: true)
        
    }
    
    func setCheckInMainNavigationBarItem (viewController: UIViewController) {
        
        removeNavigationBarItem()
        
        //        let font = UIFont(name: "Font-Awesome", size: 14)
        //        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName : font!]
        
        //        let close = String(format: "%C", faicon["close"]!)
        //        let next = String(format: "%C", faicon["next"]!)
        
        checkInMainVC = viewController
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.toolbar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barStyle = .Black
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "arrow_next_fa"), style: .Plain, target: self, action: #selector(UIViewController.nextController(_:)))
        
        self.navigationItem.setRightBarButtonItem(rightButton, animated: true)
        
    }
    
    func closeController(sender: UIBarButtonItem) -> () {
        
        print("close controller called")
        
        let allVCs = self.navigationController?.viewControllers
        print("all VCS: \(allVCs)")
        let checkInVC = allVCs![(allVCs?.count)! - 2]
        print("checkin vc: \(checkInVC)")
        
        self.navigationController?.popToViewController(checkInVC, animated: true)
        
    }
    
    func nextController(sender: UIBarButtonItem) -> () {
        
        print("next view controller called")
        
        self.navigationController?.pushViewController(checkInMainVC, animated: true)
        
    }
    
    
    func setFooterTabBar(vc: UIViewController) {
        
        let footer = getFooter(frame: CGRect(x: 0, y: vc.view.frame.height - 45, width: vc.view.frame.width, height: 45))
        vc.view.addSubview(footer)
        footer.layer.zPosition = 100
        
        self.tabBarItem.title = "Feed"
        
    }
}

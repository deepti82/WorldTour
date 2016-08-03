//
//  NavigationStyle.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 20/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

var checkInMainVC: UIViewController!
var previousVC: UIViewController!
var nextVC: UIViewController!

extension UIViewController {
    
    func setNavigationBarItem() {
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName : avenirFont!]
        
//        self.navigationController?.navigationBar.translucent = false
        self.addLeftBarButtonWithImage(UIImage(named: "menu_left_icon")!)
        self.navigationController?.toolbar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barStyle = .Black
//        self.navigationController?.navigationBar.translucent = false
        
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
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName : avenirFont!]
//        self.navigationController?.navigationBar.translucent = false
        self.addLeftBarButtonWithImage(UIImage(named: "menu_left_icon")!)
        self.navigationController?.toolbar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barStyle = .Black
//        self.navigationController?.navigationBar.translucent = false
        
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
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName : avenirFont!]
        
        checkInMainVC = viewController
        
        print("storyboard: \(self.navigationController)")
        
        let closeImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        closeImage.image = UIImage(named: "close_fa")
        
        let nextImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        nextImage.image = UIImage(named: "arrow_next_fa")
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.toolbar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barStyle = .Black
        
        let leftButton = UIBarButtonItem(image: closeImage.image, style: .Plain, target: self, action: #selector(UIViewController.closeController(_:)))
        leftButton.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let rightButton = UIBarButtonItem(image: nextImage.image, style: .Plain, target: self, action: #selector(UIViewController.nextController(_:)))
        rightButton.imageInsets = UIEdgeInsets(top: 15, left: 10, bottom: 5, right: 10)
        
        self.navigationItem.setLeftBarButtonItem(leftButton, animated: true)
        self.navigationItem.setRightBarButtonItem(rightButton, animated: true)
        
    }
    
    func setCheckInMainNavigationBarItem (viewController: UIViewController) {
        
        removeNavigationBarItem()
        
        let nextImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        nextImage.image = UIImage(named: "arrow_next_fa")
        
        checkInMainVC = viewController
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.toolbar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barStyle = .Black
//        self.navigationController?.navigationBar.translucent = false
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "arrow_next_fa"), style: .Plain, target: self, action: #selector(UIViewController.nextController(_:)))
        rightButton.imageInsets = UIEdgeInsets(top: 15, left: 10, bottom: 5, right: 10)
        self.navigationItem.setRightBarButtonItem(rightButton, animated: true)
        
    }
    
    func customNavigationBar(left: UIButton?, right: UIButton?) {
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.toolbar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barStyle = .Black
//        self.navigationController?.navigationBar.translucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName : avenirFont!]
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = left
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = right
        
//        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(image: UIImage(named: "add_fa_icon"), style: .Plain, target: self, action: #selector(UIViewController.setForwardController(_:))), animated: true)
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        
//        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(image: UIImage(named: "arrow_next_fa"), style: .Plain, target: self, action: #selector(UIViewController.setBackwardController(_:))), animated: true)
//        self.navigationController?.toolbar.barTintColor = mainBlueColor
//        self.navigationController?.navigationBar.barTintColor = mainBlueColor
//        self.navigationController?.navigationBar.barStyle = .Black
//        
//        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(image: UIImage(named: "arrow_next_fa"), style: .Plain, target: self, action: #selector(UIViewController.setBackwardController(_:))), animated: true)
//        self.navigationController?.toolbar.barTintColor = mainBlueColor
//        self.navigationController?.navigationBar.barTintColor = mainBlueColor
//        self.navigationController?.navigationBar.barStyle = .Black
        
        //self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        
    }
    
    func setOnlyRightNavigationButton(button: UIButton) {
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName : avenirFont!]
        
        self.addLeftBarButtonWithImage(UIImage(named: "menu_left_icon")!)
        self.navigationController?.toolbar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barStyle = .Black
//        self.navigationController?.navigationBar.translucent = false
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = button
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        //self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
//        self.slideMenuController()?.addRightGestures()
        
    }
    
    func setOnlyLeftNavigationButton(button: UIButton) {
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName : avenirFont!]
        
//        self.addLeftBarButtonWithImage(UIImage(named: "menu_left_icon")!)
        self.navigationController?.toolbar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barTintColor = mainBlueColor
        self.navigationController?.navigationBar.barStyle = .Black
//        self.navigationController?.navigationBar.translucent = false
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = button
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        //self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
//        self.slideMenuController()?.addLeftGestures()
        //        self.slideMenuController()?.addRightGestures()
        
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
    
    func setForwardController(sender: AnyObject?) {
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    func setBackwardController(sender: AnyObject?) {
        
        self.navigationController?.pushViewController(previousVC, animated: true)
        
    }
    
    func popVC(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func setFooterTabBar(vc: UIViewController) {
        
        let footer = getFooter(frame: CGRect(x: 0, y: vc.view.frame.height - 45, width: vc.view.frame.width, height: 45))
        vc.view.addSubview(footer)
        footer.layer.zPosition = 100
        
        self.tabBarItem.title = "Feed"
        
    }
}

//
//  NavigationStyle.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 20/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

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
}

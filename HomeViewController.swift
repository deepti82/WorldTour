//
//  HomeViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 15/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

var GlobalHomeController: HomeViewController!

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var activityController: UIViewController!
    
//    func homeTap (sender: UITapGestureRecognizer? = nil) {
//        
//        let myProfileController = storyboard!.instantiateViewControllerWithIdentifier("ProfileVC") as! ProfileViewController
//        self.activityController = UINavigationController(rootViewController: myProfileController)
//        self.slideMenuController()?.changeMainViewController(self.activityController, close: true)
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGround(self)
        
        hasLoggedInOnce = true
//        let footer = getFooter(frame: CGRect(x: 0, y: self.view.frame.height - 45, width: self.view.frame.width, height: 45))
//        footer.layer.zPosition = 100
//        self.view.addSubview(footer)
        
        self.setNavigationBarItem()
        
        let footer = FooterViewNew(frame: CGRect(x: 0, y: self.view.frame.height - 55, width: self.view.frame.width, height: 55))
        footer.layer.zPosition = 1000
        footer.feedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIViewController.goToFeed(_:))))
        footer.notifyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIViewController.gotoNotifications(_:))))
        footer.LLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIViewController.gotoLocalLife(_:))))
        footer.TLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIViewController.gotoTravelLife(_:))))
        self.view.addSubview(footer)
        
//        let signUpOne = storyboard?.instantiateViewControllerWithIdentifier("SignUpOne") as! SignInViewController
//        self.addChildViewController(signUpOne)
        
//        let myTouch = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.homeTap(_:)))
//        myTouch.delegate = self
//        self.view.addGestureRecognizer(myTouch)
        
//        self.resizeView(8);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func resizeView(offset:CGFloat)
//    {
//        self.verticalLayout.layoutSubviews()
//        
//    }

}

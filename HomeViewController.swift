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
    
    override func viewWillAppear(animated: Bool) {
        
//        if doRemove {
//            
//            let profileVC = storyboard?.instantiateViewControllerWithIdentifier("ProfileVC") as! ProfileViewController
//            self.navigationController?.showViewController(profileVC, sender: nil)
//            
//        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        
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
        
        let sideMenu = storyboard!.instantiateViewControllerWithIdentifier("sideMenu") as! SideNavigationMenuViewController
        sideMenu.view.setNeedsDisplay()
        
//        var imageName = ""
//        
//        if currentUser != nil {
//            
//            
//            print("inside if statement \(sideMenu.profilePicture)")
//            imageName = currentUser["profilePicture"].string!
//            print("image: \(imageName)")
//            
//            let isUrl = verifyUrl(imageName)
//            print("isUrl: \(isUrl)")
//            
//            if isUrl {
//                
//                print("inside if statement")
//                let data = NSData(contentsOfURL: NSURL(string: imageName)!)
//                
//                if data != nil {
//                    
//                    print("some problem in data \(data)")
//                    //                uploadView.addButton.setImage(, forState: .Normal)
//                    sideMenu.profilePicture.image = UIImage(data: data!)
//                    makeTLProfilePicture(sideMenu.profilePicture)
//                }
//            }
//                
//            else {
//                
//                let getImageUrl = adminUrl + "upload/readFile?file=" + imageName + "&width=100"
//                
//                print("getImageUrl: \(getImageUrl)")
//                
//                let data = NSData(contentsOfURL: NSURL(string: getImageUrl)!)
//                print("data: \(data)")
//                
//                if data != nil {
//                    
//                    //                uploadView.addButton.setImage(UIImage(data:data!), forState: .Normal)
//                    print("inside if statement \(sideMenu.profilePicture.image)")
//                    sideMenu.profilePicture.image = UIImage(data: data!)
//                    print("sideMenu.profilePicture.image: \(sideMenu.profilePicture.image)")
//                    makeTLProfilePicture(sideMenu.profilePicture)
//                }
//                
//            }
//            
//        }
//
//        
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

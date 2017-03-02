//
//  LogInViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var videoScrollView: UIScrollView!
    var layout:HorizontalLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in loaded")
        
        layout = HorizontalLayout(height: videoScrollView.frame.height)
        
        videoScrollView.addSubview(layout)
        
        getDarkBackGroundBlur(self)
        self.navigationController?.isNavigationBarHidden = false
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
//        let rightButton = UIButton()
//        rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
//        rightButton.addTarget(self, action: #selector(VerifyEmailViewController.selectNationality(_:)), forControlEvents: .TouchUpInside)
//        rightButton.frame = CGRectMake(0, 8, 30, 30)
        
        self.customNavigationBar(left: leftButton, right: nil)
    
        
        let logIn = LogInView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 400))
        logIn.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        self.view.addSubview(logIn)
        
        logIn.fbButton.addTarget(self, action: #selector(SignInPageViewController.facebookSignUp(_:)), for: .touchUpInside)
        logIn.googleButton.addTarget(self, action: #selector(SignInPageViewController.googleSignUp(_:)), for: .touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("in appear")
    }
    
    func facebookSignUp(_ sender: AnyObject) {
        
        social.facebookLogin()
        
    }
    
    func googleSignUp(_ sender: AnyObject) {
        
        social.googleLogin()
        
    }
    
    func twitterSignUp(_ sender: AnyObject) {
        
        social.twitterLogin()
        
    }
    
    func igSignUp(_ sender: AnyObject) {
        
        //        social.googleLogin()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

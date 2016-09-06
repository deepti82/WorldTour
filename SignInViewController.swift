//
//  SignInViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON
import TwitterKit

var currentUser: JSON!
let social = SocialLoginClass()
var profileVC: ProfileViewController!
var nationalityPage: AddNationalityNewViewController!
var navigation: UINavigationController!


class SignInViewController: UIViewController {
    
//    var request = HTTPTask()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)
        
        self.navigationController?.navigationBarHidden = true
        
        let signInFooter = SignInToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height - 140, width: self.view.frame.size.width, height: 140))
        self.view.addSubview(signInFooter)
        
//        if (FBSDKAccessToken.currentAccessToken() != nil)
//        {
//            // User is already logged in, do work such as go to next view controller.
//        }
//        else
//        {
////            let loginView : FBSDKLoginButton = FBSDKLoginButton()
////            self.view.addSubview(loginView)
////            loginView.center = self.view.center
//            signInFooter.fbButton.readPermissions = ["public_profile", "email", "user_friends"]
//            signInFooter.fbButton.delegate = self
//        }
//        
        signInFooter.signUp.addTarget(self, action: #selector(SignInViewController.goToSignUp(_:)), forControlEvents: .TouchUpInside)
        signInFooter.signInButton.addTarget(self, action: #selector(SignInViewController.loginButtonTapped(_:)), forControlEvents: .TouchUpInside)
        signInFooter.googleButton.addTarget(self, action: #selector(SignInViewController.googleSignIn(_:)), forControlEvents: .TouchUpInside)
        signInFooter.fbButton.addTarget(self, action: #selector(SignInViewController.facebookSignIn(_:)), forControlEvents: .TouchUpInside)
        signInFooter.twitterButton.addTarget(self, action: #selector(SignInViewController.twitterSignIn(_:)), forControlEvents: .TouchUpInside)
        
        profileVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileVC") as! ProfileViewController
        
        nationalityPage = self.storyboard?.instantiateViewControllerWithIdentifier("nationalityNew") as! AddNationalityNewViewController
        
        navigation = self.navigationController
        
    }
    
//    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
//        print("User Logged In")
//        
//        if ((error) != nil)
//        {
//            // Process error
//        }
//        else if result.isCancelled {
//            // Handle cancellations
//        }
//        else {
//            // If you ask for multiple permissions at once, you
//            // should check if specific permissions missing
//            if result.grantedPermissions.contains("email")
//            {
//                // Do work
//            }
//        }
//    }
//    
//    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
//        print("User Logged Out")
//    }
    
//    func returnUserData()
//    {
//        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
//        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
//            
//            if ((error) != nil)
//            {
//                // Process error
//                print("Error: \(error)")
//            }
//            else
//            {
//                print("fetched user: \(result)")
//                let userName : NSString = result.valueForKey("name") as! NSString
//                print("User Name is: \(userName)")
//                let userEmail : NSString = result.valueForKey("email") as! NSString
//                print("User Email is: \(userEmail)")
//            }
//        })
//    }
    
    func googleSignIn(sender: UIButton) {
        
        print("google sign in")
//        navigation.signUpSocial("google", completion: {(json:JSON) -> () in
//        })
//        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.google.com")!)
        
        social.googleLogin()
        
    }
    
    func facebookSignIn(sender: UIButton) {
        
        print("facebook sign in")
        
//        Facebook.init()
        print("storyboard: \(self.storyboard)")
        social.facebookLogin()
    }
    
    func twitterSignIn(sender: UIButton) {
        
        print("storyboard: \(self.storyboard)")
        social.twitterLogin()
        
    }
    
    func goToSignUp(sender: AnyObject) {
        
//        print("inside function!")
        print("storyboard: \(self.navigationController)")
        let signUpFullVC = storyboard?.instantiateViewControllerWithIdentifier("signUpTwo") as! SignInPageViewController
        self.navigationController?.pushViewController(signUpFullVC, animated: true)
        
    }
    
    func loginButtonTapped(sender: AnyObject) {
        
        let logInVC = storyboard?.instantiateViewControllerWithIdentifier("logIn") as! LogInViewController
        self.navigationController?.pushViewController(logInVC, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

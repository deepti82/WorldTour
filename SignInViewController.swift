//
//  SignInViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)
        
        let signInFooter = SignInToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height - 120, width: self.view.frame.size.width, height: 150))
        self.view.addSubview(signInFooter)
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
//            let loginView : FBSDKLoginButton = FBSDKLoginButton()
//            self.view.addSubview(loginView)
//            loginView.center = self.view.center
            signInFooter.fbButton.readPermissions = ["public_profile", "email", "user_friends"]
            signInFooter.fbButton.delegate = self
        }
        
        signInFooter.tnc.addTarget(self, action: #selector(SignInViewController.TNCPage(_:)), forControlEvents: .TouchUpInside)
        signInFooter.signInButton.addTarget(self, action: #selector(SignInViewController.loginButtonTapped(_:)), forControlEvents: .TouchUpInside)
        signInFooter.googleButton.addTarget(self, action: #selector(SignInViewController.googleSignIn(_:)), forControlEvents: .TouchUpInside)
//        signInFooter.fbButton.addTarget(self, action: #selector(SignInViewController.facebookSignIn(_:)), forControlEvents: .TouchUpInside)
        signInFooter.twitterButton.addTarget(self, action: #selector(SignInViewController.twitterSignIn(_:)), forControlEvents: .TouchUpInside)
        
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
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
//            
//            
//            
//        })
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.google.com")!)
        
    }
    
    func facebookSignIn(sender: UIButton) {
        
//        print("facebook sign in")
//        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.facebook.com")!)
    }
    
    func twitterSignIn(sender: UIButton) {
        
        print("twitter sign in")
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.twitter.com")!)
        
    }
    
    func TNCPage(sender: AnyObject) {
        
        print("inside function!")
        print("storyboard: \(self.navigationController)")
        
    }
    
    func loginButtonTapped(sender: AnyObject) {
        
        let signUpFullVC = storyboard?.instantiateViewControllerWithIdentifier("signUpTwo") as! SignInPageViewController
        self.navigationController?.pushViewController(signUpFullVC, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

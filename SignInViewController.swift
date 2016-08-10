//
//  SignInViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Simplicity
import SwiftHTTP
import SwiftyJSON

class SignInViewController: UIViewController {
    
//    var request = HTTPTask()
    var facebook = Facebook()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)
        
        facebook.scopes = ["email", "user_birthday", "user_location"]
        
        let signInFooter = SignInToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height - 120, width: self.view.frame.size.width, height: 150))
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
        signInFooter.tnc.addTarget(self, action: #selector(SignInViewController.TNCPage(_:)), forControlEvents: .TouchUpInside)
        signInFooter.signInButton.addTarget(self, action: #selector(SignInViewController.loginButtonTapped(_:)), forControlEvents: .TouchUpInside)
        signInFooter.googleButton.addTarget(self, action: #selector(SignInViewController.googleSignIn(_:)), forControlEvents: .TouchUpInside)
        signInFooter.fbButton.addTarget(self, action: #selector(SignInViewController.facebookSignIn(_:)), forControlEvents: .TouchUpInside)
        signInFooter.twitterButton.addTarget(self, action: #selector(SignInViewController.twitterSignIn(_:)), forControlEvents: .TouchUpInside)
        
        
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
//            
//            
//            
//        })
//        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.google.com")!)
        let googlePermissions = Google()
        googlePermissions.scopes = []
        
        Simplicity.login(Google()) { (accessToken, error) in
            
            print("access token \(accessToken!)")
            if accessToken != nil {
                
                do {
                    let gURL = "https://www.googleapis.com/plus/v1/people/me&access_token=\(accessToken!)"
                    let opt = try HTTP.GET(gURL)
                    print("fbURL: \(gURL)")
                    opt.start { response in
                        if let err = response.error {
                            print("error: \(err.localizedDescription)")
                            return //also notify app of failure as needed
                        }
                        
                        print("opt finished: \(response.description)")
                        let json = JSON(data: response.data)
//                        print("name: \(json["name"].string!)")
//                        print("email: \(json["email"].string!)")
//                        print("id: \(json["id"].string!)")
//                        print("pic url: \(json["picture"]["data"]["url"].string!)")
                    }
                } catch let error {
                    print("got an error creating the request: \(error)")
                }
                
            }
            else
            {
                print(error!.localizedDescription)
            }
        }
        
    }
    
    func facebookSignIn(sender: UIButton) {
        
        print("facebook sign in")
        
        Simplicity.login(facebook) {(accessToken, error) in
            
            print("access token \(accessToken)")
//            print("email \(self.facebook.scopes)")
            if accessToken != nil {
                
                do {
                    let fbURL = "https://graph.facebook.com/v2.7/me?fields=id,name,email,location,gender,first_name,middle_name,last_name,birthday,picture&access_token=\(accessToken!)"
                    let opt = try HTTP.GET(fbURL)
                    print("fbURL: \(fbURL)")
                    opt.start { response in
                        if let err = response.error {
                            print("error: \(err.localizedDescription)")
                            return //also notify app of failure as needed
                        }
                        
                        print("opt finished: \(response.description)")
                        let json = JSON(data: response.data)
                        print("name: \(json["name"].string!)")
                        print("email: \(json["email"].string!)")
                        print("id: \(json["id"].string!)")
                        print("pic url: \(json["picture"]["data"]["url"].string!)")
                    }
                } catch let error {
                    print("got an error creating the request: \(error)")
                }
                
//                do {
//                    let opt = try HTTP.GET("https://graph.facebook.com/v2.5/me/picture?redirect=0&me/picture?redirect=0&height=1000&width=1000&access_token=\(accessToken)")
//                    opt.start { response in
//                        if let err = response.error {
//                            print("error: \(err.localizedDescription)")
//                            return //also notify app of failure as needed
//                        }
//                        
//                        print("opt finished: \(response.description)")
//                        let json = JSON(data: response.data)
//                        print("picture url: \(json["data"]["url"].string!)")
//                        
//                    }
//                } catch let error {
//                    print("got an error creating the request: \(error)")
//                }
                
            }
            else
            {
                print(error!.localizedDescription)
            }
            
        }
        
        
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

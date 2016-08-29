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
import TwitterKit

var currentUser: JSON!

class SignInViewController: UIViewController {
    
//    var request = HTTPTask()
    var facebook = Facebook()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)
        
        self.navigationController?.navigationBarHidden = true
        
        facebook.scopes = ["email", "user_birthday", "user_location"]
        
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
        let googlePermissions = Google()
        googlePermissions.scopes = ["https://www.googleapis.com/auth/user.birthday.read", "https://www.googleapis.com/auth/userinfo.email", "https://www.googleapis.com/auth/userinfo.profile", "https://www.googleapis.com/auth/plus.login"]
        
        Simplicity.login(googlePermissions) { (accessToken, error) in
            
            print("access token \(accessToken!)")
            if accessToken != nil {
                
                do {
                    let gURL = "https://www.googleapis.com/plus/v1/people/me"
                    let opt = try HTTP.GET(gURL, parameters: nil, headers: ["Content-Type": "application/json", "Authorization": "Bearer \(accessToken!)"])
                    print("google URL: \(gURL)")
                    opt.start { response in
                        print("opt: \(response)")
                        if let err = response.error {
                            print("error: \(err.localizedDescription)")
                            return //also notify app of failure as needed
                        }
                        
                        print("opt finished: \(response.description)")
                        let json = JSON(data: response.data)
                        print(json)
                        
                        request.saveUser(json["name"]["givenName"].string!, lastName: json["name"]["familyName"].string!, email: json["emails"][0]["value"].string!, mobile: "", fbId: "", googleId: json["id"].string!, twitterId: "", instaId: "", nationality: "", profilePicture: json["image"]["url"].string!+"?sz=500", gender: "", dob: "", completion: {(response) in
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                if (response.error != nil) {
                                    
                                    print("error: \(response.error!.localizedDescription)")
                                }
                                    
                                else {
                                    
//                                print("response: \(response.description)")
                                    currentUser = response["data"]
                                    self.gotoNationalityPage()
                                    
                                }
                            })
                        })
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
        
//        Facebook.init()
        
        Simplicity.login(facebook) {(accessToken, error) in
            
//            print("access token \(accessToken)")
//            print("email \(self.facebook.scopes)")
            if accessToken != nil {
                
                do {
                    let fbURL = "https://graph.facebook.com/v2.7/me?fields=id,name,email,location,gender,first_name,middle_name,last_name,birthday,picture&access_token=\(accessToken!)"
                    let opt = try HTTP.GET(fbURL)
//                    print("fbURL: \(fbURL)")
                    print("opt: \(opt)")
                    opt.start { response in
                        print("opt: \(response)")
                        if let err = response.error {
                            print("error: \(err.localizedDescription)")
                            return //also notify app of failure as needed
                        }
                        
                        print("opt finished: \(response.description)")
                        let json = JSON(data: response.data)
//                        let birthday: String!
                        
//                        if json["birthday"] {
//                            
//                            print("inside birthday if statement")
//                            birthday = json["birthday"].string!
//                            
//                        }
//                        
//                        else {
//                            
//                            birthday = ""
//                        }
                        
                        request.saveUser(json["first_name"].string!, lastName: json["last_name"].string!, email: json["email"].string!, mobile: "", fbId: json["id"].string!, googleId: "", twitterId: "", instaId: "", nationality: "", profilePicture: json["picture"]["data"]["url"].string!, gender: json["gender"].string!, dob: "", completion: {(response) in
                            
                            dispatch_async(dispatch_get_main_queue(), {
                              
                                if (response.error != nil) {
                                    
                                    print("error: \(response.error!.localizedDescription)")
                                }
                                    
                                else {
                                    
                                    if response["value"] {
                                        
                                        currentUser = response["data"]
                                        self.gotoNationalityPage()
                                        
                                    }
//                                    print("response fb: \(response.description)")
                                    
                                }
                                
                            })
                        })
                        
                    }
                } catch let error {
                    print("got an error creating the request: \(error)")
                }
//
////                do {
////                    let opt = try HTTP.GET("https://graph.facebook.com/v2.5/me/picture?redirect=0&me/picture?redirect=0&height=1000&width=1000&access_token=\(accessToken)")
////                    opt.start { response in
////                        if let err = response.error {
////                            print("error: \(err.localizedDescription)")
////                            return //also notify app of failure as needed
////                        }
////                        
////                        print("opt finished: \(response.description)")
////                        let json = JSON(data: response.data)
////                        print("picture url: \(json["data"]["url"].string!)")
////                        
////                    }
////                } catch let error {
////                    print("got an error creating the request: \(error)")
////                }
//                
//            }
//            else
//            {
//                print(error!.localizedDescription)
//            }
        
        }
    }
        
    }
    
    func twitterSignIn(sender: UIButton) {
        
        var flag = 0
        
        print("twitter sign in")
        
        let sessionStore = Twitter.sharedInstance().sessionStore
//        sessionStore.logOutUserID(sessionStore.session()!.userID)
        if (sessionStore.session() != nil) {
            
//            print("session: \(sessionStore.session())")
            let alert = UIAlertController(title: "Twitter Sign In", message: "Lorem Ipsum", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                
                print("Okay Pressed")
                
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                
                flag = 1
                print("Cancel Pressed, flag: \(flag)")
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
            
        print("inside flag: \(flag)")
        
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if (session != nil) {
                
                print("session response: \(session!.userID)")
                print("signed in as \(session!.userName)");
                //                let client2 = TWTRAPIClient()
                //                client2.loadUserWithID(session!.userID) { (user, error) -> Void in
                //
                //                    print("user info: \(user)")
                //
                //                }
                
                let client = TWTRAPIClient()
                let statusesShowEndpoint = "https://api.twitter.com/1.1/users/show.json"
                let params = ["user_id": session!.userID, "screen_name": session!.userName]
                var clientError : NSError?
                
                let req = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
                
                client.sendTwitterRequest(req) { (response, data, connectionError) -> Void in
                    if connectionError != nil {
                        print("Error: \(connectionError)")
                    }
                    
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                        print("json: \(JSON(json))")
                        let serialJson = JSON(json)
                        
//                        print("name: \(serialJson["name"].string!)")
//                        print("mobile: 0123456789")
//                        print("id: \(session!.userID)")
//                        print("dp: \(serialJson["profile_image_url"].string!)")
                        request.saveUser(serialJson["name"].string!, lastName: "", email: "", mobile: "0123456789", fbId: "", googleId: "", twitterId: session!.userID, instaId: "", nationality: "", profilePicture: serialJson["profile_image_url"].string!, gender: "", dob: "", completion: {(response) in
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                if (response.error != nil) {
                                    
                                    print("error: \(response.error!.localizedDescription)")
                                }
                                    
                                else {
                                    
                                    print("response: \(response["data"])")
                                    currentUser = response["data"]
                                    self.gotoNationalityPage()
                                }
                                
                            })
                            
                        })
                        
                    } catch let jsonError as NSError {
                        print("json error: \(jsonError.localizedDescription)")
                    }
                }
                
            } else {
                print("error: \(error!.localizedDescription)");
            }
        }
        
        
//        let client = TWTRAPIClient.clientWithCurrentUser()
//        let request = client.URLRequestWithMethod("GET",
//                                                  URL: "https://api.twitter.com/1.1/account/verify_credentials.json",
//                                                  parameters: ["include_email": "true", "skip_status": "true"],
//                                                  error: nil)
//        
//        client.sendTwitterRequest(request) { response, data, connectionError in
//            
//            print("response: \(response)")
//        
//        }
        
        

//        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.twitter.com")!)
        
//        let provider = OAuth2(clientId: "1cyOA7neQUM0nm5BpN8qu6NXR", authorizationEndpoint: NSURL(fileURLWithPath: "https://api.twitter.com/oauth/authorize"), redirectEndpoint: NSURL(fileURLWithPath: ""), grantType: .Implicit)
//        
//        Simplicity.login(provider) { (accessToken, error) in
//           
//            print("accesstakoen: \(accessToken)")
//            
//        }
//        do {
////            let fbURL = "https://graph.facebook.com/v2.7/me?fields=id,name,email,location,gender,first_name,middle_name,last_name,birthday,picture&access_token=\(accessToken!)"
//            let opt = try HTTP.GET("https://api.twitter.com/oauth/request_token", parameters: nil, headers: ["oauth_consumer_key": "1cyOA7neQUM0nm5BpN8qu6NXR"])
////            print("fbURL: \(fbURL)")
//            opt.start { response in
//                if let err = response.error {
//                    print("error: \(err.localizedDescription)")
//                    return //also notify app of failure as needed
//                }
//                
//                print("opt finished: \(response.description)")
//                let json = JSON(data: response.data)
//                print("json: \(json)")
//            }
//        } catch let error {
//            print("got an error creating the request: \(error)")
//        }
    }
    
    func gotoNationalityPage() {
        
        print("inside nationality function")
//        let nationalityPage = self.storyboard?.instantiateViewControllerWithIdentifier("SelectCountryVC") as! SelectCountryViewController
//        print("nationality: \(nationalityPage)")
//        nationalityPage.whichView = "selectNationality"
//        self.navigationController?.pushViewController(nationalityPage, animated: true)
//        print("navigation: \(self.navigationController)")
        
        let nationalityPage = self.storyboard?.instantiateViewControllerWithIdentifier("nationalityNew") as! AddNationalityNewViewController
//        print("nationality: \(nationalityPage)")
//        nationalityPage.whichView = "selectNationality"
        self.navigationController?.pushViewController(nationalityPage, animated: true)
//        print("navigation: \(self.navigationController)")
        
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

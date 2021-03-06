//
//  helperFunctions.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 8/26/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Simplicity
import SwiftHTTP
import SwiftyJSON
import TwitterKit

func verifyUrl (urlString: String?) -> Bool {
    
    if let urlString = urlString {
        
        if let url = NSURL(string: urlString) {
            
            return UIApplication.sharedApplication().canOpenURL(url)
        }
    }
    return false
}

class SocialLoginClass: UIViewController {
    
    let signIn = SignInViewController()
    
    func googleLogin() {
        
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
                        
                        request.saveUser(json["name"]["givenName"].string!, lastName: json["name"]["familyName"].string!, email: json["emails"][0]["value"].string!, mobile: "", fbId: "", googleId: json["id"].string!, twitterId: "", instaId: "", nationality: "", profilePicture: json["image"]["url"].string!, gender: "", dob: "", completion: {(response) in
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                if (response.error != nil) {
                                    
                                    print("error: \(response.error!.localizedDescription)")
                                }
                                    
                                else {
                                    
                                    //                                print("response: \(response.description)")
                                    currentUser = response["data"]
                                    //                                    AppDelegate.createMenuView()
                                    leftViewController.viewDidLoad()
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
    
    func facebookLogin() {
        
        var facebook = Facebook()
        facebook.scopes = ["email", "user_birthday", "user_location"]
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
                        
                        var email = ""
                        var mobile = ""
                        
                        if json["email"] != nil {
                            
                            email = json["email"].string!
                            
                        }
                        else if json["mobile"] != nil {
                            
                            mobile = json["mobile"].string!
                            
                        }
                        
                        
                        request.saveUser(json["first_name"].string!, lastName: json["last_name"].string!, email: email, mobile: mobile, fbId: json["id"].string!, googleId: "", twitterId: "", instaId: "", nationality: "", profilePicture: json["picture"]["data"]["url"].string!, gender: json["gender"].string!, dob: "", completion: {(response) in
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                if (response.error != nil) {
                                    
                                    print("error: \(response.error!.localizedDescription)")
                                }
                                    
                                else {
                                    
                                    if response["value"] {
                                        
                                        currentUser = response["data"]
                                        //                                        AppDelegate.createMenuView()
                                        leftViewController.viewDidLoad()
                                        
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
    
    func twitterLogin() {
        
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
                                    //                                    AppDelegate.createMenuView()
                                    leftViewController.viewDidLoad()
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
    
}

extension NSDate {
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> NSDate {
        let timezone: NSTimeZone = NSTimeZone.localTimeZone()
        let seconds: NSTimeInterval = NSTimeInterval(timezone.secondsFromGMTForDate(self))
        return NSDate(timeInterval: seconds, sinceDate: self)
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> NSDate {
        let timezone: NSTimeZone = NSTimeZone.localTimeZone()
        let seconds: NSTimeInterval = -NSTimeInterval(timezone.secondsFromGMTForDate(self))
        return NSDate(timeInterval: seconds, sinceDate: self)
    }
}

extension UIView {
    
    func resizeToFitSubviews(initialHeight: CGFloat, finalHeight: CGFloat) {
        
        print("initial height: \(initialHeight)")
        print("final height: \(finalHeight)")
        
        if initialHeight < finalHeight {
            
            self.frame.size.height += finalHeight - initialHeight
        }
        
        else if finalHeight < initialHeight {
            
            self.frame.size.height += initialHeight - finalHeight
        }
        
        self.setNeedsLayout()
        
    }
}

import SystemConfiguration

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

extension NSData {
    
    var uint8: UInt8 {
        get {
            var number: UInt8 = 0
            self.getBytes(&number, length: sizeof(UInt8))
            return number
        }
    }
}

extension UInt8 {
    
    var data: NSData {
        var int = self
        return NSData(bytes: &int, length: sizeof(UInt8))
    }
    
}

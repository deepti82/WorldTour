//
//  helperFunctions.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 8/26/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import Foundation
import UIKit
import Simplicity
import SwiftHTTP
import TwitterKit

func verifyUrl (_ urlString: String?) -> Bool {
    
    if let urlString = urlString {
        
        if urlString.range(of:"http") != nil {
            return true
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
            
//            print("access token \(accessToken!)")
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
                        
                        if loggedInUser != nil {
                            request.changeLogin(id: loggedInUser["_id"].stringValue, facebookID: nil, googleID: json["id"].string!, completion: { (response) in
                                
                                DispatchQueue.main.async(execute: {
                                    
                                    if (response.error != nil) {
                                        
                                        print("error: \(response.error!.localizedDescription)")
                                    }
                                    else if response["value"].bool! {
                                        
                                        request.getUser(loggedInUser["_id"].stringValue, completion: { (response1) in
                                            
                                            
                                            DispatchQueue.main.async(execute: {
                                                
                                                if (response1.error != nil) {
                                                    
                                                    print("error: \(response1.error!.localizedDescription)")
                                                }
                                                    
                                                else {
                                                    
                                                    let response = response1["data"]
                                                    user.setUser(response["_id"].stringValue,
                                                                 name: response["name"].stringValue,
                                                                 useremail: response["email"].stringValue,
                                                                 profilepicture: response["profilePicture"].stringValue,
                                                                 travelconfig: "", 
                                                                 loginType: "google",
                                                                 socialId: loggedInUser["_id"].string!,
                                                                 userBadge: response["userBadgeImage"].stringValue,
                                                                 homecountry: response["homeCountry"]["name"].stringValue,
                                                                 homecity: response["homeCity"].stringValue,
                                                                 isloggedin: response["alreadyLoggedIn"].bool!, 
                                                                 dataUpload:"", privacy:"" )
                                                    
                                                    if response1["value"].bool! {
                                                        
                                                        currentUser = response1["data"]
                                                        //                                        AppDelegate.createMenuView()
                                                        leftViewController.viewDidLoad()
                                                        
                                                        self.gotoNationalityPage()
                                                        
                                                    }
                                                    //                                    print("response fb: \(response.description)")
                                                    
                                                }
                                                
                                            })
                                            
                                        })
                                    }
                                })
                            })                            
                        }
                        else {
                            request.saveUser(json["name"]["givenName"].string!, lastName: json["name"]["familyName"].string!, email: json["emails"][0]["value"].string!, mobile: "", fbId: "", googleId: json["id"].string!, twitterId: "", instaId: "", nationality: "", profilePicture: json["image"]["url"].string!, gender: "", dob: "", completion: {(response) in                                
                                DispatchQueue.main.async(execute: {
                                    
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
        
        let facebook = Facebook()
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
                        
                        if loggedInUser != nil {
                            request.changeLogin(id: loggedInUser["_id"].stringValue, facebookID: json["id"].string!, googleID: nil, completion: { (responsess) in
                                
                                DispatchQueue.main.async(execute: {
                                    
                                    if (responsess.error != nil) {
                                        
                                        print("error: \(responsess.error!.localizedDescription)")
                                    }
                                    else if responsess["value"].bool! {
                                        
                                        request.getUser(loggedInUser["_id"].stringValue, completion: { (response1) in
                                            DispatchQueue.main.async(execute: {
                                                print("response11: \(response1)")
                                                if (response1.error != nil) {
                                                    
                                                    print("error: \(response1.error!.localizedDescription)")
                                                }
                                                    
                                                else {
                                                    let response = response1["data"]
                                                    print("id : \(response["_id"].stringValue)")
                                                    user.setUser(response["_id"].stringValue,
                                                                 name: response["name"].stringValue,
                                                                 useremail: response["email"].stringValue,
                                                                 profilepicture: response["profilePicture"].stringValue,
                                                                 travelconfig: "", 
                                                                 loginType: "facebook",
                                                                 socialId: loggedInUser["_id"].string!,
                                                                 userBadge: response["userBadgeImage"].stringValue,
                                                                 homecountry: response["homeCountry"]["name"].stringValue,
                                                                 homecity: response["homeCity"].stringValue,
                                                                 isloggedin: response["alreadyLoggedIn"].bool!, 
                                                                 dataUpload:"", privacy:"" )
                                                    
                                                    if response1["value"].bool! {
                                                        
                                                        currentUser = response1["data"]
                                                        //                                        AppDelegate.createMenuView()
                                                        leftViewController.viewDidLoad()
                                                        
                                                        self.gotoNationalityPage()
                                                        
                                                    }
                                                    //                                    print("response fb: \(response.description)")
                                                    
                                                }
                                                
                                            })
                                            
                                        })
                                    }
                                })
                            })                        
                        }
                        else {
                            request.saveUser(json["first_name"].string!, lastName: json["last_name"].string!, email: email, mobile: mobile, fbId: json["id"].string!, googleId: "", twitterId: "", instaId: "", nationality: "", profilePicture: json["picture"]["data"]["url"].string!, gender: json["gender"].string!, dob: "", completion: {(response) in
                                
                                DispatchQueue.main.async(execute: {
                                    
                                    if (response.error != nil) {
                                        
                                        print("error: \(response.error!.localizedDescription)")
                                    }
                                        
                                    else {
                                        
                                        if response["value"].bool! {
                                            
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
                        
                    }
                } catch let error {
                    print("got an error creating the request: \(error)")
                }
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
            let alert = UIAlertController(title: "Twitter Sign In", message: "Lorem Ipsum", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
                print("Okay Pressed")
                
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
                
                flag = 1
                print("Cancel Pressed, flag: \(flag)")
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        print("inside flag: \(flag)")
        
        Twitter.sharedInstance().logIn { session, error in
            if (session != nil) {
                
                print("session response: \(session!.userID)")
                print("signed in as \(session!.userName)");
                let client = TWTRAPIClient()
                let statusesShowEndpoint = "https://api.twitter.com/1.1/users/show.json"
                let params = ["user_id": session!.userID, "screen_name": session!.userName]
                var clientError : NSError?
                
                let req = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
                
                client.sendTwitterRequest(req) { (response, data, connectionError) -> Void in
                    if connectionError != nil {
                        print("Error: \(connectionError)")
                    }
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: [])
                        print("json: \(JSON(json))")
                        let serialJson = JSON(json)
                        
                        //                        print("name: \(serialJson["name"].string!)")
                        //                        print("mobile: 0123456789")
                        //                        print("id: \(session!.userID)")
                        //                        print("dp: \(serialJson["profile_image_url"].string!)")
                        request.saveUser(serialJson["name"].string!, lastName: "", email: "", mobile: "0123456789", fbId: "", googleId: "", twitterId: session!.userID, instaId: "", nationality: "", profilePicture: serialJson["profile_image_url"].string!, gender: "", dob: "", completion: {(response) in
                            
                            DispatchQueue.main.async(execute: {
                                
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
        
    }
    
}

extension Date {
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone: TimeZone = TimeZone.autoupdatingCurrent
        let seconds: TimeInterval = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone: TimeZone = TimeZone.autoupdatingCurrent
        let seconds: TimeInterval = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}

extension UIView {
    
    func resizeToFitSubviews(_ initialHeight: CGFloat, finalHeight: CGFloat) {
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

open class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

extension Data {

    var uint8: UInt8 {
        get {
            var number: UInt8 = 0
            (self as NSData).getBytes(&number, length: MemoryLayout<UInt8>.size)
            return number
        }
    }
}

extension UInt8 {

//    var data: Data {
//        var int = self
//        return Data(bytes: UnsafePointer<UInt8>(&int), count: sizeof(UInt8))
//    }

}

func getDocumentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

// IMAGE CACHING

//var imageCache = [String: UIImage]()
var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func loadImageFromURL(_ imageURL: String) {

        if let image = imageCache.object(forKey: self) as? UIImage {

            self.image = image

        } else {

//            DispatchQueue.main.async(execute: {

                if let dataURL = URL(string: imageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {

                        do {
                                let data = try Data(contentsOf: dataURL)
                                let image = UIImage(data: data)
                                self.image = image

                                // IMAGE CACHE
                                //imageCache[self] = image
                                imageCache.setObject(image!, forKey: imageURL as AnyObject)
                        } catch _ {
                            print("Unable to set image")
                        }
//                    })
                }

//            })

        }
    }
    
    
    
}

func isUserMe(user:String) -> Bool {
    let loggedInUser = User()
    if user == loggedInUser.getExistingUser() {
        return true
    }else{
        return false
    }
}

func log(_ message: String, _ filename: String = #file, _ line: Int = #line, _ function: String = #function) {
    print("\((filename as NSString).lastPathComponent):\(line) \(function):\r\(message)\n\n")
}

//func imageDefaultCaching() {
//    let memoryCapacity = 500 * 1024 * 1024
//    let diskCapacity = 500 * 1024 * 1024
//    let urlCache = Foundation.URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "myDiskPath")
//    URLCache.setSharedURLCache(urlCache)
//}

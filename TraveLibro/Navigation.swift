//
//  Navigation.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 03/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftHTTP

let adminUrl = "http://192.168.0.108:1337/"
//let apiURL = "";

class Navigation {
    
//    var json: JSON!
    
    func saveUser(firstName: String, lastName: String, email: String, mobile: String, fbId: String, googleId: String, twitterId: String, instaId: String, nationality: String, profilePicture: String, gender: String, dob: String, completion: ((JSON) -> Void)) {
        
        print("name: \(firstName), \(lastName)")
        
        var json = JSON(1);
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        print("device id: \(deviceId)")
        let params = ["firstName":firstName, "lastName":lastName, "email": email, "mobile": mobile, "facebookID": fbId, "googleID": googleId, "twitterID": twitterId, "instagramID": instaId, "nationality": nationality, "profilePicture": profilePicture, "gender": gender, "deviceId": deviceId, "dob": dob]
        print(params)
        
        do {
            let opt = try HTTP.POST(adminUrl + "user/save", parameters: params)
//            print("request: \(opt)")
            opt.start { response in
//                print("started response: \(response)")
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    print(json)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    func editUser(id: String, editField: String, editFieldValue: String, completion: ((JSON) -> Void)) {
        
        var json = JSON(1);
//        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
//        print("device id: \(deviceId)")
        let params = ["_id":id, editField:editFieldValue]
        print(params)
        
        do {
            let opt = try HTTP.POST(adminUrl + "user/editData", parameters: params)
            //            print("request: \(opt)")
            opt.start { response in
                //                print("started response: \(response)")
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    print(json)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    func signUpSocial(id: String, completion:((JSON) -> Void)) {
        
        switch id {
        case "google":
//            do {
//                let opt = try HTTP.POST(adminUrl + "tempUser/register", parameters: id)
//                opt.start { response in
//                    if let err = response.error {
//                        print("error: \(err.localizedDescription)")
//                    }
//                    else
//                    {
//                        json  = JSON(data: response.data)
//                        print(json)
//                        completion(json)
//                    }
//                }
//            } catch let error {
//                print("got an error creating the request: \(error)")
//            }
            break
        case "facebook":
//            do {
//                let opt = try HTTP.POST(adminUrl + "user/logInGoogle", parameters: id)
//                opt.start { response in
//                    if let err = response.error {
//                        print("error: \(err.localizedDescription)")
//                    }
//                    else
//                    {
//                        json  = JSON(data: response.data)
//                        print(json)
//                        completion(json)
//                    }
//                }
//            } catch let error {
//                print("got an error creating the request: \(error)")
//            }
            break
        case "twitter":
//            do {
//                let opt = try HTTP.POST(adminUrl + "tempUser/register", parameters: id)
//                opt.start { response in
//                    if let err = response.error {
//                        print("error: \(err.localizedDescription)")
//                    }
//                    else
//                    {
//                        json  = JSON(data: response.data)
//                        print(json)
//                        completion(json)
//                    }
//                }
//            } catch let error {
//                print("got an error creating the request: \(error)")
//            }
            break
        default:
            break
        }
        
        
    }
    
//    func verifyUser(email: String, completion: ((JSON) -> Void)) {
//        
//        do {
//            
//            let opt = try HTTP.POST(adminUrl + "tempUser/emailVerificationCheck", parameters: ["email": email])
//            var json = JSON(1);
//            opt.start { response in
//                //                print("started response: \(response)")
//                if let err = response.error {
//                    print("error: \(err.localizedDescription)")
//                }
//                else
//                {
//                    json  = JSON(data: response.data)
//                    print(json)
//                    completion(json)
//                }
//            }
//        } catch let error {
//            print("got an error creating the request: \(error)")
//        }
//        
//        
//    }
    
    func addNewOTG(name: String, userId: String, startLocation: String, kindOfJourney: [String], timestamp: String, completion: ((JSON) -> Void)) {
        
        let params = ["name": name, "user":  userId, "startLocation": startLocation, "kindOfJourney": kindOfJourney, "timestamp": timestamp]
        print("parameters: \(params)")
        do {
            
            let opt = try HTTP.POST(adminUrl + "journey/save", parameters: [params])
            var json = JSON(1);
            opt.start { response in
                //                print("started response: \(response)")
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    print(json)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
        
    }
    
    func addBuddiesOTG(friends: [String], userId: String, journeyId: String, completion: ((JSON) -> Void)) {
        
        do {
            
            let params = ["buddies": friends, "uniqueId": journeyId]
            let opt = try HTTP.POST(adminUrl + "journey/addBuddy", parameters: [params])
            var json = JSON(1);
            opt.start { response in
                //                print("started response: \(response)")
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    print(json)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    func getLocation(lat: Double, long: Double, completion: ((JSON) -> Void)) {
        
        do {
            
            let opt = try HTTP.POST(adminUrl + "journey/getLocation", parameters: ["lat": lat, "long": long])
            var json = JSON(1);
            opt.start { response in
                //                print("started response: \(response)")
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    print(json)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
        
    }
    
    func getAllFriends(completion: ((JSON) -> Void)) {
        
        do {
            
            let opt = try HTTP.POST(adminUrl + "user/getAll", parameters: nil)
            var json = JSON(1);
            opt.start { response in
                //                print("started response: \(response)")
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    print(json)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
        
    }
    
    func uploadPhotos(file: NSURL, completion: ((JSON) -> Void)) {
        
        do {
            
            let params = ["file": Upload(fileUrl: file)]
            
            let opt = try HTTP.POST(adminUrl + "upload", parameters: params)
            var json = JSON(1);
            opt.start { response in
                //                print("started response: \(response)")
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    print(json)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
        
    }
    
    func getAllCountries(completion: ((JSON) -> Void)) {
        
        do {
            
//            let params = ["file": Upload(fileUrl: file)]
            
            let opt = try HTTP.POST(adminUrl + "country/getAll", parameters: nil)
            var json = JSON(1);
            opt.start { response in
                //                print("started response: \(response)")
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    print(json)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
        
    }
    
    
}

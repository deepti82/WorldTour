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

let adminUrl = "http://192.168.2.26:1337/api/"
//let apiURL = "";

class Navigation {
    
//    var json: JSON!
    
    func saveUser(firstName: String, lastName: String, email: String, mobile: String, fbId: String, googleId: String, twitterId: String, instaId: String, nationality: String, profilePicture: String, gender: String, dob: String, completion: ((JSON) -> Void)) {
        
        print("name: \(firstName), \(lastName)")
        
        var json = JSON(1);
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        let deviceParams = ["_id": deviceId, "os": "iOS"]
        
        print("device id: \(deviceId)")
        let params = ["firstName":firstName, "lastName":lastName, "email": email, "mobile": mobile, "facebookID": fbId, "googleID": googleId, "twitterID": twitterId, "instagramID": instaId, "nationality": nationality, "profilePicture": profilePicture, "gender": gender, "deviceId": deviceParams, "dob": dob]
//        print(params)
        
        do {
            let opt = try HTTP.POST(adminUrl + "user/save", parameters: [params])
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
            let opt = try HTTP.POST(adminUrl + "user/editUser", parameters: params)
            //            print("request: \(opt)")
            opt.start { response in
                print("started response: \(response)")
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
    
    func getUser(id: String, completion: ((JSON) -> Void)) {
        
        var json = JSON(1);
        //        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        //        print("device id: \(deviceId)")
        let params = ["_id":id]
        print(params)
        
        do {
            let opt = try HTTP.POST(adminUrl + "user/getOne", parameters: params)
            //            print("request: \(opt)")
            opt.start { response in
                print("started response: \(response)")
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
    
    func searchCity(searchText: String, completion: ((JSON) -> Void)) {
        
        do {
            
            //            let params = ["file": Upload(fileUrl: file)]
            
            let opt = try HTTP.POST(adminUrl + "city/locationSearch", parameters: ["search": searchText])
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
    
    func addKindOfJourney(id: String, editFieldValue: [String: [String]], completion: ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id, "travelConfig": editFieldValue]
            
            let opt = try HTTP.POST(adminUrl + "user/editUser", parameters: [params])
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
    
    func getImageBytes(file: String, completion: ((JSON) -> Void)) {
        
        do {
            
//            let params = ["file": file]
            
            let opt = try HTTP.GET(adminUrl + "upload/readFile?file=" + file)
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
    
    func getBucketList(id: String, completion: ((JSON) -> Void)) {
        
        do {
            
            //            let params = ["file": file]
            
            let opt = try HTTP.POST(adminUrl + "user/getBucketList", parameters: ["_id": id])
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
    
    func updateBucketList(id: String, list: [String], completion: ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id, "bucketList": list]
            print("params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "user/updateBucketList", parameters: [params])
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
    
    func removeBucketList(id: String, country: String, completion: ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id, "bucketList": country, "delete": true]
            print("params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "user/updateBucketList", parameters: [params])
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
    
    func addCountriesVisited(id: String, list: [NSDictionary], completion: ((JSON) -> Void)) {
        
//        var jsonDict: NSDictionary!
//        let str = "\(list)"
//        let data = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
//        print("data: \(data)")
        
        do {
            
//            var error: NSError?
//            var jsonData: NSData!
//            
//            do {
//                
//                try jsonData = list.rawData()
//            }
//            catch {
//                
//                print("error")
//                
//            }
            
//            do {
//                jsonDict = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String: AnyObject]
////                let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String: AnyObject]
////                if let names = json["names"] as? [String] {
////                    print(names)
////                }
//            } catch let error as NSError {
//                print("Failed to load: \(error.localizedDescription)")
//            }
            
            var jsonParams: [(year: String, countryId: String)] = [(year: "2016", countryId: "57c146ba528f42240deff3fd")]
            jsonParams.append((year: "2016", countryId: "57c146ba528f42240deff3fe"))
            
            let params = ["_id": id, "countriesVisited": jsonParams as! AnyObject]
            print("params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "user/updateCountriesVisited", parameters: [params])
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
    
    func getCountriesVisited(id: String, completion: ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id]
            print("params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "user/getCountryVisitedList", parameters: [params])
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
    
    func getBucketListCount(id: String, completion: ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id]
            print("params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "user/getOneData", parameters: params)
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

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

let apiUrl = "http://10.0.0.34:1337/api/"
let adminUrl = "http://104.155.207.185:92/api/"
let tempUrl = "http://10.0.0.6:1337/api/demo/demo"
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
            
            let opt = try HTTP.POST(tempUrl + "user/updateBucketList", parameters: [params])
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
    
//    func getBucketList(id: String, completion: ((JSON) -> Void)) {
//        
//        do {
//            
//            //            let params = ["file": file]
//            
//            let opt = try HTTP.POST(adminUrl + "user/getBucketList", parameters: ["_id": id])
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
    
    func addCountriesVisited(id: String, list: JSON, countryVisited: String, completion: ((JSON) -> Void)) {
        
//        var jsonDict: NSDictionary!
//        let str = "\(list)"
//        let data = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
//        print("data: \(data)")
        
//        do {
        
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
            
//            var jsonParams: [(year: String, countryId: String)] = [(year: "2016", countryId: "57c146ba528f42240deff3fd")]
//            jsonParams.append((year: "2016", countryId: "57c146ba528f42240deff3fe"))
            
        var params: JSON = ["_id": id, "countryId": countryVisited]
            //            params["_id"].stringValue = id
            //            params["countryId"].stringValue = countryVisited
        params["visited"] = list
        
            do {
                
                let jsonData = try! params.rawData()
                // create post request
                let url = NSURL(string: adminUrl + "user/updateCountriesVisited")!
                let request = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "POST"
                
                // insert json data to the request
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.HTTPBody = jsonData
                
                
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                    if error != nil{
                        print("Error -> \(error)")
                        return
                    }
                    
                    do {
                        let result = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                        print("Result: \(result)")
                        completion(JSON(result))
                        
                    } catch {
                        print("Error: \(error)")
                    }
                }
                
                task.resume()
//                return task
                
                
                
            } catch {
                print(error)
            }
            
            
//            let newParams = ["data": "\(params)"]
            
//            print("params: \(params)")
//            print("new params: \(list)")
//            let a: JSON = {'_id' :'57bfe0adefb158eb6f831c0a','visited' : [{'year' : '2016', 'times' : 1},{'year' : '2015','times' : 1},{'year' : '2014','times' : 1}],'countryId' : '57c146ba528f42240deff426'}
            
//            let opt = try HTTP.POST(, parameters: )
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
    
    func removeCountriesVisited(id: String, countryId: String, completion: ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id, "removeId": countryId]
            print("params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "user/removeCountriesVisited", parameters: [params])
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
    
    func followUser(userId: String, followUserId: String, completion: ((JSON) -> Void)) {
        
        do {
            
            let params = ["user": userId, "_id": followUserId]
            print("params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "user/followUser", parameters: params)
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
    
    func getFollowers(userId: String, completion: ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": userId]
            print("params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "user/getFollowers", parameters: params)
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
    
    func unfollow(userId: String, unFollowId: String, completion: ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": unFollowId, "user": userId]
            print("params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "user/getFollowers", parameters: params)
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
    
    func getFollowing(userId: String, completion: ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": userId]
            print("params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "user/getFollowing", parameters: params)
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

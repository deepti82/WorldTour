import UIKit

import SwiftHTTP
import OneSignal
import Haneke
import Crashlytics

//var adminUrl = "https://travelibro.wohlig.com/api/"
var adminUrl = "https://travelibro.com/api/"
var mapKey = "AIzaSyDPH6EYKMW97XMTJzqYqA0CR4fk5l2gzE4"

class Navigation {
    
    let cache = Shared.dataCache
    
//    var json: JSON!

    
    func saveUser(_ firstName: String, lastName: String, email: String, mobile: String, fbId: String, googleId: String, twitterId: String, instaId: String, nationality: String, profilePicture: String, gender: String, dob: String, completion: @escaping ((JSON) -> Void)) {
        print("\n gender in saveUser : \(gender)")
        
        var json1 = JSON(1);        
        OneSignal.idsAvailable({(_ userId, _ pushToken) in
            let deviceParams = userId! as String
            let params = ["firstName":firstName, "lastName":lastName, "email": email, "mobile": mobile, "facebookID": fbId, "googleID": googleId, "twitterID": twitterId, "instagramID": instaId, "nationality": nationality, "profilePicture": profilePicture, "gender": gender, "deviceId": deviceParams, "dob": dob] as [String : Any]
            
            print("\n\n Params : \n \(params)")
            do {
                let opt = try HTTP.POST(adminUrl + "user/save", parameters: [params])
                opt.start { response in
                    if let err = response.error {
                        DispatchQueue.main.async(execute: {
                            print("error: \(err.localizedDescription)")
                            shouldShowLoader = false
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SAVE_USER_FAILED"), object: nil)                            
                        })
                    }
                    else
                    {
                        json1  = JSON(data: response.data)                        
                        var json = json1["data"]                        
                        var socialType = ""
                        var socialId = ""
                        
                        if json["googleID"].stringValue != "" {
                            socialType = "google"
                            socialId = json["googleID"].string!
                        }
                        else if json["facebookID"].stringValue != "" {
                            socialType = "facebook"
                            socialId = json["facebookID"].string!
                        }
                        user.setUser(json["_id"].stringValue, name: json["name"].stringValue, useremail: json["email"].stringValue, profilepicture: json["profilePicture"].stringValue, travelconfig: "", loginType: socialType, socialId: socialId, userBadge: json["userBadgeImage"].stringValue, homecountry: json["homeCountry"]["name"].stringValue, homecity: json["homeCity"].stringValue, isloggedin: json["alreadyLoggedIn"].bool!, privacy:json["status"].stringValue )
                        completion(json1)
                    }
                }
            } catch let error {
                print("got an error creating the request: \(error)")
            }

        })
        
    }
    
    func editUser(_ id: String, editField: String, editFieldValue: String, completion: @escaping ((JSON) -> Void)) {
        
        var json = JSON(1);
        let params = ["_id":id, editField:editFieldValue]
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
                    let urlString = adminUrl + "user/getOne"
                    self.cache.set(value: response.data, key: urlString+id)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func reportProblem(_ id: String, problemMessage: String, completion: @escaping ((JSON) -> Void)) {
        var json = JSON(1);
        let params = ["user":id, "problem":problemMessage]
        do {
            let opt = try HTTP.POST(adminUrl + "reportProblems/save", parameters: params)
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func bulkEditUser(params: [String : Any], completion: @escaping ((JSON) -> Void)) {
        
        var json = JSON(1);
        do {
            let opt = try HTTP.POST(adminUrl + "user/editUser", parameters: params)
            //            print("request: \(opt)")
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func getUserFromCache(_ id: String, completion: @escaping ((JSON) -> Void)) {
        let urlString = adminUrl + "user/getOne"
        self.cache.fetch(key: urlString+id).onSuccess { data in
            let json = JSON(data: data)
            print("\n getUserFromCache : \(json["data"]["name"].stringValue)")
            completion(json)
        }.onFailure { (error) in
            print("Error : \(error)")
            request.getUser(id, urlSlug: "", completion: { (response, isFromCache) in
                if !(isFromCache) {
                    completion(response)                    
                }
            })
        }
        
        
    }
    
    func getUser(_ id: String, urlSlug: String?, completion: @escaping ((JSON, Bool) -> Void)) {
        
        
        var json = JSON(1);
        var params = ["_id":id]
        if urlSlug != "" && urlSlug != nil {
            params["urlSlug"] = urlSlug!
        }
        
        print("\n get user params : \(params)")
        
        let urlString = adminUrl + "user/getOne"
        
        if urlSlug == nil || urlSlug == "" {
            
            self.cache.fetch(key: urlString+id).onSuccess { data in
                let json = JSON(data: data)
                print("\n getUser upper : \(json["data"]["name"].stringValue)")
                completion(json,true)
            }
        }
        
        do {
            let opt = try HTTP.POST(adminUrl + "user/getOne", parameters: params)
            //            print("request: \(opt)")
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    if urlSlug == "" {
                        self.cache.set(value: response.data, key: urlString+id)
                    }
                    completion(json,false)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
        
        
        
        
        
    }
    
    func getUserOnce(_ id: String, urlSlug: String?, completion: @escaping ((JSON) -> Void)) {
        
        
        var json = JSON(1);
        var params = ["_id":id]
        if urlSlug != nil {
            params["urlSlug"] = urlSlug!
        }
        let urlString = adminUrl + "user/getOne"
        self.cache.fetch(key: urlString+id).onSuccess { data in
            print(data);
            let json = JSON(data: data)
            completion(json)
        }.onFailure { (err) in
                do {
                    let opt = try HTTP.POST(adminUrl + "user/getOne", parameters: params)
                    //            print("request: \(opt)")
                    opt.start { response in
                        if let err = response.error {
                            print("error: \(err.localizedDescription)")
                        }
                        else
                        {
                            json  = JSON(data: response.data)
                            self.cache.set(value: response.data, key: urlString+id)
                            completion(json)
                        }
                    }
                } catch let error {
                    print("got an error creating the request: \(error)")
                }
        }
    }
    
    func signUpSocial(_ id: String, completion:((JSON) -> Void)) {
        
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
    
//    func verifyUser(email: String, completion: @escaping ((JSON) -> Void)) {
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
    
    func addNewOTG(_ name: String, userId: String, startLocation: String, kindOfJourney: [String], timestamp: String, lp: String, lat: String, long: String, completion: @escaping ((JSON) -> Void)) {
        
        let currentDate = Date()
        let currentDateFormatter = DateFormatter()
        currentDateFormatter.timeZone = TimeZone.autoupdatingCurrent
        currentDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let showDate = currentDateFormatter.date(from: "\(currentDate)")!
        let showDateArray = "\(showDate)".components(separatedBy: " +")
//        print("current date 2: \(currentDate) \(showDateArray[0])")
        
        let params = ["name": name, "user":  userId, "startLocation": startLocation, "kindOfJourney": kindOfJourney, "timestamp": timestamp, "startLocationPic": lp, "startTime": "\(showDateArray[0])", "location": ["lat": lat, "long": long]] as [String : Any]
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
    
    func addBuddiesOTG(_ friends: [JSON], userId: String, userName: String, journeyId: String, inMiddle: Bool, journeyName: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            var params: JSON = ["uniqueId": journeyId, "inMiddle": inMiddle, "name": userName, "user": userId, "journeyName": journeyName]
            params["buddies"] = JSON(friends)
            
            print("add buddies params: \(params)")
            
            let jsonData = try params.rawData()
            
            // create post request
            let url = URL(string: adminUrl + "journey/addBuddy")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
//            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
//                if error != nil{
//                    print("Error -> \(error)")
//                    return
//                }
//                
//                do {
//                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
//                    print("response: \(JSON(result))")
//                    completion(JSON(result))
//                    
//                } catch {
//                    print("Error: \(error)")
//                }
//            }
//            
//            task.resume()
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    print("Result: \(result)")
                    completion(JSON(result))
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            
            task.resume()
            
        
//        print("add buddies params: \(params)")
//        do {
//            let opt = try HTTP.POST(adminUrl + "journey/addBuddy", parameters: [params])
//            var json: JSON = []
//            
//            opt.start {response in
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
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    
    }
    
    func getLocation(_ lat: Double, long: Double, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let opt = try HTTP.POST(adminUrl + "journey/getLocation", parameters: ["lat": lat, "long": long])
            var json = JSON(1);
            json = JSON(["value" : false])            
            opt.start { response in
                //                print("started response: \(response)")
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    completion(json)
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
    
    func getAllFriends(_ completion: @escaping ((JSON) -> Void)) {
        
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
    
    func uploadPhotos(_ file: URL, localDbId: Int?, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            var id = ""
            
            if localDbId != nil {
                
                id = "\(localDbId!)"
            }
            HTTP.globalRequest { req in
                req.timeoutInterval = 6000
            }
            
            print("inside upload files: \(id) \(file)")
            
            let opt = try HTTP.POST(adminUrl + "upload", parameters: ["localId": id, "file": Upload(fileUrl: file)])
            
            var json = JSON(1);
            opt.start { response in
                //                print("started response: \(response)")
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    json["localId"] = JSON(id)
                    print("upload file response: \(json)")
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
        
    }
    
    func uploadPhotosMultiple(_ files: [URL], completion: @escaping ((JSON) -> Void)) {
        
//        do {
        
////            var myFiles: [Upload] = []
////            
////            dispatch_async(dispatch_get_main_queue(), {
////                
////                for file in files {
////                    
////                    myFiles.append(Upload(fileUrl: file))
////                    print("request upload \(file)")
////                    
////                }
////                
////            })
////            
////            let params = ["file": myFiles]
////            print("out of request upload \(params)")
////            
//////            let params =
////            let opt = try HTTP.POST(adminUrl + "upload", parameters: params)
////            var json = JSON(1);
////            opt.start { response in
////                //                print("started response: \(response)")
////                if let err = response.error {
////                    print("error: \(err.localizedDescription)")
////                }
////                else
////                {
////                    json  = JSON(data: response.data)
////                    print(json)
////                    completion(json)
////                }
//            let opt = try Alamofire.upload(
//                multipartFormData: {multipartFormData in
//                    
//                    for file in files {
//                        
//                        multipartFormData.append(files[0])
//                    }
//                    
//                    //                multipartFormData.append(files[1])
//                },
//                to: adminUrl + "upload",
//                encodingCompletion: { encodingResult in
//                    switch encodingResult {
//                    case .success(let upload):
//                        upload.responseJSON { response in
//                            debugPrint(response)
//                            completion(response)
//                        }
//                    case .failure(let encodingError):
//                        print(encodingError)
//                    }
//                }
//            )
//            
//            }
//        } catch let error {
//            print("got an error creating the request: \(error)")
//        }
    
        
    }
    
    func sampleImages(_ file: UIImage, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["file": file]
            
            let opt = try HTTP.POST(adminUrl + "upload", parameters: params)
            var json = JSON(1);
            opt.start { response in
                
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
    
    func getAllCountries(_ completion: @escaping ((JSON) -> Void)) {
        
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
//                    print(json)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
        
    }
    
    func searchCity(_ searchText: String, completion: @escaping ((JSON) -> Void)) {
        
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
    
    func addKindOfJourney(_ id: String, editFieldValue: [String: [String]], completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id, "travelConfig": editFieldValue] as [String : Any]
            
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
    
    func addCard(_ id: String, editFieldValue: [String:Any], completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id, "travelConfig": editFieldValue] as [String : Any]
            
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
    
    func getImageBytes(_ file: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
//            let params = ["file": file]
            print("file to be read: \(file)")
            
//            HTTP.globalRequest { req in
//                req.timeoutInterval = 6000
//            }
            let opt = try HTTP.GET(adminUrl + "upload/readFile?file=" + file)
            print("opt: \(opt)")
            var json = JSON(1);
            opt.start { response in
                print("started response: \(response.description)")
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    print("get image response: \(json)")
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
        
    }
    
    func getBucketList(_ id: String, completion: @escaping ((JSON) -> Void)) {
        
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
    
    func updateBucketList(_ id: String, list: [String], completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id, "bucketList": list] as [String : Any]
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
    
    func removeBucketList(_ country: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": user.getExistingUser(), "bucketList": country, "delete": true] as [String : Any]
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
    
    func addCountriesVisited(_ id: String, list: JSON, countryVisited: String, completion: @escaping ((JSON) -> Void)) {
        
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
        params["visited"] = list
        
            do {
                
                let jsonData = try! params.rawData()
                // create post request
                let url = URL(string: adminUrl + "user/updateCountriesVisited")!
                let request = NSMutableURLRequest(url: url)
                request.httpMethod = "POST"
                
                // insert json data to the request
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                    if error != nil{
                        print("Error -> \(error)")
                        return
                    }
                    
                    do {
                        let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                        print("response: \(JSON(result))")
                        completion(JSON(result))
                        
                    } catch {
                        print("Error: \(error)")
                    }
                }
                
                task.resume()
                
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
    
    func getCountriesVisited(_ id: String, completion: @escaping ((JSON) -> Void)) {
        
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

    
    func removeCountriesVisited(_ countryId: String, year: Int, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": user.getExistingUser(), "countryId": countryId, "year": year] as [String : Any]
            print("params remove countries visited: \(params)")
            
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
    
    func getBucketListCount(_ id: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id]
            print("params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "user/getOne", parameters: params)
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
    
    func followUser(_ userId: String, followUserId: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["user": userId, "_id": followUserId]
            print(params)
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
    
    func getFollowers(_ userId: String, searchText: String, urlSlug:String?, callbackNum:Int,  completion: @escaping ((JSON, Int) -> Void)) {
        
        do {
            
            var params = ["_id": userId, "search": searchText]
            
            if urlSlug != nil && urlSlug != "" {
                params["urlSlug"] = urlSlug!
            }
            
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
                    completion(json, callbackNum)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func unfollow(_ userId: String, unFollowId: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": unFollowId, "user": userId]
            let opt = try HTTP.POST(adminUrl + "user/unFollowUser", parameters: params)
            var json = JSON(1);
            opt.start { response in
                //                print("started response: \(response)")
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func getFollowing(_ userId: String, searchText: String, urlSlug: String?, callbackNum:Int, completion: @escaping ((JSON, Int) -> Void)) {
        
        do {
            
            var params = ["_id": userId, "search": searchText]
            
            if urlSlug != nil && urlSlug != "" {
               params["urlSlug"] = urlSlug!
            }
            
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
                    completion(json,callbackNum)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func getOTGJourney(_ userId: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["user": userId]
//            print("params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "journey/getOnGoing", parameters: params)
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func getJourneyCoverPic(_ city: String, lat: String, long: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            //print("places: \(places)")
            print()
            // let params = ["placeId": "\(places)"]
            let params = ["city": city, "lat": lat, "long": long, "size": "800x600"]
            
            let opt = try HTTP.GET(adminUrl + "upload/getGooglePic", parameters: params)
            var json = JSON(1);
            opt.start {response in
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
    
    func getBuddySearch(_ userId: String, searchtext: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let opt = try HTTP.POST(adminUrl + "user/searchBuddy", parameters: ["_id": userId, "search":  searchtext])
            var json = JSON(1);
            opt.start {response in
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
    
    func getLocationOTG(_ lat: Double, long: Double, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let opt = try HTTP.POST(adminUrl + "post/placeSearch", parameters: ["lat": lat, "long":  long])
            var json = JSON(1);
            opt.start {response in
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
    
    func getJourney(_ id: String, canGetCachedData: Bool, completion: @escaping ((JSON, Bool) -> Void)) {
        
        do {
            
            let urlString = adminUrl + "journey/getOnGoing"
            var isCacheInvalid = false
            
            if !isNetworkReachable || canGetCachedData {
                if(isSelfUser(otherUserID: id)) {
                    self.cache.fetch(key: urlString+id).onSuccess { data in
                        let json = JSON(data: data)
                        completion(json,true)
                    }
                    .onFailure({ (error) in
                        isCacheInvalid = true
                        print("\n ERROR in fetching OTG data from cache : \(error)")
                    })
                }
            }
            
            
            let opt = try HTTP.POST(urlString, parameters: ["user": id])
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    if(isSelfUser(otherUserID: id)) {
                        self.cache.set(value: response.data, key: urlString+id)
                    }
                    currentJourney = json["data"]
                    if isCacheInvalid {
                        completion(json, true)
                    }
                    else {
                        completion(json, false)
                    }
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func getJourneyById(_ id: String, completion: @escaping ((JSON) -> Void)) {
        do {
            var params = ["_id":id]
            if currentUser != nil {
                params = ["user": user.getExistingUser(), "_id":id]
            }else{
                params = ["_id":id]
            }
            let opt = try HTTP.POST(adminUrl + "journey/getoneApp", parameters: params)
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    currentJourney = json["data"]
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func postTravelLife(_ thoughts: String, location: String, locationCategory: String, latitude: String, longitude: String, photosArray: [JSON], videosArray: [JSON], buddies: [JSON], userId: String, journeyId: String, userName: String, city: String, country: String, hashtags: [String], date: String, completion: @escaping ((JSON) -> Void)) {
        
        
        var lat = ""
        var long = ""
        
        if latitude != "0.0" {
            
            lat = latitude
        }
        
        if longitude != "0.0" {
            
            long = longitude
        }
        
        let checkIn: JSON = ["location": location, "category": locationCategory, "city": city, "country": country, "lat": lat, "long": long]
        
        var params: JSON = ["type": "travel-life", "thoughts": thoughts, "checkIn": checkIn, "videos": videosArray, "user": userId, "journey": journeyId, "username": userName, "hashtag": hashtags, "date": date]
        params["photos"] = JSON(photosArray)
        params["buddies"] = JSON(buddies)
        
        print("post params \(params)")
        
        let jsonData = try! params.rawData()
        // create post request
        let url = URL(string: adminUrl + "post/save3")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    print("response: \(JSON(result))")
                    completion(JSON(result))
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            
            task.resume()
    }
    
    
    func postTravelLifeJson(_ params: JSON, completion: @escaping ((JSON) -> Void)) {
        
        do {
            let jsonData = try params.rawData()
            let url = URL(string: adminUrl + "post/save3")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                do {                    
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    print("response: \(JSON(result))")
                    completion(JSON(result))
                } catch {
                    print("Error: \(error)")
                }
            }
            task.resume()
        } catch
        {
            print("error getting xml string: \(error)")
        }
        
    }
    //Local Life JSON
    func postLocalLifeJson(_ params: JSON, completion: @escaping ((JSON) -> Void)) {
        
        do {
            let jsonData = try params.rawData()
            let url = URL(string: adminUrl + "post/saveLocal")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    print("response: \(JSON(result))")
                    completion(JSON(result))
                } catch {
                    print("Error: \(error)")
                }
            }
            task.resume()
        } catch
        {
            print("error getting xml string: \(error)")
        }
        
    }
    
    //  quick itinerery
    
    func deleteItinerary(id:String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            let opt = try HTTP.POST(adminUrl + "itinerary/deleteItinerary", parameters: ["_id":id, "user":user.getExistingUser()])
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.code) && msg : \(err.localizedDescription)")
                }
                else
                {
                                        
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    func postQuickitenary(title:String, year:Int, month:String, duration:Int, description:String, itineraryType:JSON, countryVisited:JSON,photos:[JSON],status:Bool,editId:String,completion: @escaping ((JSON) -> Void)) {
        
        var params: JSON = ["name":title, "year":year, "month":month, "description":description, "duration":duration, "user":currentUser["_id"], "status":status]
        params["photos"] = JSON(photos)
        params["itineraryType"] = itineraryType
        
        var countryVisitedCopy = countryVisited
                
        for i in 0..<countryVisitedCopy.count {
            var countryVisitedItem = (countryVisitedCopy.arrayValue)[i] 
            let countryDict = countryVisitedItem["country"].dictionaryValue 
            if !countryDict.isEmpty {
                countryVisitedItem["country"] = JSON(countryVisitedItem["country"]["_id"].stringValue)
                countryVisitedCopy[i] = countryVisitedItem
            }
        }
        
        params["countryVisited"] = countryVisitedCopy
        
        var url = URL(string: adminUrl + "itinerary/saveQuickItinerary")!
        if(editId != "editId" && editId != "" ) {
            params["_id"] = JSON(editId);
            url = URL(string: adminUrl + "itinerary/editQuickItineraryApp")!
        }

        print(editId);
        let jsonData = try! params.rawData()
        // create post request
       
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
            if error != nil{
                print("Error -> \(error)")
                return
            }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                completion(JSON(result))
                
            } catch {
                print("Error: \(error)")
            }
        }
        
        task.resume()
    }
    
    
    func postQuickitenary1(title:String, year:Int, month:String, duration:Int, description:String, itineraryType:JSON, countryVisited:JSON, completion: @escaping ((JSON) -> Void)) {
        do {
            let parm = ["title":title, "year":year, "month":month, "countryVisited":countryVisited, "description":description, "itineraryType":itineraryType, "duration":duration, "user":currentUser["_id"], "status":false] as [String : Any]
            
            let header = ["Content-Type":"application/json"]
            
            
            let opt = try HTTP.POST(adminUrl + "itinerary/saveQuickItinerary" , parameters: parm, headers:header, requestSerializer: JSONParameterSerializer())
            
            var json = JSON(1);
            opt.start  {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json = JSON(data: response.data)
                    print("saveDurationResponse: \(json)")
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request:: \(error)")
        }
    }
    
    func getPlaceId(_ placeId: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let opt = try HTTP.POST(adminUrl + "post/getGooglePlaceDetail", parameters: ["placeId": placeId])
            var json = JSON(1);
            print("\n getPlaceId params :\(placeId)")
            opt.start {response in
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
    
    func checkActivityCache(_ user: String, completion: @escaping ((JSON) -> Void)) {
        let urlString = adminUrl + "activityfeed/getData"
        var json:JSON = [];
        self.cache.fetch(key: urlString+user).onSuccess { (data) in            
            json = JSON(data: data)
            completion(json)
            }.onFailure { (error) in
                completion(json)
        }
    }
    
    func getActivityFeeds(_ user: String, pageNumber: Int, completion: @escaping ((JSON,[JSON],[JSON],Bool) -> Void)) {
        let urlString = adminUrl + "activityfeed/getData"
        
        var json:JSON = [];
        if(pageNumber == 1) {
            self.cache.fetch(key: urlString+user).onSuccess { data in
                json = JSON(data: data)
                let ll = LocalLifePostModel()
                let qi = QuickItinerary()
                var newJson:[JSON] = [];
                var newQi:[JSON] = [];
                if(pageNumber <= 1) {
                    newJson = ll.getAllJson()
                    newQi = qi.getAll()
                }
                completion(json,newJson,newQi,true)
            }.onFailure { (err) in
                let ll = LocalLifePostModel()
                let qi = QuickItinerary()
                var newJson:[JSON] = [];
                var newQi:[JSON] = [];
                if(pageNumber <= 1) {
                    newJson = ll.getAllJson()
                    newQi = qi.getAll()
                }                
                completion([],newJson,newQi,true)
            }
        }
        
        
        do {
            print("params  \(["user": user, "pagenumber": pageNumber])")
            let opt = try HTTP.POST(adminUrl + "activityfeed/getData", parameters: ["user": user, "pagenumber": pageNumber])
                var json = JSON(1);
                opt.start {response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                    }
                    else
                    {
                        if(pageNumber == 1) {
                            self.cache.set(value: response.data, key: urlString+user)
                        }
                        
                        json  = JSON(data: response.data)
                        
                        let ll = LocalLifePostModel()
                        let qi = QuickItinerary()
                        
                        var newJson:[JSON] = [];
                        var newQi:[JSON] = [];
                        if(pageNumber <= 1) {
                            newJson = ll.getAllJson()
                            newQi = qi.getAll()
                        }
                        
                        completion(json,newJson,newQi,false)
                    }
                }
            } catch let error {
                print("got an error creating the request: \(error)")
            }
        
    }
    
    func getHashData(_ user: String, pageNumber: Int, search: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            print(user)
            print(pageNumber)
            print(search)
            let opt = try HTTP.POST(adminUrl + "post/getHashData", parameters: ["user": user, "pagenumber": pageNumber, "search": search, "limit": 10])
            var json = JSON(1);
            opt.start {response in
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
    
    
    func getMomentJourney(pageNumber: Int, type: String, urlSlug: String?, forTab: String, completion: @escaping ((JSON, String) -> Void)) {
        
                
        do {
            var params: JSON!
            
            if urlSlug != "" {
                params = ["user": user.getExistingUser(), "type": type, "pagenumber": pageNumber, "urlSlug": urlSlug!]
            }else{
                params = ["user": user.getExistingUser(), "type": type, "pagenumber": pageNumber]
            }
            
            print(params)
            let jsonData = try params.rawData()
            
            // create post request
            let url = URL(string: adminUrl + "journey/myLifeJourney")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    completion(JSON(result), forTab)
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            
            task.resume()
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
        
        
        
        
        
        
    }

    func getHomePage(completion: @escaping ((JSON) -> Void)) {
        do {
            let opt = try HTTP.POST(adminUrl + "config/searchPage", parameters: [])
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }

    
    func getMomentLife(_ user: String, pageNumber: Int, type: String, token: String, urlSlug: String?, completion: @escaping ((JSON, String) -> Void)) {
        
        
        do {
            var params: JSON!
            
            if urlSlug != "" {
                if type == "travel-life" {
                    params = ["user": user, "type": type, "pagenumber": pageNumber, "urlSlug": urlSlug!]
                } else if type == "local-life" {
                    params = ["user": user, "token": token, "type": type, "limit": 1, "times": 6, "urlSlug": urlSlug!]
                } else {
                    params = ["user": user, "token": token, "type": type, "limit": 10, "times": 10, "urlSlug": urlSlug!]
                }

            }else{
                if type == "travel-life" {
                    params = ["user": user, "type": type, "pagenumber": pageNumber]
                } else if type == "local-life" {
                    params = ["user": user, "token": token, "type": type, "limit": 1, "times": 6]
                } else {
                    params = ["user": user, "token": token, "type": type, "limit": 10, "times": 10]
                }

            }
            
            let jsonData = try params.rawData()
            
            // create post request
            let url = URL(string: adminUrl + "journey/myLifeMoment")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    completion(JSON(result), type)
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            
            task.resume()
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func getMedia(mediaType:String, user:String, id: String, pageNumber: Int, urlSlug:String?, completion: @escaping ((JSON) -> Void)) {
        
        
        do {
            var params: JSON!
            var api: String
        
            if urlSlug != "" {
                if mediaType == "" {
                    params = ["user":user, "_id": id, "pagenumber": pageNumber, "limit": 20, "urlSlug": urlSlug!]
                    api = "journey/getMedia"
                }else{
                    params = ["user":user, "_id": id, "pagenumber": pageNumber, "limit": 20, "urlSlug": urlSlug!]
                    api = "itinerary/getMedia"
                }

            }else{
            
            if mediaType == "" {
                params = ["user":user, "_id": id, "pagenumber": pageNumber, "limit": 20]
                api = "journey/getMedia"
            }else{
                params = ["user":user, "_id": id, "pagenumber": pageNumber, "limit": 20]
                api = "itinerary/getMedia"
            }
            }
            
            print(params)
            print(api)
            let jsonData = try params.rawData()
            
            // create post request
            let url = URL(string: adminUrl + api)!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    print("response: \(JSON(result))")
                    completion(JSON(result))
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            
            task.resume()
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func getTokenMoment(_ user: String, pageNumber: Int, type: String, token: String, urlSlug: String?, completion: @escaping ((JSON) -> Void)) {
        
        var type2 = type
        do {
            var params: JSON!
            if type2 == "all" {
                type2 = ""
            }
            
            if urlSlug != "" {
                params = ["user": user, "token": token, "type": type2, "limit": 18, "pagenumber": pageNumber, "urlSlug": urlSlug!]
            }else{
                params = ["user": user, "token": token, "type": type2, "limit": 18, "pagenumber": pageNumber]
            }
            
            print(params)
            let jsonData = try params.rawData()
            
            let url = URL(string: adminUrl + "journey/getTokenMoment")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    print("response: \(JSON(result))")
                    completion(JSON(result))
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            
            task.resume()
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }

    func getMyLifeReview(_ user: String, pageNumber: Int, type: String, urlSlug: String?, completion: @escaping ((JSON) -> Void)) {
        
        do {
            var params: JSON!
            if urlSlug != "" {
                params = ["user": user, "type": type, "pagenumber": pageNumber, "urlSlug": urlSlug]
            }else{
                params = ["user": user, "type": type, "pagenumber": pageNumber]
            }
            
            
            print(params)
            let jsonData = try params.rawData()
            
            let url = URL(string: adminUrl + "journey/myLifeReview")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    print("response: \(JSON(result))")
                    completion(JSON(result))
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            
            task.resume()
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }

    func getReviewByLoc(_ user: String, location: String, id: String, urlSlug: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            var params: JSON!
            
            if urlSlug != "" {
                if location == "city" {
                    params = ["user": user, "city": id, "urlSlug": urlSlug]
                }else{
                    params = ["user": user, "country": id, "urlSlug": urlSlug]
                }
            }else{
                if location == "city" {
                    params = ["user": user, "city": id]
                }else{
                    params = ["user": user, "country": id]
                }
            }
            
            print(params)
            let jsonData = try params.rawData()
            
            let url = URL(string: adminUrl + "post/getReviewByLoc")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    print("response: \(JSON(result))")
                    completion(JSON(result))
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            
            task.resume()
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func getReview(_ user: String, country: String, city: String, category: String, pageNumber: Int, urlSlug: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            var params: JSON!
            
            if urlSlug != "" {
                if category != "" {
                    params = ["user": user, "city": city, "category": category, "pagenumber": pageNumber, "urlSlug":urlSlug]
                }else{
                    params = ["user": user, "country": country, "city": city, "pagenumber":pageNumber, "urlSlug":urlSlug]
                }
            }else{
                if category != "" {
                    params = ["user": user, "city": city, "category": category, "pagenumber": pageNumber]
                }else{
                    params = ["user": user, "country": country, "city": city, "pagenumber":pageNumber]
                }
            }
            
            
            print(params)
            let jsonData = try params.rawData()
            
            let url = URL(string: adminUrl + "post/getReviews")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    print("response: \(JSON(result))")
                    completion(JSON(result))
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            
            task.resume()
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }

    
    func getPeopleSearch(_ user: String, search: String, pageNumber: Int, callbackNum:Int, completion: @escaping ((JSON,Int) -> Void)) {
        
        do {
            var params: JSON!
            
            params = ["_id": user, "search": search, "pagenumber": pageNumber, "limit": 10]
            
            let jsonData = try params.rawData()
            
            let url = URL(string: adminUrl + "user/getUser")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    completion(JSON(result),callbackNum)
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            
            task.resume()
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    
    func getHashtagSearch(_ search: String, pageNumber: Int, completion: @escaping ((JSON) -> Void)) {
        
        do {
            var params: JSON!
            params = ["search": search, "pagenumber": pageNumber, "limit": 10]
            
            print(params)
            let jsonData = try params.rawData()
            
            let url = URL(string: adminUrl + "hashtag/getHash")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    completion(JSON(result))
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            
            task.resume()
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }


    
    func getGoogleSearchNearby(_ lat: Double, long: Double, searchText: String, requestId:Int, completion: @escaping ((JSON, Int) -> Void)) {
        
        do {
            
            let params = ["lat": lat, "long": long, "search": searchText] as [String : Any]
            
            let opt = try HTTP.POST(adminUrl + "post/checkinPlaceSearch", parameters: [params])
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    print(json)
                    completion(json, requestId)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func likePost(_ id: String, userId: String, unlike: Bool,postId: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            var params = ["uniqueId": id, "user": userId, "unlike": unlike,"name":"","post":postId] as [String : Any]
            
            if !unlike {
                
                params = ["uniqueId": id, "user": userId,"name":"","post":postId]
            }
            
            let opt = try HTTP.POST(adminUrl + "post/updateLikePost", parameters: [params])
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    print("like post response : \(json)")
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func likePost(_ id: String, userId: String, unlike: Bool, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            var params = ["uniqueId": id, "user": userId, "unlike": unlike,"name":""] as [String : Any]
            
            if !unlike {
                
                params = ["uniqueId": id, "user": userId,"name":""]
            }
            
            print("like post: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "post/updateLikePost", parameters: [params])
            var json = JSON(1);
            opt.start {response in
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
    
    //MARK: -  Global Like
    func globalLike(_ id: String, userId: String, unlike: Bool, type: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            var tap = ""
            var url = ""
            switch type {
            case "detail-itinerary", "quick-itinerary":
                tap = "itinerary"
                url = "itinerary/updateLikeItinerary"
            case "ended-journey", "on-the-go-journey":
                tap = "journey"
                url = "journey/likeJourney"
            case "travel-life", "local-life":
                tap = "post"
                url = "post/updateLikePost"
            case "photos", "Image", "photo":
                tap = "photoId"
                url = "postphotos/updateLikePost"
            case "videos", "Video", "video":
                tap = "videoId"
                url = "postvideos/updateLikePost"
            default:
                tap = "post"
                url = "post/updateLikePost"
            }
            
            var params = [tap: id, "user": userId, "unlike": unlike] as [String : Any]
            
            if !unlike {
                
                params = [tap: id, "user": userId]
            }
            
            print("like post: \(params) \(type)")
            
            let opt = try HTTP.POST(adminUrl + url, parameters: [params])
            var json = JSON(["value" : false])
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    completion(json)
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
    
    func commentOnPost(postId: String, userId: String, commentText: String, hashtags: [String], mentions: [String], completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["post": postId, "user":  userId, "text": commentText, "type": "post", "hashtag" : hashtags, "tagUser": []] as [String : Any]
              
            print("set comment params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "comment/addComment", parameters: [params])
            var json = JSON(1);
            opt.start {response in
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
    
    func commentOn(id: String, userId: String, commentText: String, hashtags: [String], mentions: [String], photoId: String, type: String, videoId: String, journeyId: String, itineraryId: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            var params = ["post": id, "user":  userId, "text": commentText, "type": "photo", "hashtag" : hashtags, "photo": photoId] as [String : Any]
            
            switch type {
            case "post":
                params = ["post": id, "user":  userId, "text": commentText, "type": "post", "hashtag" : hashtags] as [String : Any]
            case "itinerary":
                params = ["itinerary": itineraryId, "user":  userId, "text": commentText, "type": "itinerary", "hashtag" : hashtags] as [String : Any]
            case "journey":
                params = ["journey": journeyId, "user":  userId, "text": commentText, "type": "journey", "hashtag" : hashtags] as [String : Any]
            case "Photo":
                params = ["photo": photoId, "user":  userId, "text": commentText, "type": "photo", "hashtag" : hashtags] as [String : Any]
            case "Video":
                params = ["video": videoId, "user":  userId, "text": commentText, "type": "video", "hashtag" : hashtags] as [String : Any]
            default:
                params = ["post": id, "user":  userId, "text": commentText, "type": "post", "hashtag" : hashtags] as [String : Any]
            }
            
            
            print("set photo comment params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "comment/addComment", parameters: [params])
            var json = JSON(1);
            opt.start {response in
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
    
    func commentOnPhotos(id: String, postId: String, userId: String, commentText: String, hashtags: [String], mentions: [String], photoId: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["uniqueId": id, "post": postId, "user":  userId, "text": commentText, "type": "photo", "hashtag" : hashtags, "photo": photoId] as [String : Any]
            
            print("set photo comment params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "comment/addComment", parameters: [params])
            var json = JSON(1);
            opt.start {response in
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
    
    func commentOnVideos(id: String, postId: String, userId: String, commentText: String, hashtags: [String], mentions: [String], videoId: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["uniqueId": id, "post": postId, "user":  userId, "text": commentText, "type": "video", "hashtag" : hashtags, "video":videoId] as [String : Any]
            
            print("set photo comment params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "comment/addComment", parameters: [params])
            var json = JSON(1);
            opt.start {response in
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
    
    func getComments(_ id: String, type: String, userId: String, pageno: Int, completion: @escaping ((JSON) -> Void)) {
        
        do {
            print("getComments \(["_id": id, "user": userId, "pagenumber": pageno])")
            
            var params = ["_id": id, "user": userId, "pagenumber": pageno] as [String : Any]
            var url = ""
        
            switch type.lowercased() {
            case "post":
                url = "post/getPostComment"
            case "photo":
                url = "postphotos/getPostComment"
            case "video":
                url = "postvideos/getPostComment"
            case "itinerary":
                url = "itinerary/getItineraryComment"
            case "journey":
                url = "journey/getJourneyComment"
            default:
                url = "post/getPostComment"
            }
            
            let opt = try HTTP.POST(adminUrl + url, parameters: params)
            
            var json = JSON(1);
            opt.start {response in
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
    
    func getPhotoComments(_ id: String, userId: String, pageno:Int, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id, "user": userId, "pagenumber": pageno] as [String : Any]
            
            print("comment params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "postphotos/getPostComment", parameters: [params])
            var json = JSON(1);
            opt.start {response in
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
    
    func getVideoComments(_ id: String, userId: String, pageno: Int, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id, "user": userId, "pagenumber": pageno] as [String : Any]
            
            print("comment params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "postvideos/getPostComment", parameters: [params])
            var json = JSON(1);
            opt.start {response in
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

    func getJourneyComments(_ id: String, userId: String, pageno: Int, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id, "user": userId, "pagenumber": pageno] as [String : Any]
            
            print("comment params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "journey/getPostComment", parameters: [params])
            var json = JSON(1);
            opt.start {response in
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

    
    func editPost(_ id: String, location:String, categoryLocation: String, thoughts: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let jsonObject = ["category": categoryLocation, "location": location]
            let params = ["_id": id, "type": "editPost", "checkIn": jsonObject, "thoughts": thoughts] as [String : Any]
            
            print("get one journey params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "post/editData", parameters: [params])
            var json = JSON(1);
            opt.start {response in
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
    
    func getOneJourneyPost(id: String, completion: @escaping ((JSON) -> Void)) {
        
        do {

            let params = ["_id": id]

            print("get one journey params: \(params)")

            let opt = try! HTTP.POST(adminUrl + "post/getOne", parameters: params)
            var json = JSON(1)
            
            opt.start{(response) in

                if let err = response.error {

                    print("error: \(err.localizedDescription)")
                }

                else
                {
                    print("making json")
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func getOnePostPhotos(_ id: String, _ userId: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id, "user": userId]            
            
            let opt = try! HTTP.POST(adminUrl + "postphotos/getOne", parameters: params)
            var json = JSON(1)
            
            opt.start{(response) in
                
                if let err = response.error {
                    
                    print("error: \(err.localizedDescription)")
                }
                    
                else
                {
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func getOnePostVideos(_ id: String, _ userId: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id, "user": userId]            
            
            let opt = try! HTTP.POST(adminUrl + "postvideos/getOne", parameters: params)
            var json = JSON(1)
            
            opt.start{(response) in
                
                if let err = response.error {
                    
                    print("error: \(err.localizedDescription)")
                }
                    
                else
                {
                    print("making json")
                    json  = JSON(data: response.data)
                    print(json)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func postPhotosLike(_ photoId: String, postId: String, userId: String, userName: String, unlike: Bool, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            var params = ["photoId": photoId, "postId": postId, "user": userId, "name": userName] as [String : Any]
            
            if unlike {
                params = ["photoId": photoId, "postId": postId, "user": userId, "name": userName, "unlike": unlike] as [String : Any]
            }
            
            let opt = try HTTP.POST(adminUrl + "postphotos/updateLikePost", parameters: params)
            var json = JSON(1)
            
            opt.start{(response) in
                
                if let err = response.error {
                    
                    print("error: \(err.localizedDescription)")
                }
                    
                else
                {
                    print("making json")
                    json  = JSON(data: response.data)
                    print(json)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    
    func postVideoLike(_ photoId: String, postId: String, userId: String, userName: String, unlike: Bool, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            var params = ["videoId": photoId, "postId": postId, "user": userId, "name": userName] as [String : Any]
            
            if unlike {
                params = ["videoId": photoId, "postId": postId, "user": userId, "name": userName, "unlike": unlike] as [String : Any]
            }           
            
            let opt = try HTTP.POST(adminUrl + "postvideos/updateLikePost", parameters: params)
            var json = JSON(1)
            
            opt.start{(response) in
                
                if let err = response.error {
                    
                    print("error: \(err.localizedDescription)")
                }
                    
                else
                {
                    print("making json")
                    json  = JSON(data: response.data)
                    print(json)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func deletePost(_ id: String, uniqueId: String, user: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id, "type": "deletePost", "user": currentUser["_id"].stringValue, "uniqueId": uniqueId]
            let opt = try HTTP.POST(adminUrl + "post/editData", parameters: params)
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func changeDateTime(_ id: String, postID: String, date: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["uniqueId": id, "post": postID,  "date": date, "type": "changeDateTime", "user": currentUser["_id"].stringValue]
            
            print("change date time params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "post/editData", parameters: [params])
            var json = JSON(1);
            opt.start {response in
                print(response);
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
    func changeDateTimeLocal(_ id: String, date: String, completion: @escaping ((JSON) -> Void)) {
        loader.hideOverlayView()
        do {
            
            let params = ["_id": id, "date": date, "type": "changeDateTime", "user": currentUser["_id"].stringValue]
            
            print("change date time params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "post/editLocal", parameters: [params])
            var json = JSON(1);
            opt.start {response in
                print(response);
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func changeDateTimeJourney(_ id: String, date: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id, "startTime": date]
            
            print("change date time params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "journey/editData", parameters: [params])
            var json = JSON(1);
            opt.start {response in
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
    func kindOfJourney(_ id: String, kindOfJourney: [String], completion: @escaping ((JSON) -> Void)) {
        
        do {
            print(kindOfJourney)
            let params = ["_id":id,"kindOfJourney":kindOfJourney] as [String : Any]
            
            print("change date time params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "journey/editData", parameters: [params])
            var json = JSON(1);
            opt.start {response in
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
    
    func endJourney(_ journeyId: String, uniqueId: String, user: String, userName: String, buddies: [JSON], photo: String, journeyName: String, notificationID: String?, completion: @escaping ((JSON) -> Void)) {
        
        do {
            var params: JSON
            
            if notificationID == nil {
                params = ["_id": journeyId, "user": user, "uniqueId": uniqueId, "name": userName, "coverPhoto": photo, "journeyName": journeyName]
            }
            else {
                
                params = ["_id": journeyId, "user": user, "uniqueId": uniqueId, "name": userName, "coverPhoto": photo, "journeyName": journeyName, "notifyId": notificationID!]
            }
            
            params["buddies"] = JSON(buddies)
            
            let jsonData = try params.rawData()
            
            // create post request
            let url = URL(string: adminUrl + "journey/endJourney")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    print("response: \(JSON(result))")
                    completion(JSON(result))
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            
            task.resume()
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    func getJourneyPhotos(journeyId: String, userId: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": journeyId, "user": userId]
            let opt = try HTTP.POST(adminUrl + "journey/getPhotos", parameters: params)
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    print("journey photos: \(json)")
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    func getNearMeList(lat: String, long: String, type: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["lat": lat, "long": long, "type": type]
            print("near me params: \(params)")
            let opt = try HTTP.POST(adminUrl + "post/getNearMe", parameters: params)
            var json = JSON(1);
            opt.start {response in
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
    
    func getNearMeDetail(placeId: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["placeId": placeId]
            let opt = try HTTP.POST(adminUrl + "post/getNearMePlaceDetail", parameters: params)
            var json = JSON(1);
            opt.start {response in
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
    
    func rateCheckIn(_ userId: String, postId: String, rating: String, review: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["post" : postId, "user" : userId, "rating" : rating, "review" : review]
            let opt = try HTTP.POST(adminUrl + "review/save", parameters: params)
            var json = JSON(1);
            opt.start {response in
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
    
    func rateActivity(_ userId: String, itinerary: String, journey: String, rating: String, review: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            var params = ["user" : userId, "rating" : rating, "review" : review]
            if itinerary == "" {
                
                params = ["journey" : journey, "user" : userId, "rating" : rating, "review" : review]

            }else{
                
                params = ["itinerary" : itinerary, "user" : userId, "rating" : rating, "review" : review]

            }
            print(params)
            let opt = try HTTP.POST(adminUrl + "review/userReview", parameters: params)
            var json = JSON(1);
            opt.start {response in
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
    
    func rateCountry(_ userId: String, journeyId: String, countryId: String, rating: String, review: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["journey" : journeyId, "country": countryId, "user" : userId, "rating" : rating, "review" : review]
            let opt = try HTTP.POST(adminUrl + "review/save", parameters: params)
            var json = JSON(1);
            opt.start {response in
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
    
    func infoCount(_ journeyId: String, city: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id" : journeyId, "city" : city]
            print(params)
            let opt = try HTTP.POST(adminUrl + "journey/getOnGoingCount", parameters: params)
            var json = JSON(1);
            opt.start {response in
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
    
    func journeyTypeData(_ journeyId: String, type: String, userId: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id" : journeyId, "type" : type, "user": userId]            
            let opt = try HTTP.POST(adminUrl + "journey/getCountData", parameters: params)
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    func cityTypeData(_ type: String, city: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["type" : type, "city": city]
            print("journey type data: \(params)")
            let opt = try HTTP.POST(adminUrl + "journey/getCountData", parameters: params)
            var json = JSON(1);
            opt.start {response in
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
    
    func getTripSummaryCount(_ type: String, journeyId: String, userId: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["type" : type, "_id": journeyId, "user": userId]
            let opt = try HTTP.POST(adminUrl + "journey/getCountData", parameters: params)
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    func getHashtags(hashtag: String, requestId: Int, completion: @escaping ((JSON, Int) -> Void)) {
        
        do {
            let params = ["hashtag": hashtag]
            let opt = try HTTP.POST(adminUrl + "hashtag/findHash", parameters: params)
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    completion(json, requestId)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    func getMentions(userId: String, searchText: String, requestId: Int, completion: @escaping ((JSON,Int) -> Void)) {
        
        do {
            let params = ["search": searchText, "_id": userId, "fromTag": true] as [String: Any]
            print(params)
            let opt = try HTTP.POST(adminUrl + "user/searchBuddy", parameters: params)
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    completion(json, requestId)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    func deleteComment(commentId: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            let params = ["_id": commentId, "type": "post"] as [String: Any]
//            let editComment = ["_id", "text", "user", "name"]
            
            
            let opt = try HTTP.POST(adminUrl + "comment/deletePostComment", parameters: params)
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    print("delete comment response: \(json)")
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    func editComment(type: String, commentId: String, commentText: String, userId:  String, hashtag: [String], addedHashtags: [String], removedHashtags: [String], photoId:String, completion: @escaping ((JSON) -> Void)) {
        print("my type")
        print(type)
        
        
        do {
            var params = ["type":type.lowercased(), "_id": commentId, "text": commentText, "user": userId, "hashtag": hashtag, "addHashtag": addedHashtags, "removeHashtag": removedHashtags] as [String: Any]
            
            
            print(params)
//            if type == "Photo" {
//                params = ["type":"photo", "_id": commentId, "text": commentText, "user": userId, "hashtag": hashtag, "addHashtag": addedHashtags, "removeHashtag": removedHashtags, "photo": photoId] as [String: Any]
//            } else {
//                params = ["type":"video", "_id": commentId, "text": commentText, "user": userId, "hashtag": hashtag, "addHashtag": addedHashtags, "removeHashtag": removedHashtags, "video": photoId] as [String: Any]
//            }
            
            let opt = try HTTP.POST(adminUrl + "comment/editComment", parameters: params)
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    print("edit comment response: \(json)")
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }


    
    
    
    func getAllCityC(_ search: String, country: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            let params = ["search":search,"country":country]
            print(params)
            let opt = try HTTP.POST(adminUrl + "city/searchCity", parameters: params)
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    
    func getCityCountry(_ search: String, id: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let opt = try HTTP.POST(adminUrl + "city/searchCity", parameters: ["user": id])
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    func checkLocalLife(lat:String,lng:String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let opt = try HTTP.POST(adminUrl + "user/getLocation", parameters: ["user": currentUser["_id"].stringValue,"lat":lat,"long":lng])
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    func getLocalLife(lat:String,lng:String,page:Int,category:String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let opt = try HTTP.POST(adminUrl + "post/getLocalPost", parameters: ["user": user.getExistingUser(), "lat":lat,"long":lng,"pagenumber":page,"category":category])
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    
//    func postAddPhotosVideos (param:JSON, completion: @escaping ((JSON) -> Void) ) {
    func editPost(param:JSON, completion: @escaping ((JSON) -> Void) ) {
        do {
            let jsonData = try param.rawData()
            // create post request
            let url = URL(string: adminUrl + "post/editData")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    print("response: \(JSON(result))")
                    completion(JSON(result))
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            task.resume()
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    func changeDateFormat(_ givenFormat: String, getFormat: String, date: String, isDate: Bool) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = givenFormat
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = getFormat
        
        if isDate {
            
            dateFormatter.dateStyle = .medium
            
        }
        var goodDate = "";
        if(date != nil) {
            goodDate = dateFormatter.string(from: date!)
        }
        return goodDate
    }
    
    
    func getLocalPost(lat:String,lng:String,pageNo:Int,category:String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            print("category")
            print(category)
            print("My user")
            print(currentUser["_id"])
            print(category)
            let opt = try HTTP.POST(adminUrl + "post/getLocalPost", parameters: ["user": currentUser["_id"].stringValue,"lat":lat,"long":lng,"pagenumber":pageNo,"category":category])
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                } else {
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    
    
    func journeyChangeName(_ name: String,journeyId: String, completion: @escaping ((JSON) -> Void)) {
        
        var json = JSON(1);
        let params = ["user":currentUser["_id"].stringValue, "_id":journeyId,"name":name]
        do {
            let opt = try HTTP.POST(adminUrl + "journey/editData", parameters: params)
            
            opt.start { response in
                print("started response: \(response)")
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    func journeyChangeEndTime(_ date: String,journeyId: String, completion: @escaping ((JSON) -> Void)) {
        loader.hideOverlayView()
        var json = JSON(1);
        let params = ["user":currentUser["_id"].stringValue, "_id":journeyId,"endTime":date]
        do {
            let opt = try HTTP.POST(adminUrl + "journey/editData", parameters: params)
            
            opt.start { response in
                print("started response: \(response)")
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    
    
    func journeyChangeCoverImage(_ photo: String,journeyId: String, completion: @escaping ((JSON) -> Void)) {
        
        var json = JSON(1);
        let params = ["user":currentUser["_id"].stringValue, "_id":journeyId,"coverPhoto":photo]
        do {
            let opt = try HTTP.POST(adminUrl + "journey/editData", parameters: params)
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
//    itinerary/getOneApp
    func getItinerary (_ id: String, completion: @escaping ((JSON) -> Void)) {
        var json = JSON(1);
        let params = ["user":user.getExistingUser(), "_id":id]
        print(params)
        do {
            let opt = try HTTP.POST(adminUrl + "itinerary/getOneApp", parameters: params)
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    print("\n\n Itinerary : \(json) \n\n")
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }

//    func searchPeople(_ id: String, searchText: String, completion: @escaping ((JSON) -> Void)) {
//        var json = JSON(1);
//        let params = ["_id": id, "search": searchText, "limit":10] as [String : Any]
//        do {
//            let opt = try HTTP.POST(adminUrl + )
//        }
//    }
    
    
    //MARK: - Notifications
    
    func checkNotificationCache(_ user: String, completion: @escaping ((JSON) -> Void)) {
        let urlString = adminUrl + "notification/getNotification"
        var json:JSON = [];
        self.cache.fetch(key: urlString+user).onSuccess { (data) in            
            json = JSON(data: data)
            completion(json)
        }.onFailure { (error) in
            completion(json)
        }
    }    
    
    func getNotify(_ id: String, pageNumber: Int, completion: @escaping ((JSON) -> Void)) {
        let urlString = adminUrl + "notification/getNotification"
        
        if(pageNumber == 1) {
            self.cache.fetch(key: urlString+id).onSuccess { data in
                let json = JSON(data: data)
                completion(json)
            }
        }
        
        do {
            let opt = try HTTP.POST(urlString, parameters: ["user": id,"pagenumber":pageNumber])
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.code) && msg : \(err.localizedDescription)")                    
                }
                else
                {
                    
                    if(pageNumber == 1) {
                        self.cache.set(value: response.data, key: urlString+id)
                    }
                    
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    
    //MARK: - Unread Notification's Count
    
    func getUnreadNotificationCount(_ id: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            let opt = try HTTP.POST(adminUrl + "notification/getUnread", parameters: ["user": id])
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")

        }
    }
    
    
    //MARK: - Notification's OnClick Requests
    
    func acceptJourney(_ id: String, uniqueId: String, notificationId: String, inMiddle: Bool, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let opt = try HTTP.POST(adminUrl + "journey/buddyAccept", parameters: ["user": id,"uniqueId":uniqueId,"_id":notificationId,"inMiddle":inMiddle])
            var json = JSON(1);
            opt.start {response in
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
    
    
    func declinedJourney(_ id: String, uniqueId: String, notificationId: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let opt = try HTTP.POST(adminUrl + "journey/buddyReject", parameters: ["user": id,"uniqueId":uniqueId,"_id":notificationId])
            var json = JSON(1);
            opt.start {response in
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
    
    
    func updateNotificationStatus(notificationId: String, answeredStatus: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let opt = try HTTP.POST(adminUrl + "notification/updateNotification", parameters: ["_id": notificationId,"answeredStatus":answeredStatus])
            var json = JSON(1);
            opt.start {response in
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
    
    func respondToItineraryRequest(notificationId: String, itineraryID: String, answeredStatus: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let opt = try HTTP.POST(adminUrl + "itinerary/itineraryStatus", parameters: ["user":user.getExistingUser(), "_id": itineraryID, "notifyId":notificationId, "answeredStatus":answeredStatus])
            var json = JSON(1);
            opt.start {response in
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
    
    func respondToFollowRequest(token: String, answeredStatus: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            let opt = try HTTP.POST(adminUrl + "user/acceptFollower", parameters: ["user":user.getExistingUser(), "token": token, "answeredStatus":answeredStatus])
            var json = JSON(1);
            opt.start {response in
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
    
    
    //MARK: - Notification Redirection
    
    func getNotificationDetailedPost(userID: String, postID: String, notificationType: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            var url = ""
            
            if notificationType == "journeyLike" || notificationType == "journeyComment" || notificationType == "journeyMentionComment" {
                url = "journey/getSingleJourney"
            }
            else if notificationType == "itineraryLike" || notificationType == "itineraryComment" || notificationType == "itineraryMentionComment" {
                url = "itinerary/getSingleItinerary"
            }
            else if notificationType == "postLike" || notificationType == "postComment" || notificationType == "postMentionComment" || notificationType == "postFirstTime" || notificationType == "postTag" {
                url = "post/getSinglePost"
            }
            
            print("\n URL : \(url)")
            
            
            let opt = try HTTP.POST(adminUrl + url, parameters: ["user":userID, "_id": postID])
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    print("\n\n DetailPostResponse : \(json)")
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    //MARK: - Fetch popular items
    
    func getPopularJourney(userId: String, pagenumber: Int, completion: @escaping ((JSON) -> Void)) {
        
        do {
            var params: JSON
            
            if userId == "" {
                params = ["pagenumber": pagenumber]
            }else{
                params = ["user": userId, "pagenumber": pagenumber]
            }
            
            let jsonData = try params.rawData()
            
            // create post request
            let url = URL(string: adminUrl + "journey/getPopularJourney")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    print("response: \(JSON(result))")
                    completion(JSON(result))
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            
            task.resume()
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    
    }
    
    func getPopularItinerary(userId: String, pagenumber: Int, completion: @escaping ((JSON) -> Void)) {
        
        do {
            var params: JSON
            
            if userId == nil {
                params = ["pagenumber": pagenumber]
            }else{
                params = ["user": userId, "pagenumber": pagenumber]
            }
            
            let jsonData = try params.rawData()
            
            // create post request
            let url = URL(string: adminUrl + "itinerary/getPopularItinerary")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    completion(JSON(result))
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            
            task.resume()
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    func getJourneyLikes(userId: String, id: String, pagenumber: Int, completion: @escaping ((JSON) -> Void)) {
        
        do {
            var params: JSON
            
            
            params = ["user": userId, "_id": id, "pagenumber": pagenumber]
            print(params)
            let jsonData = try params.rawData()
            
            // create post request
            let url = URL(string: adminUrl + "journey/getJourneyLikes")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    print("response: \(JSON(result))")
                    completion(JSON(result))
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            
            task.resume()
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }

    func getItineraryLikes(userId: String, id: String, pagenumber: Int, completion: @escaping ((JSON) -> Void)) {
        
        do {
            var params: JSON
            
            
            params = ["user": userId, "_id": id, "pagenumber": pagenumber]
            print(params)
            let jsonData = try params.rawData()
            
            // create post request
            let url = URL(string: adminUrl + "itinerary/getItineraryLikes")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    print("response: \(JSON(result))")
                    completion(JSON(result))
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            
            task.resume()
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }

    func getPhotoLikes(userId: String, id: String, pagenumber: Int, completion: @escaping ((JSON) -> Void)) {
        
        do {
            var params: JSON
            
            
            params = ["user": userId, "_id": id, "pagenumber": pagenumber]
            print(params)
            let jsonData = try params.rawData()
            
            // create post request
            let url = URL(string: adminUrl + "postphotos/getPostLikes")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    print("response: \(JSON(result))")
                    completion(JSON(result))
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            
            task.resume()
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }

    func getVideoLikes(userId: String, id: String, pagenumber: Int, completion: @escaping ((JSON) -> Void)) {
        
        do {
            var params: JSON
            
            
            params = ["user": userId, "_id": id, "pagenumber": pagenumber]
            print(params)
            let jsonData = try params.rawData()
            
            // create post request
            let url = URL(string: adminUrl + "postvideos/getPostLikes")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    print("response: \(JSON(result))")
                    completion(JSON(result))
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            
            task.resume()
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }

    
    func getLikes(userId: String, post: String, pagenumber: Int, completion: @escaping ((JSON) -> Void)) {
        
        do {
            var params: JSON
            
            
                params = ["user": userId, "_id": post, "pagenumber": pagenumber]
            print(params)
            let jsonData = try params.rawData()
            
            // create post request
            let url = URL(string: adminUrl + "post/getPostLikes")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    print("response: \(JSON(result))")
                    completion(JSON(result))
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            
            task.resume()
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    func getPopularUsers(pagenumber: Int, completion: @escaping ((JSON) -> Void)) {
        
        do {
            var params: JSON
            
            if currentUser != nil {
                params = ["user":user.getExistingUser(), "pagenumber": pagenumber]
            }
            else {
                params = ["pagenumber": pagenumber]
            }
            
            let jsonData = try params.rawData()
            
            // create post request
            let url = URL(string: adminUrl + "user/getPopularUser")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    completion(JSON(result))
                    
                } catch {
                    print("Error: \(error)")
                }
            }
            
            task.resume()
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    
    //MARK: - Existing User Login API's
    
    func loginUser(email: String, password: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            let opt = try HTTP.POST(adminUrl + "user/loginApp", parameters: ["email": email,"password":password])
            var json = JSON(1);
            opt.start {response in
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
    
    func changeLogin(id: String, email: String, facebookID: String?, googleID: String?, completion: @escaping ((JSON) -> Void)) {
        
        OneSignal.idsAvailable {(_ userId, _ pushToken) in
            let deviceId = userId
            
            do {
                var params: JSON = []
                
                if facebookID != nil {
                    params = ["_id":id, "facebookID": facebookID!, "deviceId":deviceId!, "email": email]
                }
                else if googleID != nil {
                    params = ["_id":id, "googleID": googleID!, "deviceId":deviceId!, "email": email]
                }
                
                let jsonData = try params.rawData()
                
                // create post request
                let url = URL(string: adminUrl + "user/changeLoginApp")!
                let request = NSMutableURLRequest(url: url)
                request.httpMethod = "POST"
                
                // insert json data to the request
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
                
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                    if error != nil{
                        print("Error -> \(error)")
                        return
                    }
                    
                    do {
                        let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                        print("\n changeLogin response : \(result)")
                        completion(JSON(result))                    
                    } catch {
                        print("Error: \(error)")
                    }
                }
                
                task.resume()
                
            } catch let error {
                print("got an error creating the request: \(error)")
            }
            
        }
        
        
    }
    
    func forgotPassword(email: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            let opt = try HTTP.POST(adminUrl + "user/forgotPassword", parameters: ["email": email])
            var json = JSON(1);
            opt.start {response in
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
    
    //MARK: - Logout
    
    func logout(id: String, completion: @escaping ((JSON) -> Void)) {
        OneSignal.idsAvailable({(_ userId, _ pushToken) in
            let deviceParams = userId! as String
            do {
                let opt = try HTTP.POST(adminUrl + "user/logoutApp", parameters: ["_id": user.getExistingUser(), "deviceId": deviceParams])
                var json = JSON(1);
                
                opt.start {response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                    }
                    else
                    {
                        user.dropTable()
                        currentUser = nil
                        existingUserGlobal = ""
                        self.cache.removeAll()
                        json  = JSON(data: response.data)
                        print(json)
                        completion(json)
                    }
                }
            } catch let error {
                print("got an error creating the request: \(error)")
            }
            
            })
    }
    
}

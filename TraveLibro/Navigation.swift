import UIKit

import SwiftHTTP
//import Alamofire

let apiUrl = "http://104.155.207.185:92/api/"
var adminUrl = "http://192.168.2.8:1337/api/"
let tempUrl = "http://10.0.0.6:1337/api/demo/demo"

class Navigation {
    
//    var json: JSON!
    
    func saveUser(_ firstName: String, lastName: String, email: String, mobile: String, fbId: String, googleId: String, twitterId: String, instaId: String, nationality: String, profilePicture: String, gender: String, dob: String, completion: @escaping ((JSON) -> Void)) {
        
        print("name: \(firstName), \(lastName)")
        
        var json = JSON(1);
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        
        let deviceParams = ["_id": deviceId, "os": "iOS"]
        
        print("device id: \(deviceId)")
        let params = ["firstName":firstName, "lastName":lastName, "email": email, "mobile": mobile, "facebookID": fbId, "googleID": googleId, "twitterID": twitterId, "instagramID": instaId, "nationality": nationality, "profilePicture": profilePicture, "gender": gender, "deviceId": deviceParams, "dob": dob] as [String : Any]
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
    
    func editUser(_ id: String, editField: String, editFieldValue: String, completion: @escaping ((JSON) -> Void)) {
        
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
    
    func getUser(_ id: String, completion: @escaping ((JSON) -> Void)) {
        
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
    
    func addNewOTG(_ name: String, userId: String, startLocation: String, kindOfJourney: [String], timestamp: String, lp: String, completion: @escaping ((JSON) -> Void)) {
        
        let currentDate = Date()
        let currentDateFormatter = DateFormatter()
        currentDateFormatter.timeZone = TimeZone.autoupdatingCurrent
        currentDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let showDate = currentDateFormatter.date(from: "\(currentDate)")!
        let showDateArray = "\(showDate)".components(separatedBy: " +")
//        print("current date 2: \(currentDate) \(showDateArray[0])")
        
        let params = ["name": name, "user":  userId, "startLocation": startLocation, "kindOfJourney": kindOfJourney, "timestamp": timestamp, "startLocationPic": lp, "startTime": "\(showDateArray[0])"] as [String : Any]
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
    
    func addBuddiesOTG(_ friends: JSON, userId: String, userName: String, journeyId: String, inMiddle: Bool, journeyName: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            var params: JSON = ["uniqueId": journeyId, "inMiddle": inMiddle, "name": userName, "user": userId, "journeyName": journeyName]
            params["buddies"] = friends
            
            print("add buddies params: \(params)")
            
            let jsonData = try! params.rawData()
            
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
    
    func uploadPhotos(_ file: URL, localDbId: Int64?, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            var id = ""
            
            if localDbId != nil {
                
                id = "\(localDbId!)"
            }
            
            print("inside upload files: \(id)")
            
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
    
    func getImageBytes(_ file: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
//            let params = ["file": file]
            print("file to be read: \(file)")
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
    
    func removeBucketList(_ id: String, country: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id, "bucketList": country, "delete": true] as [String : Any]
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
    
//    func getBucketList(id: String, completion: @escaping ((JSON) -> Void)) {
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
            //            params["_id"].stringValue = id
            //            params["countryId"].stringValue = countryVisited
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
                
                
//                let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
//                    if error != nil{
//                        print("Error -> \(error)")
//                        return
//                    }
//                    
//                    do {
//                        let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
//                        print("Result: \(result)")
//                        completion(JSON(result))
//                        
//                    } catch {
//                        print("Error: \(error)")
//                    }
//                })
//                
//                task.resume()
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
    
    func removeCountriesVisited(_ id: String, countryId: String, year: Int, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id, "countryId": countryId, "year": year] as [String : Any]
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
    
    func followUser(_ userId: String, followUserId: String, completion: @escaping ((JSON) -> Void)) {
        
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
    
    func getFollowers(_ userId: String, completion: @escaping ((JSON) -> Void)) {
        
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
    
    func unfollow(_ userId: String, unFollowId: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": unFollowId, "user": userId]
            print("params: \(params)")
            
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
                    print(json)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func getFollowing(_ userId: String, searchText: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": userId, "search": searchText]
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
                    print(json)
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func getJourneyCoverPic(_ places: [String], completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            print("places: \(places)")
            
            let opt = try HTTP.GET(adminUrl + "upload/getGooglePic", parameters: ["placeId": "\(places)"])
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
    
    func getJourney(_ id: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let opt = try HTTP.POST(adminUrl + "journey/getOnGoing", parameters: ["user": id])
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
    
    func postTravelLife(_ thoughts: String, location: String, locationCategory: String, photosArray: [JSON], videosArray: [String], buddies: [JSON], userId: String, journeyId: String, userName: String, city: String, country: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
        
            let checkIn = ["location": location, "category": locationCategory, "city": city, "country": country]
            
            var params: JSON = ["type": "travel-life", "thoughts": thoughts, "checkIn": checkIn, "videos": videosArray, "user": userId, "journey": journeyId, "username": userName]
            params["photos"] = JSON(photosArray)
            params["buddies"] = JSON(buddies)
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
            
            let opt = try HTTP.POST(adminUrl + "post/save3", parameters: [params])
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
    
    func getNotify(_ id: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let opt = try HTTP.POST(adminUrl + "notification/getNotification", parameters: ["user": id])
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
    
    func acceptJourney(_ journeyId: String, id: String, isInMiddle: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let opt = try HTTP.POST(adminUrl + "journey/buddyAccept", parameters: ["user": id, "uniqueId": journeyId, "inMiddle": isInMiddle])
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
    
    func getPlaceId(_ placeId: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let opt = try HTTP.POST(adminUrl + "post/getGooglePlaceDetail", parameters: ["placeId": placeId])
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
    
    func getGoogleSearchNearby(_ lat: Double, long: Double, searchText: String, completion: @escaping ((JSON) -> Void)) {
        
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
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func likePost(_ id: String, userId: String, userName: String, unlike: Bool, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            var params = ["uniqueId": id, "user": userId, "unlike": unlike] as [String : Any]
            
            if !unlike {
                
                params = ["uniqueId": id, "user": userId, "name": userName]
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
    
    func commentOnPost(_ id: String, userId: String, commentText: String, userName: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["uniqueId": id, "comment" : ["user":  userId, "text": commentText, "name": userName]] as [String : Any]
              
            print("set comment params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "post/addComment", parameters: [params])
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
    
    func getComments(_ id: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id]
            
            print("comment params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "post/getPostComment", parameters: [params])
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
    
    func getOneJourneyPost(_ id: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id]
            
            print("get one journey params: \(params)")
            
            let opt = try HTTP.POST(adminUrl + "post/getOne", parameters: [params])
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
    
    func deletePost(_ id: String, uniqueId: String, user: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id": id, "type": "deletePost", "user": user, "uniqueId": uniqueId]
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
    
    func changeDateTime(_ id: String, date: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["uniqueId": id, "date": date, "type": "changeDateTime"]
            
            print("change date time params: \(params)")
            
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
    
    func endJourney(_ journeyId: String, uniqueId: String, user: String, userName: String, buddies: [JSON], photo: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            var params: JSON = ["_id": journeyId, "user": user, "uniqueId": uniqueId, "name": userName, "coverPhoto": photo]
            params["buddies"] = JSON(buddies)
            
            let jsonData = try! params.rawData()
            
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
    
    func getJourneyPhotos(_ user: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["user": user]
            let opt = try HTTP.POST(adminUrl + "journey/getPhotos", parameters: params)
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
    
    func infoCount(_ journeyId: String, city: String, completion: @escaping ((JSON) -> Void)) {
        
        do {
            
            let params = ["_id" : journeyId, "city" : city]
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
//            print("journey type data: \(params)")
            let opt = try HTTP.POST(adminUrl + "journey/getCountData", parameters: params)
            var json = JSON(1);
            opt.start {response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                }
                else
                {
                    json  = JSON(data: response.data)
                    print("trip summary response: \(json)")
                    completion(json)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
}

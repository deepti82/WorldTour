//
//  NewRest.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 04/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import Foundation
//import Alamofire

//
//let adminUrl2 = "http://testcorp.medimanage.com/api/v1/"
//
//class SignUpTwo {
//    
//    //    var json: JSON!
//    let headers = [
//        "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
//        "Accept": "application/json",
//        "withCredentials": "true"
//    ]
//    
//    func signUpUser(firstName: String, lastName: String, username: String, password: String, completion:
//        ((JSON) -> Void)) {
//        
//        print("name: \(firstName), \(lastName)")
//        print("\n username: \(username)")
//        print("\n password: \(password)")
//        
//        var json = JSON(1);
//        let params = ["firstName":firstName, "lastName":lastName, "email": username, "password": password]
//        print(params)
//        
////        do {
////            let opt = try HTTP.POST(adminUrl + "tempUser/getAll", parameters: nil)
////            //            print("request: \(opt)")
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
////            }
////        } catch let error {
////            print("got an error creating the request: \(error)")
////        }
//        
//        Alamofire.request(.GET, adminUrl + "tempUser/getAll", headers: headers)
//            .validate()
//            .response { request, response, data, error in
//                print(request)
//                print(response)
//                print(data)
//                print(error)
//        }
//        
//    }
//    
//    func signUpSocial(id: String, completion:((JSON) -> Void)) {
//        
//        
//        
//        
//    }
//    
//}

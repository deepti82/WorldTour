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

let adminUrl = "http://192.168.0.101:1337/"
//let apiURL = "";

class Navigation {
    
//    var json: JSON!
    
    func signUpUser(firstName: String, lastName: String, username: String, password: String, completion:
        ((JSON) -> Void)) {
        
        print("name: \(firstName), \(lastName)")
        print("\n username: \(username)")
        print("\n password: \(password)")
        
        var json = JSON(1);
        let params = ["firstName":firstName, "lastName":lastName, "email": username, "password": password]
        print(params)
        
        do {
            let opt = try HTTP.POST(adminUrl + "tempUser/register", parameters: params)
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
        
        
        
        
    }

}

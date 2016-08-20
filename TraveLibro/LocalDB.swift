//
//  LocalDB.swift
//  
//
//  Created by Midhet Sulemani on 01/07/16.
//
//

import UIKit
import SwiftHTTP
import SwiftyJSON
import SQLite

public class Profile {
    
    public let db = AppDelegate.getDatabase()
    
    public let id = Expression<Int64>("id")
    public let name = Expression<String?>("name")
    public let journeys = Expression<String?>("journeys")
    public let followingCount = Expression<String?>("following")
    public let followersCount = Expression<String?>("followers")
    public let userBadgeImage = Expression<String?>("userBadgeImage")
    public let countriesVisitedCount = Expression<String?>("countriesVisitedCount")
    public let travelConfig = Expression<String?>("travelConfig")
    public let dob = Expression<String?>("dob")
    public let profilePicture = Expression<String?>("dp")
    public let homeCountry = Expression<String?>("homeCountry")
    public let homeCity = Expression<String?>("homeCity")
    public let nationality = Expression<String?>("nationality")
    public let email = Expression<String?>("email")
    public let lastName = Expression<String?>("lastName")
    public let firstName = Expression<String?>("firstName")
    public let isLoggedIn = Expression<Bool!>("isLoggedIn")
    
//    init() {
//        
//        try! db.run(profile.create(ifNotExists: true) { t in
//            t.column(id, primaryKey: .Autoincrement)
//            t.column(userId, unique: true)
//            t.column(firstName)
//            t.column(lastName)
//            t.column(dp)
//            t.column(email, unique: true)
//            t.column(dob)
//            t.column(nationality)
//            t.column(homeTown)
//            t.column(gender)
//            t.column(signedInType)
//        })
    
//        try! db.run(post.create(ifNotExists: true) { t in
//            t.column(id, primaryKey: .Autoincrement)
//            t.column(userId, unique: true)
//            t.column(firstName)
//            t.column(lastName)
//            t.column(dp)
//            t.column(email, unique: true)
//            t.column(dob)
//            t.column(nationality)
//            t.column(homeTown)
//            t.column(gender)
//            t.column(signedInType)
//        })
        
//    }
    
//    func setUser(userId: String, firstName: String, lastName: String, dp: String, email: String, dob: String, nationality: String, homeTown: String, gender: String, signedInType: String) -> Void {
//        
//        do {
//            let rowid = try db.run(profile.insert(userId <- userId,  firstName <- firstName, lastName <- lastName, dp <- dp, email <- email, dob <- dob, nationality <- nationality, homeTown <- homeTown, gender <- gender, signedInType <- signedInType))
//            print("inserted id: \(rowid)")
//        } catch {
//            print("insertion failed: \(error)")
//        }
//        
//    }
//    
//    func getUser(id: String) {
//        
//        let user = users.select(profile[*])
//            .filter(userId == id)
//        
//        print("user: \(user)")
//        
//    }

    func logOut(id: String) -> Bool {
        
        
        return false
        
    }
    
    func uploadPhotos(media: [String]) -> Bool {
        
        
        return false
        
    }

}

//public class Uploads {
//    
//    public let id = Expression<Int64>("id")
//    public let name = Expression<String?>("name")
//    public let isLoggedIn: Bool
//    
//}

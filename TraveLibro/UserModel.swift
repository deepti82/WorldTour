//
// UserModel.swift
//
//
//  Created by Midhet Sulemani on 01/07/16.
//
//

import SQLite

public class User {

    let db = TLModelManager.getSharedManager().db!

    let user = Table("user")

    let id = Expression<Int64>("id")
    let userId = Expression<String>("userid")
    let name = Expression<String>("name")
    let email = Expression<String>("email")
    let profilePicture = Expression<String?>("profilePicture")

    let logintype = Expression<String>("loginType")
    let socialId = Expression<String>("socialId")

    let userBadge = Expression<String?>("userBadge")
    let travelConfig = Expression<String?>("travelConfig")

    let homeCountry = Expression<String?>("homeCountry")
    let homeCity = Expression<String?>("homeCity")

    let isLoggedIn = Expression<Bool>("isLoggedIn")
    
    let privacy = Expression<String?>("privacy")
    

    init() {
        try! db.run(user.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(userId, unique: true)
            t.column(name)
            t.column(email, unique: true)
            t.column(profilePicture)
            t.column(logintype)
            t.column(socialId)
            t.column(userBadge)
            t.column(travelConfig)
            t.column(homeCountry)
            t.column(homeCity)
            t.column(isLoggedIn)
            t.column(privacy)
        })
    }

    func setUser(_ userid: String, name: String, useremail: String, profilepicture: String, travelconfig: String, loginType: String, socialId: String, userBadge: String, homecountry: String, homecity: String, isloggedin: Bool, privacy: String) -> Void {
        DispatchQueue.main.async {
            let count = try! self.db.scalar(self.user.filter(self.userId == userid).count)
            if(count == 0) {
                let userinsert = self.user.insert(
                    self.userId <- userid,
                    self.name <- name,
                    self.email <- useremail,
                    self.logintype <- loginType,
                    self.socialId <- socialId,
                    self.userBadge <- userBadge,
                    self.homeCountry <- homecountry,
                    self.homeCity <- homecity,
                    self.isLoggedIn <- isloggedin,
                    self.profilePicture <- profilepicture,
                    self.travelConfig <- travelconfig,
                    self.privacy <- privacy
                )
                do {
                    try self.db.run(userinsert)
                } catch _ {
                    
                }
            }
            else {
                let updaterow = self.user.filter(self.userId == userid)
                try! self.db.run(updaterow.update(self.name <- name))
                try! self.db.run(updaterow.update(self.email <- useremail))
                try! self.db.run(updaterow.update(self.logintype <- loginType))
                try! self.db.run(updaterow.update(self.socialId <- socialId))
                try! self.db.run(updaterow.update(self.userBadge <- userBadge))
                try! self.db.run(updaterow.update(self.homeCountry <- homecountry))
                try! self.db.run(updaterow.update(self.homeCity <- homecity))
                try! self.db.run(updaterow.update(self.isLoggedIn <- isloggedin))
                try! self.db.run(updaterow.update(self.privacy <- privacy))
            }
        }
    }

    func updateUserPrivacy(_ userid: String, privacy: String) {
        DispatchQueue.main.async {
            let count = try! self.db.scalar(self.user.filter(self.userId == userid).count)
            if(count == 0) {
                
                print("\n Error while updating privacy in local :: No recored found for userID: \(userid)")               
                
            } 
            else {
                let updaterow = self.user.filter(self.userId == userid)
                try! self.db.run(updaterow.update(self.privacy <- privacy))
            }
        }
    }
    
    func getUser(_ userid: String) -> (Name: String, 
        useremail:String, 
        loginType: String, 
        socialid: String,
        profilepicture: String,
        userbadge:String,
        homecountry: String,
        homecity: String,
        isloggedin: Bool,
        Privacy: String)  {

        var Name = ""
        var useremail = ""
        var loginType = ""
        var socialid = ""
        var profilepicture = ""
        var userbadge = ""
        var homecountry = ""
        var homecity = ""
        var isloggedin: Bool!
        var Privacy = ""

        let count = try! db.scalar(self.user.filter(self.userId == userid).count)
        if(count == 0) {
            print("")
        } else {
            let newval = try! db.pluck(self.user.filter(self.userId == userid))
            Name = newval![name]
            useremail = newval![email]
            loginType = newval![logintype]
            socialid = newval![socialId]
            profilepicture = newval![profilePicture]!
            userbadge = newval![userBadge]!
            homecountry = newval![homeCountry]!
            homecity = newval![homeCity]!
            isloggedin = newval![isLoggedIn]
            Privacy = newval![privacy]!
            
            //print(firstName, lastName, useremail, userdob, usergender, usermobile, userstatus, loginType, facebookid, twitterid, googleid, instagramid, userbadgeImage, userbadgeName, homecountry, homecity, isloggedin)
            
        }
        return (Name, useremail, loginType, socialid, profilepicture, userbadge, homecountry, homecity, isloggedin, Privacy)
    }
    
    func getExistingUser() -> String {
        if existingUserGlobal != "" {
            return existingUserGlobal
        }
        else {
            var result = ""
            do {
                for usr in try db.prepare(user.select(userId)) {
                    result = usr[userId]
                }
            } catch _ {}
            existingUserGlobal = result
            return result
        }
    }

    func delete(_ userid: String) {
        let deletequery = self.user.filter(self.userId == userid)
        try! db.run(deletequery.delete())
    }

    func flushRows() {
        try! db.run(user.delete())
    }

    func dropTable() {
        try! db.run(user.drop(ifExists: true))
    }

//    func logOut(_ id: String) -> Bool {
//        try! self.db.execute("DROP TABLE user")
//    }

    func uploadPhotos(_ media: [String]) -> Bool {
        return false
    }

}

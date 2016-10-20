//
// UserModel.swift
//
//
//  Created by Midhet Sulemani on 01/07/16.
//
//

import SQLite

public class User {

    public let db = AppDelegate.getDatabase()

    public let user = Table("user")

    public let id = Expression<Int64>("id")
    public let userId = Expression<String>("userid")
    public let name = Expression<String>("name")
    public let email = Expression<String>("email")
    public let profilePicture = Expression<String?>("profilePicture")

    public let logintype = Expression<String>("loginType")
    public let socialId = Expression<String>("socialId")

    public let userBadge = Expression<String?>("userBadge")
    public let travelConfig = Expression<String?>("travelConfig")

    public let homeCountry = Expression<String?>("homeCountry")
    public let homeCity = Expression<String?>("homeCity")

    public let isLoggedIn = Expression<Bool>("isLoggedIn")

    init() {
        try! db.run(user.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .Autoincrement)
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
        })
    }

    func setUser(userid: String, name: String, useremail: String, profilepicture: String, travelconfig: String, loginType: String, socialId: String, userBadge: String, homecountry: String, homecity: String, isloggedin: Bool) -> Void {
        dispatch_async(dispatch_get_main_queue(),{
            let count = self.db.scalar(self.user.filter(self.userId == userid).count)
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
                    self.travelConfig <- travelconfig
                )
                do {
                    try! self.db.run(userinsert)
                } catch _ {
                    
                }
            } else {
                let updaterow = self.user.filter(self.userId == userid)
                try! self.db.run(updaterow.update(self.name <- name))
                try! self.db.run(updaterow.update(self.email <- useremail))
                try! self.db.run(updaterow.update(self.logintype <- loginType))
                try! self.db.run(updaterow.update(self.socialId <- socialId))
                try! self.db.run(updaterow.update(self.userBadge <- userBadge))
                try! self.db.run(updaterow.update(self.homeCountry <- homecountry))
                try! self.db.run(updaterow.update(self.homeCity <- homecity))
                try! self.db.run(updaterow.update(self.isLoggedIn <- isloggedin))
            }
        })
    }

    func getUser(userid: String) -> (String, String, String, String, String, String, String, Bool)  {

        var Name = ""
        var useremail = ""
        var loginType = ""
        var socialid = ""
        var userbadge = ""
        var homecountry = ""
        var homecity = ""
        var isloggedin: Bool!

        let count = db.scalar(self.user.filter(self.userId == userid).count)
        if(count == 0) {
            print("")
        } else {
            let newval = db.pluck(self.user.filter(self.userId == userid))
            Name = newval![name]
            useremail = newval![email]
            loginType = newval![logintype]
            socialid = newval![socialId]
            userbadge = newval![userBadge]!
            homecountry = newval![homeCountry]!
            homecity = newval![homeCity]!
            isloggedin = newval![isLoggedIn]
            //print(firstName, lastName, useremail, userdob, usergender, usermobile, userstatus, loginType, facebookid, twitterid, googleid, instagramid, userbadgeImage, userbadgeName, homecountry, homecity, isloggedin)
        }
        return (Name, useremail, loginType, socialid, userbadge, homecountry, homecity, isloggedin)
    }
    
    func getExistingUser() -> String {
        var result = ""
        do {
            for usr in try db.prepare(user.select(userId)) {
                result = usr[userId]
            }
        } catch _ {}
        return result
    }

    func delete(userid: String) {
        let deletequery = self.user.filter(self.userId == userid)
        try! db.run(deletequery.delete())
    }

    func flushRows() {
        try! db.run(user.delete())
    }

    func dropTable() {
        try! db.run(user.drop(ifExists: true))
    }

    func logOut(id: String) -> Bool {
        return false
    }

    func uploadPhotos(media: [String]) -> Bool {
        return false
    }

}

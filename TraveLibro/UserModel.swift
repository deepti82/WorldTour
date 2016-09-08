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
    public let firstname = Expression<String>("firstname")
    public let lastname = Expression<String>("lastname")
    public let email = Expression<String>("email")
    public let dob = Expression<String>("dob")
    public let gender = Expression<String>("gender")
    public let mobile = Expression<String>("mobile")
    public let profilePicture = Expression<String>("profilepicture")
    public let status = Expression<String>("status")

    public let logintype = Expression<String>("logintype")
    public let facebookId = Expression<String>("facebookid")
    public let twitterId = Expression<String>("twitterid")
    public let googleId = Expression<String>("googleid")
    public let instagramId = Expression<String>("instagramid")

    public let userBadgeImage = Expression<String>("userBadgeImage")
    public let userBadgeName = Expression<String>("userBadgeName")
    public let travelConfig = Expression<String>("travelConfig")

    public let homeCountry = Expression<String>("homeCountry")
    public let homeCity = Expression<String>("homeCity")

    public let isLoggedIn = Expression<Bool>("isLoggedIn")

    init() {
        try! db.run(user.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(userId, unique: true)
            t.column(firstname)
            t.column(lastname)
            t.column(email, unique: true)
            t.column(dob)
            t.column(gender)
            t.column(mobile)
            t.column(profilePicture)
            t.column(status)
            t.column(logintype)
            t.column(facebookId)
            t.column(twitterId)
            t.column(googleId)
            t.column(instagramId)
            t.column(userBadgeImage)
            t.column(userBadgeName)
            t.column(travelConfig)
            t.column(homeCountry)
            t.column(homeCity)
            t.column(isLoggedIn)
        })
    }

    func setUser(userid: String, firstName: String, lastName: String, useremail: String, userdob: String, usergender: String, usermobile: String, profilepicture: String, userstatus: String, loginType: String, facebookid: String, twitterid: String, googleid: String, instagramid: String, userbadgeImage: String, userbadgeName: String, homecountry: String, homecity: String, isloggedin: Bool) -> Void {
        dispatch_async(dispatch_get_main_queue(),{
            let count = self.db.scalar(self.user.filter(self.userId == userid).count)
            if(count == 0) {
                let userinsert = self.user.insert(
                    self.userId <- userid,
                    self.firstname <- firstName,
                    self.lastname <- lastName,
                    self.email <- useremail,
                    self.dob <- userdob,
                    self.gender <- usergender,
                    self.mobile <- usermobile,
                    self.status <- userstatus,
                    self.logintype <- loginType,
                    self.facebookId <- facebookid,
                    self.twitterId <- twitterid,
                    self.googleId <- googleid,
                    self.instagramId <- instagramid,
                    self.userBadgeImage <- userbadgeImage,
                    self.userBadgeName <- userbadgeName,
                    self.homeCountry <- homecountry,
                    self.homeCity <- homecity,
                    self.isLoggedIn <- isloggedin
                )
                try! self.db.run(userinsert)
            } else {
                let updaterow = self.user.filter(self.userId == userid)
                try! self.db.run(updaterow.update(self.firstname <- firstName))
                try! self.db.run(updaterow.update(self.lastname <- lastName))
                try! self.db.run(updaterow.update(self.email <- useremail))
                try! self.db.run(updaterow.update(self.dob <- userdob))
                try! self.db.run(updaterow.update(self.gender <- usergender))
                try! self.db.run(updaterow.update(self.mobile <- usermobile))
                try! self.db.run(updaterow.update(self.status <- userstatus))
                try! self.db.run(updaterow.update(self.logintype <- loginType))
                try! self.db.run(updaterow.update(self.facebookId <- facebookid))
                try! self.db.run(updaterow.update(self.twitterId <- twitterid))
                try! self.db.run(updaterow.update(self.googleId <- googleid))
                try! self.db.run(updaterow.update(self.instagramId <- instagramid))
                try! self.db.run(updaterow.update(self.userBadgeImage <- userbadgeImage))
                try! self.db.run(updaterow.update(self.userBadgeName <- userbadgeName))
                try! self.db.run(updaterow.update(self.homeCountry <- homecountry))
                try! self.db.run(updaterow.update(self.homeCity <- homecity))
                try! self.db.run(updaterow.update(self.isLoggedIn <- isloggedin))
            }
        })
    }

    func getUser(userid: String) -> (String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, Bool)  {

        var firstName = ""
        var lastName = ""
        var useremail = ""
        var userdob = ""
        var usergender = ""
        var usermobile = ""
        var userstatus = ""
        var loginType = ""
        var facebookid = ""
        var twitterid = ""
        var googleid = ""
        var instagramid = ""
        var userbadgeImage = ""
        var userbadgeName = ""
        var homecountry = ""
        var homecity = ""
        var isloggedin: Bool!

        let count = db.scalar(self.user.filter(self.userId == userid).count)
        if(count == 0) {
            print("")
        } else {
            let newval = db.pluck(self.user.filter(self.userId == userid))
            firstName = newval![firstname]
            lastName = newval![lastname]
            useremail = newval![email]
            userdob = newval![dob]
            usergender = newval![gender]
            usermobile = newval![mobile]
            userstatus = newval![status]
            loginType = newval![logintype]
            facebookid = newval![facebookId]
            twitterid = newval![twitterId]
            googleid = newval![googleId]
            instagramid = newval![instagramId]
            userbadgeImage = newval![userBadgeImage]
            userbadgeName = newval![userBadgeName]
            homecountry = newval![homeCountry]
            homecity = newval![homeCity]
            isloggedin = newval![isLoggedIn]
            //print(firstName, lastName, useremail, userdob, usergender, usermobile, userstatus, loginType, facebookid, twitterid, googleid, instagramid, userbadgeImage, userbadgeName, homecountry, homecity, isloggedin)
        }
        return (firstName, lastName, useremail, userdob, usergender, usermobile, userstatus, loginType, facebookid, twitterid, googleid, instagramid, userbadgeImage, userbadgeName, homecountry, homecity, isloggedin)
    }

    func delete(userid: String) {
        let deletequery = self.user.filter(self.userId == userid)
        try! db.run(deletequery.delete())
    }

    func flush() {
        try! db.run(user.delete())
    }

    func drop() {
        try! db.run(user.drop(ifExists: true))
    }

    func logOut(id: String) -> Bool {
        return false
    }

    func uploadPhotos(media: [String]) -> Bool {
        return false
    }

}

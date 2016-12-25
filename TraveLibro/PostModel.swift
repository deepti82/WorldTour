//
//  PostModel.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 10/18/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import Foundation
import SQLite

let db = AppDelegate.getDatabase()

public class Post {
    
    let post = Table("Post")
    
    
    let imageArr:[PostImage] = []
    let buddies:[Buddy] = []
    // id, userid, journeyuniqueid, posttype, photos[], videos[], thought, checkin[], buddies[], iscompleted
    
    let id = Expression<Int64>("id")
    let type = Expression<String>("postType")
    let userId = Expression<String>("userid")
    let journeyId = Expression<String>("journey")
    let thoughts = Expression<String>("thoughts")
    let location = Expression<String>("location")
    let category = Expression<String>("category")
    let city = Expression<String>("city")
    let country = Expression<String>("country")
    let latitude = Expression<String>("latitude")
    let longitude = Expression<String>("longitude")
    let date = Expression<String>("date")
    
    var post_id:Int!;
    var post_type:String!
    var post_userId:String!
    var post_journeyId:String!
    var post_thoughts:String!
    var post_location:String!
    var post_category:String!
    var post_city:String!
    var post_country:String!
    var post_latitude:String!
    var post_longitude:String!
    var post_date:String!
    
    
    
    let hasCompleted = Expression<Bool>("hasCompleted")
    
    init() {
        try! db.run(post.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(type)
            t.column(userId)
            t.column(journeyId)
            t.column(thoughts)
            t.column(location)
            t.column(category)
            t.column(city)
            t.column(country)
            t.column(latitude)
            t.column(longitude)
            t.column(date)
        })
    }
    
    func setPost(_ UserId: String, JourneyId: String, Type: String, Date: String, Location: String, Category: String, Latitude: String, Longitude: String, Country: String, City: String, thoughts: String,buddies:[Buddy],imageArr:[PostImage]) {
        
        let photoinsert = self.post.insert(
            self.type <- Type,
            self.userId <- UserId,
            self.journeyId <- JourneyId,
            self.date <- Date,
            self.location <- Location,
            self.category <- Category,
            self.latitude <- Latitude,
            self.longitude <- Longitude,
            self.country <- Country,
            self.city <- City,
            self.thoughts <- thoughts
        )
        do {
            let postId = try db.run(photoinsert)
            print("Post ID " + String(postId));
            
            for buddy in buddies {
                buddy.postID = Int(postId)
                buddy.save();
            }
            for image in imageArr {
                image.postId = Int(postId)
                image.save()
            }
        } catch _ {
            print("ERROR OCCURED");
        }
        
    }
    
    func getAllPost() -> [Post] {
        var allPosts:[Post] = []
        
        
        return allPosts
        
    }
    
//    func getPost(postId: Int64) -> (String, String, String, String, String, String, String, String, String, String, String) {
//        
//        var user = ""
//        var journey = ""
//        var postType = ""
//        var postDate = ""
//        var postLocation = ""
//        var postCategory = ""
//        var postLatitude = ""
//        var postLongitude = ""
//        var postCountry = ""
//        var postCity = ""
//        var postStatus = ""
//        
//        let count = try! db.scalar(self.post.filter(self.id == postId).count)
//        if(count == 0) {
//            print("")
//        } else {
//            let newval = try! db.pluck(self.post.filter(self.id == postId))
//            user = newval![userId]
//            journey = newval![journeyId]
//            postType = newval![type]
//            postDate = newval![date]
//            postLocation = newval![location]
//            postCategory = newval![category]
//            postLatitude = newval![latitude]
//            postLongitude = newval![longitude]
//            postCountry = newval![country]
//            postCity = newval![city]
//            postStatus = newval![country]
//            //print(firstName, lastName, useremail, userdob, usergender, usermobile, userstatus, loginType, facebookid, twitterid, googleid, instagramid, userbadgeImage, userbadgeName, homecountry, homecity, isloggedin)
//            
//        }
//        return (user, journey, postType, postDate, postLocation, postCategory, postLatitude, postLongitude, postCountry, postCity, postStatus)
//    }
    
}



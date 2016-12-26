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
    
    
    var imageArr:[PostImage] = []
    var buddies:[Buddy] = []
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
    
    func getAllPost(journey:String) -> [Post] {
        var allPosts:[Post] = []
        do {
            let query = post.select(id,type,userId,journeyId,thoughts,location,category,city,country,latitude,longitude,date)
                .filter(journeyId == journey)
            for post in try db.prepare(query) {
                let p = Post();
                p.post_id = Int(post[id])
                p.post_type = String(post[type])
                p.post_userId = String(post[userId])
                p.post_journeyId = String(post[journeyId])
                p.post_thoughts = String(post[thoughts])
                p.post_location = String(post[location])
                p.post_category = String(post[category])
                p.post_city = String(post[city])
                p.post_country = String(post[country])
                p.post_latitude = String(post[latitude])
                p.post_longitude = String(post[longitude])
                p.post_date = String(post[date])
                
                
                var i = PostImage();
                p.imageArr = i.getAllImages(postNo: post[id])
                allPosts.append(p)
            }
        }
        catch {
            
        }
        
        
        return allPosts
        
    }
    
    func uploadPost() {
        do {
            var check = false;
            let query = post.select(id,type,userId,journeyId,thoughts,location,category,city,country,latitude,longitude,date)
                .limit(1)
            for post in try db.prepare(query) {
                check = true
                let p = Post();
                p.post_id = Int(post[id])
                p.post_type = String(post[type])
                p.post_userId = String(post[userId])
                p.post_journeyId = String(post[journeyId])
                p.post_thoughts = String(post[thoughts])
                p.post_location = String(post[location])
                p.post_category = String(post[category])
                p.post_city = String(post[city])
                p.post_country = String(post[country])
                p.post_latitude = String(post[latitude])
                p.post_longitude = String(post[longitude])
                p.post_date = String(post[date])
                
                
                let i = PostImage();
                p.imageArr = i.getAllImages(postNo: post[id])

                var photosJson:[JSON] = []
                
                for img in p.imageArr {
                    photosJson.append(img.parseJson())
                }
                
                let checkInJson:JSON = ["location":p.post_location,"category":p.post_category,"city":p.post_city,"country":p.post_country,"lat":p.post_latitude,"long":p.post_longitude]
                
                
                var params:JSON = ["type":"travel-life", "thoughts":p.post_thoughts,"user": p.post_userId,"journey":p.post_journeyId,"date":p.post_date]
                params["checkIn"] = checkInJson
                
                request.postTravelLifeJson(params, completion: {(response) in
                    if response.error != nil {
                        print("response: \(response.error?.localizedDescription)")
                    }
                    else if response["value"].bool! {
                        do {
                            let singlePhoto = self.post.filter(self.id == self.post[self.id])
                            try db.run(singlePhoto.delete())
                        }
                        catch {
                            
                        }
                        if(check) {
                            self.uploadPost()
                        }
                    }
                    else {
                        print("response error")
                    }
                })
            }
            if(!check) {
                
            }
        }
        catch {
            
        }
    }
}



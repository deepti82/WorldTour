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
    var jsonPost:JSON!
    var postCreator:JSON!
    var imageArr:[PostImage] = []
    var buddiesStr:String = "[]"
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
    let buddyDb = Expression<String>("buddyDb")
    
    var finalThought:String!
    
    var typeOfPost:String!
    var post_uniqueId:String!
    var post_id:Int!;
    var post_ids:String!;
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
    var post_locationImage:String!
    var post_dateDay:String!
    var post_dateTime:String!
    var post_likeCount:Int!
    var post_commentCount:Int!
    var post_likeDone = false
    var post_isOffline = false
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
            t.column(buddyDb)
        })
    }
    
    func setPost(_ UserId: String, JourneyId: String, Type: String, Date: String, Location: String, Category: String, Latitude: String, Longitude: String, Country: String, City: String, thoughts: String,buddies:String,imageArr:[PostImage]) -> Post{
        var retPost:Post!
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
            self.thoughts <- thoughts,
            self.buddyDb <- buddies
        )
        do {
            let postId = try db.run(photoinsert)
            
            
            for image in imageArr {
                image.postId = Int(postId)
                image.save()
            }
            
            let query = self.getAllPost(postid: postId)
            for post in query {
                retPost = post;
                retPost.post_isOffline = true;
            }
        } catch _ {
            print("ERROR OCCURED");
        }

        return retPost;
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
                p.post_isOffline = true;
                
                var i = PostImage();
                p.imageArr = i.getAllImages(postNo: post[id])
                allPosts.append(p)
            }
        }
        catch {
            
        }
        
        
        return allPosts
        
    }
    
    func getAllPost(postid:Int64) -> [Post] {
        var allPosts:[Post] = []
        do {
            let query = post.select(id,type,userId,journeyId,thoughts,location,category,city,country,latitude,longitude,date)
                .filter(id == postid)
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
                
                
                p.post_dateDay = changeDate(givenFormat: "yyyy-MM-dd'T'HH:mm:ss.SSZ", getFormat: "dd-MM-yyyy", date: p.post_date, isDate: true)
                p.post_dateTime = changeDate(givenFormat: "yyyy-MM-dd'T'HH:mm:ss.SSZ", getFormat: "h:mm a", date: p.post_date, isDate: false)
                
                var i = PostImage();
                p.imageArr = i.getAllImages(postNo: post[id])
                allPosts.append(p)
            }
        }
        catch {}
        return allPosts
    }
    
    func getThought () {
        let post = self
        var retText = ""
        if(post.post_thoughts != nil && post.post_thoughts != "") {
            retText = post.post_thoughts
            if(post.post_location != nil && post.post_location != "") {
                retText = retText + " at " + post.post_location
                if(post.buddies.count == 1) {
                    retText = retText + " with " + post.buddies[0].buddyName
                } else if (post.buddies.count == 2) {
                    retText = retText + " with " + post.buddies[0].buddyName + " and " + post.buddies[1].buddyName
                } else if (post.buddies.count > 2) {
                    let n = post.buddies.count - 1
                    retText = retText + " with " + post.buddies[0].buddyName + " and " + String(n) + " others"
                }
            } else {
                if(post.buddies.count == 1) {
                    retText = retText + " with " + post.buddies[0].buddyName
                } else if (post.buddies.count == 2) {
                    retText = retText + " with " + post.buddies[0].buddyName + " and " + post.buddies[1].buddyName
                } else if (post.buddies.count > 2) {
                    let n = post.buddies.count - 1
                    retText = retText + " with " + post.buddies[0].buddyName + " and " + String(n) + " others"
                }
            }
        } else {
            if(post.post_location != nil && post.post_location != "") {
                retText = "At " + post.post_location
                if(post.buddies.count == 1) {
                    retText = retText + " with " + post.buddies[0].buddyName
                } else if (post.buddies.count == 2) {
                    retText = retText + " with " + post.buddies[0].buddyName + " and " + post.buddies[1].buddyName
                } else if (post.buddies.count > 2) {
                    let n = post.buddies.count - 1
                    retText = retText + " with " + post.buddies[0].buddyName + " and " + String(n) + " others"
                }
            } else {
                if(post.buddies.count == 1) {
                    retText = "With " + post.buddies[0].buddyName
                } else if (post.buddies.count == 2) {
                    retText = "With " + post.buddies[0].buddyName + " and " + post.buddies[1].buddyName
                } else if (post.buddies.count > 2) {
                    let n = post.buddies.count - 1
                    retText = "With " + post.buddies[0].buddyName + " and " + String(n) + " others"
                }
            }
        }
        self.finalThought = retText
    }
    
    func getTypeOfPost() {
        let post = self;
        if(post.post_location != nil  && post.post_location != "") {
            post.typeOfPost = "Location"
        } else if(post.imageArr.count > 0) {
            post.typeOfPost = "Image"
        } else if(post.post_thoughts != nil && post.post_thoughts != "") {
            post.typeOfPost = "Thoughts"
        }
    }
    
    func jsonToPost(_ json:JSON) {
        
        self.jsonPost = json
        self.postCreator = json["postCreator"]
        self.post_ids = json["_id"].stringValue
        self.post_uniqueId = json["uniqueId"].stringValue
        self.post_type = json["type"].stringValue
        self.post_userId = json["user"]["_id"].stringValue
        self.post_journeyId = json["journey"].stringValue
        self.post_thoughts = json["thoughts"].stringValue
        self.post_location = json["checkIn"]["location"].stringValue
        self.post_category = json["checkIn"]["category"].stringValue
        self.post_city = json["checkIn"]["city"].stringValue
        self.post_country = json["checkIn"]["country"].stringValue
        self.post_latitude = json["checkIn"]["lat"].stringValue
        self.post_longitude = json["checkIn"]["long"].stringValue
        self.post_date = json["UTCModified"].stringValue
        self.post_likeCount = json["likeCount"].intValue
        self.post_commentCount = json["commentCount"].intValue
        
        self.post_dateDay = changeDate(givenFormat: "yyyy-MM-dd'T'HH:mm:ss.SSZ", getFormat: "dd-MM-yyyy", date: self.post_date, isDate: true)
        self.post_dateTime = changeDate(givenFormat: "yyyy-MM-dd'T'HH:mm:ss.SSZ", getFormat: "h:mm a", date: self.post_date, isDate: false)
        
        if(json["likeDone"].bool != nil) {
            self.post_likeDone = json["likeDone"].boolValue
        }
        
        if(json["imageUrl"].string != nil) {
            self.post_locationImage = json["imageUrl"].stringValue
        }
        
        for photo in json["photos"].arrayValue {
            let img = PostImage();
            img.urlToData(photo["name"].stringValue)
            img.caption = photo["caption"].stringValue
            self.imageArr.append(img);
        }
        
    }
    
    func changeDate(givenFormat: String, getFormat: String, date: String, isDate: Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = givenFormat
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = getFormat
        if isDate {
            dateFormatter.dateStyle = .medium
        }
        let goodDate = dateFormatter.string(from: date!)
        return goodDate
    }
    
    
    
    func uploadPost() {
        do {
            var check = false;
            let query = post.select(id,type,userId,journeyId,thoughts,location,category,city,country,latitude,longitude,date,buddyDb)
                .limit(1)
            for post in try db.prepare(query) {
                check = true
                let p = Post();
                
                var postID = post[id]
                
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
                p.buddiesStr = String(post[buddyDb])
                
                let i = PostImage();
                p.imageArr = i.getAllImages(postNo: post[id])
                
                var photosJson:[JSON] = []
                
                for img in p.imageArr {
                    photosJson.append(img.parseJson())
                }
                
                let checkInJson:JSON = ["location":p.post_location,"category":p.post_category,"city":p.post_city,"country":p.post_country,"lat":p.post_latitude,"long":p.post_longitude]
                
                var params:JSON = ["type":"travel-life", "thoughts":p.post_thoughts,"user": p.post_userId,"journey":p.post_journeyId,"date":p.post_date]
                
                if let data = p.buddiesStr.data(using: String.Encoding.utf8) {
                    params["buddies"] = JSON(data:data)
                }
                

                params["checkIn"] = checkInJson
                params["photos"] = JSON(photosJson)
                
                request.postTravelLifeJson(params, completion: {(response) in
                    if response.error != nil {
                        print("response: \(response.error?.localizedDescription)")
                    }
                    else if response["value"].bool! {
                        do {
                            let singlePhoto = self.post.filter(self.id == postID)
                            try db.run(singlePhoto.delete())
                            i.deletePhotos(postID);
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
                let pe = PostEditPhotosVideos();
                pe.uploadPostPhotosVideos()
            }
        }
        catch {
            print("There is an error");
        }
    }
}



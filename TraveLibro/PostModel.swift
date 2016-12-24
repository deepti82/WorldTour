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
    
    func getPost(postId: Int64) -> (String, String, String, String, String, String, String, String, String, String, String) {
        
        var user = ""
        var journey = ""
        var postType = ""
        var postDate = ""
        var postLocation = ""
        var postCategory = ""
        var postLatitude = ""
        var postLongitude = ""
        var postCountry = ""
        var postCity = ""
        var postStatus = ""
        
        let count = try! db.scalar(self.post.filter(self.id == postId).count)
        if(count == 0) {
            print("")
        } else {
            let newval = try! db.pluck(self.post.filter(self.id == postId))
            user = newval![userId]
            journey = newval![journeyId]
            postType = newval![type]
            postDate = newval![date]
            postLocation = newval![location]
            postCategory = newval![category]
            postLatitude = newval![latitude]
            postLongitude = newval![longitude]
            postCountry = newval![country]
            postCity = newval![city]
            postStatus = newval![country]
            //print(firstName, lastName, useremail, userdob, usergender, usermobile, userstatus, loginType, facebookid, twitterid, googleid, instagramid, userbadgeImage, userbadgeName, homecountry, homecity, isloggedin)
            
        }
        return (user, journey, postType, postDate, postLocation, postCategory, postLatitude, postLongitude, postCountry, postCity, postStatus)
        
        
    }
    
}

public class Photo {
    
    //    let photos = Table("Photos")
    //
    //    let id = Expression<Int64>("id")
    //    let groupid = Expression<Int64>("groupId")
    //    let name = Expression<String?>("photoName")
    //    let data = Expression<Data>("photoData")
    //    let caption = Expression<String?>("caption")
    //    let localurl = Expression<String>("localUrl")
    //
    //    init() {
    //        try! db.run(photos.create(ifNotExists: true) { t in
    //            t.column(id, primaryKey: true)
    //            t.column(groupid)
    //            t.column(name)
    //            t.column(data)
    //            t.column(caption)
    //        })
    //    }
    //
    //    func setPhotos(name: String?, data: Data, caption: String?, groupId: Int64) {
    //
    ////        dispatch_sync(dispatch_get_main_queue(),{
    //            let count = try! db.scalar(self.photos.filter(self.data == data).count)
    //            if(count == 0) {
    //                let photoinsert = self.photos.insert(
    //                    self.name <- name,
    //                    self.data <- data,
    //                    self.caption <- caption,
    //                    self.groupid <- groupId
    //                )
    //                do {
    //                    try! db.run(photoinsert)
    //                    print("photo added!")
    //                } catch _ {
    //
    //                }
    //            } else {
    //                let updaterow = self.photos.filter(self.data == data)
    //                try! db.run(updaterow.update(self.name <- name))
    //                try! db.run(updaterow.update(self.data <- data))
    //                try! db.run(updaterow.update(self.caption <- caption))
    //            }
    ////        })
    //
    //    }
    //
    //    func insertCaption(imageLocalId: Int64, caption: String) {
    //
    //        let count = try! db.scalar(self.photos.filter(self.id == Int64(imageLocalId)).count)
    //        if(count == 0) {
    //            print("no photos with same data found")
    //        } else {
    //            let updaterow = self.photos.filter(self.id == Int64(imageLocalId))
    //            print("update row: \(imageLocalId)")
    //            try! db.run(updaterow.update(self.caption <- caption))
    //        }
    //    }
    //
    //    func insertName(_ imageId: String, Name: String) {
    //
    //        let count = try! db.scalar(self.photos.filter(self.id == Int64(imageId)!).count)
    //        if(count == 0) {
    //            print("no photos with same data found")
    //        } else {
    //            let updaterow = self.photos.filter(self.id == Int64(imageId)!)
    //            print("update row: \(imageId)")
    //            try! db.run(updaterow.update(self.name <- Name))
    //        }
    //    }
    //
    //    func getPhotosIdsOfPost(photosGroup: Int64) -> [Int] {
    //
    //        var value: [Int] = []
    //
    //        let count = try! db.scalar(self.photos.filter(self.groupid == photosGroup).count)
    //        if(count == 0) {
    //            print("")
    //        } else {
    //            for row in try! db.prepare(self.photos.filter(self.groupid == photosGroup)) {
    //
    //                let photoId = Int(row[id])
    //                value.append(photoId)
    //
    //            }
    //        }
    //
    //        return value
    //
    //    }
    //
    //    func getCaption(_ photoId: Int) -> String? {
    //
    ////        var returnStr = ""
    //        do {
    //            let count = try! db.scalar(self.photos.filter(id == Int64(photoId)).count)
    //            if(count == 0) {
    //                print("no captions found")
    //            }
    //            else {
    //                let newval = try! db.pluck(self.photos.filter(id == Int64(photoId)))
    //                if newval![caption] != nil {
    //                    return newval?[caption]
    //                }
    //            }
    //        }
    //
    //        return nil
    //    }
    //
    //
    ////    func getPhotoNamesForPost(_ postId: String) -> [String] {
    ////
    ////        var value: [String] = []
    ////
    ////        let count = try! db.scalar(self.photos.filter(self.postid == postId).count)
    ////        if(count == 0) {
    ////            print("")
    ////        } else {
    ////            for row in try! db.prepare(self.photos.filter(self.postid == postId)) {
    ////
    //
    ////                let photoName = String(describing: row[name])
    ////                value.append(photoName)
    ////
    ////            }
    ////        }
    ////
    ////        return value
    ////
    ////    }
    //
    //    func getPhotos(postId: String) -> (String, Data, String) {
    //
    //        var Name = ""
    //        var photoData = Data()
    //        var photoCaption = ""
    //
    //        let count = try! db.scalar(self.photos.filter(self.groupid == id).count)
    //        if(count == 0) {
    //            print("")
    //        } else {
    //            let newval = try! db.pluck(self.photos.filter(self.groupid == id))
    //            Name = newval![name]!
    //            photoData = newval![data]
    //            photoCaption = newval![caption]!
    //            //print(firstName, lastName, useremail, userdob, usergender, usermobile, userstatus, loginType, facebookid, twitterid, googleid, instagramid, userbadgeImage, userbadgeName, homecountry, homecity, isloggedin)
    //
    //        }
    //        return (Name, photoData, photoCaption)
    //
    //    }
    //
    //
    //    func getRowCount() -> Int {
    //        let count = try! db.scalar(photos.count)
    //        return count
    //    }
    //
    //    func flushRows(localId: Int64) {
    //
    //        let tempPhotos = photos.filter(id == localId)
    //        do {
    //            if try! db.run(tempPhotos.delete()) > 0 {
    //                print("deleted alice")
    //            } else {
    //                print("alice not found")
    //            }
    //        } catch {
    //            print("delete failed: \(error)")
    //        }
    //    }
    //
    //    func drop() {
    //        try! db.run(photos.drop(ifExists: true))
    //    }
    
}


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
    
    // id, userid, journeyuniqueid, posttype, photos[], videos[], thought, checkin[], buddies[], iscompleted
    
    let id = Expression<Int64>("id")
    let userId = Expression<String>("userid")
    let journeyId = Expression<String>("name")
    let type = Expression<String>("postType")
    let date = Expression<String>("date")
    let thoughts = Expression<String?>("thoughts")
    let location = Expression<String>("location")
    let category = Expression<String>("category")
    let latitude = Expression<String>("latitude")
    let longitude = Expression<String>("longitude")
    let country = Expression<String>("country")
    let city = Expression<String>("city")
    let hasCompleted = Expression<Bool>("hasCompleted")
    
    init() {
        try! db.run(post.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(userId)
            t.column(journeyId)
            t.column(type)
            t.column(date)
            t.column(thoughts)
            t.column(location)
            t.column(category)
            t.column(latitude)
            t.column(longitude)
            t.column(country)
            t.column(city)
            t.column(hasCompleted)
        })
    }
    
    func setPost(_ UserId: String, JourneyId: String, Type: String, Date: String, Location: String, Category: String, Latitude: String, Longitude: String, Country: String, City: String, Status: String) {
        
        DispatchQueue.main.async(execute: {
                let photoinsert = self.post.insert(
                    self.userId <- UserId,
                    self.journeyId <- JourneyId,
                    self.type <- Type,
                    self.date <- Date,
                    self.location <- Location,
                    self.category <- Category,
                    self.latitude <- Latitude,
                    self.longitude <- Longitude,
                    self.country <- Country,
                    self.city <- City,
                    self.thoughts <- Status,
                    self.hasCompleted <- false
                )
                do {
                    try! db.run(photoinsert)
                } catch _ {
                    
                }
//            } else {
//                let updaterow = self.photos.filter(self.postid == postId)
//                try! db.run(updaterow.update(self.location <- Location))
//                try! db.run(updaterow.update(self.postid <- postId))
//                try! db.run(updaterow.update(self.category <- Category))
//                try! db.run(updaterow.update(self.country <- Country))
//                try! db.run(updaterow.update(self.city <- City))
//            }
        })
        
    }
    
    func getRowCount() -> Int {
        let count = try! db.scalar(post.count)
        return count
    }
    
    func drop() {
        try! db.run(post.drop(ifExists: true))
    }
    
    func flushRows(_ postId: Int64) {
        
        let posts = post.filter(id == postId)
        do {
            if try! db.run(posts.delete()) > 0 {
                print("deleted post")
            } else {
                print("post not found")
            }
        } catch {
            print("delete failed: \(error)")
        }
    }
    
}

public class Photo {
    
    let photos = Table("Photos")
    
    let id = Expression<Int64>("id")
    let groupid = Expression<Int64>("groupId")
    let name = Expression<String?>("photoName")
    let data = Expression<Data>("photoData")
    let caption = Expression<String?>("caption")
    let localurl = Expression<String>("localUrl")
    
    init() {
        try! db.run(photos.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(groupid)
            t.column(name, unique: true)
            t.column(data, unique: true)
            t.column(caption)
        })
    }
    
    func setPhotos(name: String?, data: Data, caption: String?, groupId: Int64) {
        
//        dispatch_sync(dispatch_get_main_queue(),{
            let count = try! db.scalar(self.photos.filter(self.data == data).count)
            if(count == 0) {
                let photoinsert = self.photos.insert(
                    self.name <- name,
                    self.data <- data,
                    self.caption <- caption,
                    self.groupid <- groupId
                )
                do {
                    try! db.run(photoinsert)
                    print("photo added!")
                } catch _ {
                    
                }
            } else {
                let updaterow = self.photos.filter(self.data == data)
                try! db.run(updaterow.update(self.name <- name))
                try! db.run(updaterow.update(self.data <- data))
                try! db.run(updaterow.update(self.caption <- caption))
            }
//        })
        
    }
    
    func insertCaption(imageLocalId: Int64, caption: String) {
        
        let count = try! db.scalar(self.photos.filter(self.id == Int64(imageLocalId)).count)
        if(count == 0) {
            print("no photos with same data found")
        } else {
            let updaterow = self.photos.filter(self.id == Int64(imageLocalId))
            print("update row: \(imageLocalId)")
            try! db.run(updaterow.update(self.caption <- caption))
        }
    }
    
    func insertName(_ imageId: String, Name: String) {
        
        let count = try! db.scalar(self.photos.filter(self.id == Int64(imageId)!).count)
        if(count == 0) {
            print("no photos with same data found")
        } else {
            let updaterow = self.photos.filter(self.id == Int64(imageId)!)
            print("update row: \(imageId)")
            try! db.run(updaterow.update(self.name <- Name))
        }
    }
    
    func getPhotosIdsOfPost(photosGroup: Int64) -> [Int] {
        
        var value: [Int] = []
        
        let count = try! db.scalar(self.photos.filter(self.groupid == photosGroup).count)
        if(count == 0) {
            print("")
        } else {
            for row in try! db.prepare(self.photos.filter(self.groupid == photosGroup)) {
                
                let photoId = Int(row[id])
                value.append(photoId)
                
            }
        }
        
        return value
        
    }
    
    func getCaption(_ photoId: Int) -> String? {
        
//        var returnStr = ""
        do {
            let count = try! db.scalar(self.photos.filter(id == Int64(photoId)).count)
            if(count == 0) {
                print("no captions found")
            }
            else {
                let newval = try! db.pluck(self.photos.filter(id == Int64(photoId)))
                if newval![caption] != nil {
                    return newval?[caption]
                }
            }
        }
        
        return nil
    }
    
    
//    func getPhotoNamesForPost(_ postId: String) -> [String] {
//        
//        var value: [String] = []
//        
//        let count = try! db.scalar(self.photos.filter(self.postid == postId).count)
//        if(count == 0) {
//            print("")
//        } else {
//            for row in try! db.prepare(self.photos.filter(self.postid == postId)) {
// 
    
//                let photoName = String(describing: row[name])
//                value.append(photoName)
//                
//            }
//        }
//        
//        return value
//        
//    }
    
    func getRowCount() -> Int {
        let count = try! db.scalar(photos.count)
        return count
    }
    
    func flushRows(localId: Int64) {
        
        let tempPhotos = photos.filter(id == localId)
        do {
            if try! db.run(tempPhotos.delete()) > 0 {
                print("deleted alice")
            } else {
                print("alice not found")
            }
        } catch {
            print("delete failed: \(error)")
        }
    }
    
    func drop() {
        try! db.run(photos.drop(ifExists: true))
    }
    
}

public class Video {
    
    let photos = Table("Videos")
    
    let id = Expression<Int64>("id")
    let postid = Expression<String>("postId")
    let name = Expression<String?>("videoName")
    let data = Expression<String>("videoData")
    let caption = Expression<String?>("caption")
    
    
}

public class CheckIn {
    
    let photos = Table("CheckIn")
    
    let id = Expression<Int64>("id")
    let postid = Expression<String>("postId")
    
    
    init() {
        try! db.run(photos.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(postid, unique: true)
            
        })
    }
    
    

    
}

public class Buddy {
    
    let buddy = Table("Buddy")
    
    let id = Expression<Int64>("id")
    let postid = Expression<String>("postId")
    let buddyuserid = Expression<String>("buddyUserId")
    let buddyname = Expression<String>("buddyName")
    let buddydp = Expression<String>("buddyDp")
    let buddyemail = Expression<String>("buddyEmail")
    
    init() {
        try! db.run(buddy.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(postid)
            t.column(buddyuserid)
            t.column(buddyname)
            t.column(buddydp)
            t.column(buddyemail)
        })
    }
    
    func setBuddies(_ postId: String, userId: String, userName: String, userDp: String, userEmail: String) {
        
        DispatchQueue.main.async(execute: {
            let photoinsert = self.buddy.insert(
                self.buddyuserid <- userId,
                self.buddyname <- userName,
                self.postid <- postId,
                self.buddydp <- userDp,
                self.buddyemail <- userEmail
            )
            do {
                try! db.run(photoinsert)
            } catch _ {
                
            }
        })
        
    }
    
    func flushRows(_ postId: String) {
        
        let buddies = buddy.filter(postid == postId)
        do {
            if try! db.run(buddies.delete()) > 0 {
                print("deleted alice")
            } else {
                print("alice not found")
            }
        } catch {
            print("delete failed: \(error)")
        }
    }
    
}

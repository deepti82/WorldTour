//
//  PostModel.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 10/18/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import Foundation
import SQLite

public let db = AppDelegate.getDatabase()

open class Post {
    
    open let post = Table("Post")
    
    // id, userid, journeyuniqueid, posttype, photos[], videos[], thought, checkin[], buddies[], iscompleted
    
    open let id = Expression<Int64>("id")
    open let userId = Expression<String>("userid")
    open let journeyId = Expression<String>("name")
    open let type = Expression<String>("postType")
    open let date = Expression<String>("date")
    open let thoughts = Expression<String?>("thoughts")
    open let location = Expression<String>("location")
    open let category = Expression<String>("category")
    open let country = Expression<String>("country")
    open let city = Expression<String>("city")
    open let hasCompleted = Expression<Bool>("hasCompleted")
    
    init() {
        try! db.run(post.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(userId)
            t.column(journeyId)
            t.column(type)
            t.column(date)
            t.column(thoughts)
            t.column(location)
            t.column(category)
            t.column(country)
            t.column(city)
            t.column(hasCompleted)
        })
    }
    
    func setPost(_ UserId: String, JourneyId: String, Type: String, Date: String, Location: String, Category: String, Country: String, City: String, Status: String) {
        
        DispatchQueue.main.async(execute: {
                let photoinsert = self.post.insert(
                    self.userId <- UserId,
                    self.journeyId <- JourneyId,
                    self.type <- Type,
                    self.date <- Date,
                    self.location <- Location,
                    self.category <- Category,
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
        let count = db.scalar(post.count)
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

open class Photo {
    
    open let photos = Table("Photos")
    
    open let id = Expression<Int64>("id")
    open let postid = Expression<String>("postId")
    open let name = Expression<String?>("photoName")
    open let data = Expression<Data>("photoData")
    open let caption = Expression<String?>("caption")
    open let localurl = Expression<String>("localUrl")
    
    init() {
        try! db.run(photos.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(postid)
            t.column(name, unique: true)
            t.column(data, unique: true)
            t.column(caption)
        })
    }
    
    func setPhotos(_ postId: String, Name: String?, Data: Foundation.Data, Caption: String?) {
        
//        dispatch_sync(dispatch_get_main_queue(),{
            let count = db.scalar(self.photos.filter(self.data == Data).count)
            if(count == 0) {
                let photoinsert = self.photos.insert(
                    self.postid <- postId,
                    self.name <- Name,
                    self.data <- Data,
                    self.caption <- Caption
                )
                do {
                    try! db.run(photoinsert)
                } catch _ {
                    
                }
            } else {
                let updaterow = self.photos.filter(self.data == Data)
                try! db.run(updaterow.update(self.name <- Name))
                try! db.run(updaterow.update(self.postid <- postId))
                try! db.run(updaterow.update(self.data <- Data))
                try! db.run(updaterow.update(self.caption <- Caption))
            }
//        })
        
    }
    
    func insertCaption(_ imageId: String, caption: String) {
        
        let count = db.scalar(self.photos.filter(self.id == Int64(imageId)!).count)
        if(count == 0) {
            print("no photos with same data found")
        } else {
            let updaterow = self.photos.filter(self.id == Int64(imageId)!)
            print("update row: \(imageId)")
            try! db.run(updaterow.update(self.caption <- caption))
        }
    }
    
    func insertName(_ imageId: String, Name: String) {
        
        let count = db.scalar(self.photos.filter(self.id == Int64(imageId)!).count)
        if(count == 0) {
            print("no photos with same data found")
        } else {
            let updaterow = self.photos.filter(self.id == Int64(imageId)!)
            print("update row: \(imageId)")
            try! db.run(updaterow.update(self.name <- Name))
        }
    }
    
    func getPhotosOfPost(_ post: String) -> [String] {
        
        var value: [String] = []
        
        let count = db.scalar(self.photos.filter(self.postid == post).count)
        if(count == 0) {
            print("")
        } else {
            for row in try! db.prepare(self.photos.filter(self.postid == post)) {
                
                let photoId = String(row[id])
                value.append(photoId)
                
            }
        }
        
        return value
        
    }
    
    func getPhotoNamesForPost(_ postId: String) -> [String] {
        
        var value: [String] = []
        
        let count = db.scalar(self.photos.filter(self.postid == postId).count)
        if(count == 0) {
            print("")
        } else {
            for row in try! db.prepare(self.photos.filter(self.postid == postId)) {
                
                let photoName = String(row[name])
                value.append(photoName)
                
            }
        }
        
        return value
        
    }
    
    func flushRows(_ postId: String) {
        
        let tempPhotos = photos.filter(postid == postId)
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

open class Video {
    
    open let photos = Table("Videos")
    
    open let id = Expression<Int64>("id")
    open let postid = Expression<String>("postId")
    open let name = Expression<String?>("videoName")
    open let data = Expression<String>("videoData")
    open let caption = Expression<String?>("caption")
    
    
}

open class CheckIn {
    
    open let photos = Table("CheckIn")
    
    open let id = Expression<Int64>("id")
    open let postid = Expression<String>("postId")
    
    
    init() {
        try! db.run(photos.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(postid, unique: true)
            
        })
    }
    
    

    
}

open class Buddy {
    
    open let buddy = Table("Buddy")
    
    open let id = Expression<Int64>("id")
    open let postid = Expression<String>("postId")
    open let buddyuserid = Expression<String>("buddyUserId")
    open let buddyname = Expression<String>("buddyName")
    open let buddydp = Expression<String>("buddyDp")
    open let buddyemail = Expression<String>("buddyEmail")
    
    init() {
        try! db.run(buddy.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .Autoincrement)
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

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

public class Post {
    
    public let post = Table("Post")
    
    // id, userid, journeyuniqueid, posttype, photos[], videos[], thought, checkin[], buddies[], iscompleted
    
    public let id = Expression<Int64>("id")
    public let userId = Expression<String>("userid")
    public let journeyId = Expression<String>("name")
    public let type = Expression<String>("postType")
    public let date = Expression<String>("date")
    public let location = Expression<String>("location")
    public let category = Expression<String>("category")
    public let country = Expression<String>("country")
    public let city = Expression<String>("city")
    public let hasCompleted = Expression<Bool>("hasCompleted")
    
    init() {
        try! db.run(post.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(userId)
            t.column(journeyId)
            t.column(type)
            t.column(date)
            t.column(location)
            t.column(category)
            t.column(country)
            t.column(city)
            t.column(hasCompleted)
        })
    }
    
    func setPost(UserId: String, JourneyId: String, Type: String, Date: String, Location: String, Category: String, Country: String, City: String) {
        
        dispatch_async(dispatch_get_main_queue(),{
                let photoinsert = self.post.insert(
                    self.userId <- UserId,
                    self.journeyId <- JourneyId,
                    self.type <- Type,
                    self.date <- Date,
                    self.location <- Location,
                    self.category <- Category,
                    self.country <- Country,
                    self.city <- City,
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
    
    func flushRows(postId: Int64) {
        
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
    
    public let photos = Table("Photos")
    
    public let id = Expression<Int64>("id")
    public let postid = Expression<String>("postId")
    public let name = Expression<String?>("photoName")
    public let data = Expression<NSData>("photoData")
    public let caption = Expression<String?>("caption")
    public let localurl = Expression<String>("localUrl")
    
    init() {
        try! db.run(photos.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(postid)
            t.column(name, unique: true)
            t.column(data, unique: true)
            t.column(caption)
        })
    }
    
    func setPhotos(postId: String, Name: String?, Data: NSData, Caption: String?) {
        
        dispatch_async(dispatch_get_main_queue(),{
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
        })
        
    }
    
    func insertCaption(imageId: String, caption: String) {
        
        let count = db.scalar(self.photos.filter(self.id == Int64(imageId)!).count)
        if(count == 0) {
            print("no photos with same data found")
        } else {
            let updaterow = self.photos.filter(self.id == Int64(imageId)!)
            print("update row: \(imageId)")
            try! db.run(updaterow.update(self.caption <- caption))
        }
    }
    
    func insertName(imageId: String, Name: String) {
        
        let count = db.scalar(self.photos.filter(self.id == Int64(imageId)!).count)
        if(count == 0) {
            print("no photos with same data found")
        } else {
            let updaterow = self.photos.filter(self.id == Int64(imageId)!)
            print("update row: \(imageId)")
            try! db.run(updaterow.update(self.name <- Name))
        }
    }
    
    func getPhotosOfPost(post: String) -> [String] {
        
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
    
    func getPhotoNamesForPost(postId: String) -> [String] {
        
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
    
    func flushRows(postId: String) {
        
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
    
}

public class Video {
    
    public let photos = Table("Videos")
    
    public let id = Expression<Int64>("id")
    public let postid = Expression<String>("postId")
    public let name = Expression<String?>("videoName")
    public let data = Expression<String>("videoData")
    public let caption = Expression<String?>("caption")
    
    
}

public class CheckIn {
    
    public let photos = Table("CheckIn")
    
    public let id = Expression<Int64>("id")
    public let postid = Expression<String>("postId")
    
    
    init() {
        try! db.run(photos.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(postid, unique: true)
            
        })
    }
    
    

    
}

public class Buddy {
    
    public let buddy = Table("Buddy")
    
    public let id = Expression<Int64>("id")
    public let postid = Expression<String>("postId")
    public let buddyuserid = Expression<String>("buddyUserId")
    public let buddyname = Expression<String>("buddyName")
    public let buddydp = Expression<String>("buddyDp")
    public let buddyemail = Expression<String>("buddyEmail")
    
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
    
    func setBuddies(postId: String, userId: String, userName: String, userDp: String, userEmail: String) {
        
        dispatch_async(dispatch_get_main_queue(),{
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
    
    func flushRows(postId: String) {
        
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

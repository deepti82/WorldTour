//
//  PostModel.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 10/18/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import Foundation
import SQLite

public class LocalLifePostModel {
    let db = TLModelManager.getSharedManager().db!
    
    let post = Table("LocalLifePost")
    var jsonPost:JSON!
    var postCreator:JSON!
    var imageArr:[PostImage] = []
    var videoArr:[PostVideo] = []
    var buddiesStr:String = "[]"
    var buddies:[Buddy] = []
    var buddyJson:[JSON] = []
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
    let localLifePostStatus = Expression<Int64>("uploadstatus")
    
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
    var post_local_life_status: uploadStatus!
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
            t.column(localLifePostStatus)
        })        
    }
    
    func setPost(_ UserId: String, JourneyId: String, Type: String, Date: String, Location: String, Category: String, Latitude: String, Longitude: String, Country: String, City: String, thoughts: String,buddies:String,imageArr:[PostImage], videoURL:URL!,videoCaption:String) -> LocalLifePostModel {
        var retPost:LocalLifePostModel!
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
            self.buddyDb <- buddies,
            self.localLifePostStatus <- Int64(0)
        )
        do {
            let postId = try db.run(photoinsert)
            
            let actualId = Int(postId) + 20000
            
            for image in imageArr {
                image.postId = Int(actualId)
                image.save()
            }
            
            if(videoURL != nil) {
                let video = PostVideo()
                video.videoUrl = videoURL
                video.caption = videoCaption
                video.postId = Int(actualId)
                video.save()
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
    
    func getAllPost(journey:String) -> [LocalLifePostModel] {
        var allPosts:[LocalLifePostModel] = []
        do {
            let query = post.select(id,type,userId,journeyId,thoughts,location,category,city,country,latitude,longitude,date)
                .filter(journeyId == journey)
            for post in try db.prepare(query) {
                let p = LocalLifePostModel();
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
                
                let i = PostImage();
                p.imageArr = i.getAllImages(postNo: post[id])
                
                let v = PostVideo();
                p.videoArr = v.getAll(postNo: post[id])
                allPosts.append(p)
            }
        }
        catch {
            
        }
        return allPosts
    }
    
    func getAllPost(postid:Int64) -> [LocalLifePostModel] {
        var allPosts:[LocalLifePostModel] = []
        do {
            let query = post.select(id,type,userId,journeyId,thoughts,location,category,city,country,latitude,longitude,date)
                .filter(id == postid)
            for post in try db.prepare(query) {
                let p = LocalLifePostModel();
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
                
                let i = PostImage();
                p.imageArr = i.getAllImages(postNo: post[id])
                
                let v = PostVideo();
                p.videoArr = v.getAll(postNo: post[id])
                allPosts.append(p)
                
            }
        }
        catch {}
        return allPosts
    }

    func getTypeOfPost() {
        let post = self;
        if(post.post_location != nil  && post.post_location != "") {
            post.typeOfPost = "Location"
        } else if(post.videoArr.count > 0) {
            post.typeOfPost = "Videos"
        } else if(post.imageArr.count > 0) {
            post.typeOfPost = "Image"
        } else if(post.post_thoughts != nil && post.post_thoughts != "") {
            post.typeOfPost = "Thoughts"
        }
    }
    
    func jsonToPost(_ json:JSON) {
        print(json);
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
        self.buddyJson = json["buddies"].array!
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
            img.editId = photo["_id"].stringValue
            img.urlToData(photo["name"].stringValue)
            img.caption = photo["caption"].stringValue
            self.imageArr.append(img);
        }
        for video in json["videos"].arrayValue {
            let vid = PostVideo();
            vid.editId = video["_id"].stringValue
            vid.caption = video["caption"].stringValue
            vid.serverUrl = video["name"].stringValue
            vid.serverUrlThumbnail = video["thumbnail"].stringValue
            self.videoArr.append(vid);
        }
        
    }
    
    func updateStatus(postId: Int64, status: uploadStatus) {        
        var toStatus = 0
        switch status {
        case .UPLOAD_PENDING:
            toStatus = 0
            
        case .UPLOAD_IN_PROGRESS:
            toStatus = 1
            
        case .UPLOAD_COMPLETE:
            toStatus = 2
            
        case .UPLOAD_FAILED:
            toStatus = 3
        }
        
        let updaterow = self.post.filter(self.id == postId)
        do {
            try self.db.run(updaterow.update(self.localLifePostStatus <- Int64(toStatus))) 
        }
        catch {
            print("\n POST update error FOUND")
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
    
    func getAllJson() -> [JSON] {
        var retJson:[JSON] = []
        do {
            let query = post.select(id,type,userId,journeyId,thoughts,location,category,city,country,latitude,longitude,date,buddyDb)
                .filter(localLifePostStatus == 0 || localLifePostStatus == 4)
                .limit(1)
            
            for post in try db.prepare(query) {           
                let p = LocalLifePostModel()
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
                
                let actualId = Int(post[id]) + 20000
                
                let i = PostImage();
                p.imageArr = i.getAllImages(postNo: Int64(actualId))
                
                var photosJson:[JSON] = []
                
                for img in p.imageArr {
                    photosJson.append(img.parseJson())
                }
                
                
                let v = PostVideo();
                p.videoArr = v.getAll(postNo: Int64(actualId))
                
                var vidoesJson:[JSON] = []
                
                for vid in p.videoArr {
                    vidoesJson.append(vid.parseJson())
                }
                
                let checkInJson:JSON = ["location":p.post_location,"category":p.post_category,"city":p.post_city,"country":p.post_country,"lat":p.post_latitude,"long":p.post_longitude]
                
                var params:JSON = ["type":"local-life", "thoughts":p.post_thoughts,"user": p.post_userId,"date":p.post_date]
                
                if let data = p.buddiesStr.data(using: String.Encoding.utf8) {
                    params["buddies"] = JSON(data:data)
                }
                
                params["checkIn"] = checkInJson
                params["photos"] = JSON(photosJson)
                params["videos"] = JSON(vidoesJson)
                retJson.append(params)
            }
            
        }
        catch {
            print("There is an error");
        }

        return retJson
    }
    
    func uploadPost() {
        print("\n uploadPost called in localLife")
        do {
            var check = false
            var query: QueryType!
            
            if currentUploadingPostID == Int64(0) {
                print("\n if succeed")
                query = post.select(id,type,userId,journeyId,thoughts,location,category,city,country,latitude,longitude,date,buddyDb)
                    .filter(localLifePostStatus == 0 || localLifePostStatus == 3)
                    .limit(1)                   
            }
            else {
                print("\n else succeed")
                query = post.select(id,type,userId,journeyId,thoughts,location,category,city,country,latitude,longitude,date,buddyDb)
                    .filter((localLifePostStatus == 0 || localLifePostStatus == 3) && (id == currentUploadingPostID))
                    .limit(1)
            }
            
            for post in try db.prepare(query) {
                check = true
                uploadFlag = true
                
                self.updateStatus(postId: post[id], status: (isNetworkReachable ? uploadStatus.UPLOAD_IN_PROGRESS : uploadStatus.UPLOAD_PENDING))
                
                let p = LocalLifePostModel();
                
                let postID = post[id]
                
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
                
                let actualId = Int(post[id]) + 20000
                
                let i = PostImage();
                p.imageArr = i.getAllImages(postNo: Int64(actualId))
                
                var photosJson:[JSON] = []
                
                for img in p.imageArr {
                    photosJson.append(img.parseJson())
                }
                
                print("\n photoJson : \(photosJson)")
                
                let v = PostVideo();
                p.videoArr = v.getAll(postNo: Int64(actualId))
                
                var vidoesJson:[JSON] = []
                
                for vid in p.videoArr {
                    vidoesJson.append(vid.parseJson())
                }
                
                var ctgry = ""
                if p.post_category == "" {
                    ctgry = "Others"
                }else{
                    ctgry = p.post_category
                }

                
                let checkInJson:JSON = ["location":p.post_location,"category":ctgry,"city":p.post_city,"country":p.post_country,"lat":p.post_latitude,"long":p.post_longitude]
                
                var params:JSON = ["type":"local-life", "thoughts":p.post_thoughts,"user": p.post_userId,"date":p.post_date]
                
                if let data = p.buddiesStr.data(using: String.Encoding.utf8) {
                    params["buddies"] = JSON(data:data)
                }
                
                params["checkIn"] = checkInJson
                params["photos"] = JSON(photosJson)
                params["videos"] = JSON(vidoesJson)
                
                request.postLocalLifeJson(params, completion: {(response) in
                    if response.error != nil {
                        print("response: \(String(describing: response.error?.localizedDescription))")
                        self.updateStatus(postId: post[self.id], status: uploadStatus.UPLOAD_FAILED)
                    }
                    else if response["value"].bool! {
                        do {                            
                            let singlePhoto = self.post.filter(self.id == postID)
                            try self.db.run(singlePhoto.delete())
                            i.deletePhotos(Int64(actualId));
                            v.delete(Int64(actualId))                            
                            self.updateStatus(postId: post[self.id], status: uploadStatus.UPLOAD_COMPLETE)
                            p.delete(Int64(actualId))
                        }
                        catch {
                            
                        }
                        if(check) {
                            isUploadingInProgress = false
                            let i = PostImage()
                            i.uploadPhotos(delegate: nil)
                        }
                    }
                    else {
                        print("response error")
                        self.updateStatus(postId: post[self.id], status: uploadStatus.UPLOAD_FAILED)
                    }
                })
            }
            
            if(!check) {
                let qi = QuickItinerary();
                qi.upload();
            }
           
        }
        catch {
            print("There is an error");
        }
    }
    
    func delete(_ post:Int64) {
        do {
            let query = self.post.filter(self.id == post)
            try db.run(query.delete())
        }
        catch {
            print("\n Error in deleting Local POST")
        }
    }
    
    func rollbackLocalPostTableProgress() {
        do {
            let query = post.select(id,type,userId,journeyId,thoughts,location,category,city,country,latitude,longitude,date,buddyDb)
                .filter(localLifePostStatus == 1)                
            
            for post in try db.prepare(query) {
                self.updateStatus(postId: post[self.id], status: uploadStatus.UPLOAD_FAILED)
            }
        }
        catch {
            print(error);
        }
    }
    
    func dropLocalPostTable() {
        try! db.run(post.drop(ifExists: true))
    }
    
    
}



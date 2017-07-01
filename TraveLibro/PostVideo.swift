//
//  ImageModel.swift
//  TraveLibro
//
//  Created by Chintan Shah on 20/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//
import Foundation
import SQLite
import Haneke

public class PostVideo {
    
    let db = TLModelManager.getSharedManager().db!
    
    var imageUrl: URL!
    var image:UIImage!
    var videoUrl:URL!
    
    var caption = ""
    var postId = 0
    var serverUrl = ""
    var localURL = ""
    var serverUrlThumbnail = ""
    var editId = ""
    
    let videos = Table("Videos")
    
    let id = Expression<Int64>("id")
    let post = Expression<Int64>("post")
    let captions = Expression<String>("caption")
    let localUrl = Expression<String>("localUrl")
    let url = Expression<String>("url")
    let thumbnail = Expression<String>("thumbnail")
    let videoUploadStatus = Expression<Int64>("uploadStatus")
    
    init() {
        do {
            try db.run(videos.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(post)
                t.column(captions)
                t.column(localUrl)
                t.column(url)
                t.column(thumbnail)
                t.column(videoUploadStatus)
            })
        }
        catch {
            print("There was error in the system");
        }
        
    }
    
    func save() {
        var filename:URL!
        var filenameOnly = "";

        let data = NSData(contentsOf: self.videoUrl)
        do {
            filenameOnly = String(Date().ticks) + "." + self.videoUrl.pathExtension
            filename = getDocumentsDirectory().appendingPathComponent( filenameOnly )
            try? data?.write(to: filename)
        }
        let insert = videos.insert(post <- Int64(self.postId) , captions <- self.caption ,localUrl <- filenameOnly, url <- serverUrl, thumbnail <- serverUrlThumbnail, videoUploadStatus <- 0)
        do {
            try db.run(insert)
        }
        catch {
            print("ERROR FOUND");
        }
    }
    func getAll(postNo:Int64) -> [PostVideo] {
        var all:[PostVideo] = []
        do {
            let id = Expression<Int64>("id")
            let post = Expression<Int64>("post")
            let captions = Expression<String>("caption")
            let localUrl = Expression<String>("localUrl")
            let url = Expression<String>("url")
            
            let query = videos.select(id,post,captions,localUrl,url,thumbnail)
                .filter(post == postNo)
            for video in try db.prepare(query) {
                let p = PostVideo();
                p.caption = String(video[captions])
                p.serverUrl = String(video[url])
                p.localURL = getDocumentsDirectory().appendingPathComponent( String(video[localUrl]) ).absoluteString
                p.serverUrlThumbnail = String(video[thumbnail])
                p.imageUrl = getDocumentsDirectory().appendingPathComponent( video[localUrl] )
                all.append(p)
            }
            
        }
        catch {
            
        }
        return all
    }
    
    func uploadVideo() {
        print(" ******* videoCheck 1")
        do {
            var check = false
            var query: QueryType!
            
            if currentUploadingPostID == Int64(0) {
                print("\n if succeed")
                query = videos.select(id,post,captions,localUrl,url)
                    .filter(url == "" && (videoUploadStatus == 0 || videoUploadStatus == 3))
                    .limit(1)                    
            }
            else {
                print("\n else succeed")
                query = videos.select(id,post,captions,localUrl,url)
                    .filter(url == "" && (videoUploadStatus == 0 || videoUploadStatus == 3) && (post == currentUploadingPostID))
                    .limit(1)
            }
            
            for photo in try db.prepare(query) {
                print(" ******* videoCheck 2")
                
                self.updateStatus(videoID: photo[id], status: (isNetworkReachable ? uploadStatus.UPLOAD_IN_PROGRESS : uploadStatus.UPLOAD_PENDING), urlString: "", thumbnailStr: "")
                check = true
                uploadFlag = true
                let url = getDocumentsDirectory().appendingPathComponent( String(photo[localUrl]) )
                request.uploadPhotos(url, localDbId: 0,completion: {(response) in
                    if response.error != nil {
                        print("response: \(response.error?.localizedDescription)")
                        self.updateStatus(videoID: photo[self.id], status: uploadStatus.UPLOAD_FAILED, urlString: "", thumbnailStr: "")                        
                    }
                    else if response["value"].bool! {                        
                        print(response)
                        self.updateStatus(videoID: photo[self.id], status: uploadStatus.UPLOAD_COMPLETE, urlString: response["data"][0]["name"].stringValue, thumbnailStr: response["data"][0]["thumbnail"].stringValue)                        
                    }
                    else {
                        self.updateStatus(videoID: photo[self.id], status: uploadStatus.UPLOAD_FAILED, urlString: "", thumbnailStr: "")
                        print("response error")
                    }
                    print(" ******* videoCheck 3")
                    self.uploadVideo()
                })
            }
            
            if(!check) {
                print(" ******* videoCheck 4")
                let po = Post();
                po.uploadPost();
            }
        }
        catch {
            print(error);
            print(" ******* videoCheck 5")
        }
        
    }
    
    func updateStatus(videoID: Int64, status: uploadStatus, urlString: String, thumbnailStr: String) {
        print("\n videoID : \(videoID) urlString: \(urlString)")
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
        
        let updaterow = self.videos.filter(self.id == videoID)
        do {
            try self.db.run(updaterow.update(self.videoUploadStatus <- Int64(toStatus), url <- urlString, self.thumbnail <- thumbnailStr)) 
        }
        catch {
            print("\n VIDEO update error FOUND")
        }
        
    }
    
    func delete(_ post:Int64) {
        do {
            let query = self.videos.filter(self.post == post)
            try db.run(query.delete())
        }
        catch {
        }
        
    }
    
    func parseJson() -> JSON {
        
        var photoJson:JSON = ["name":self.serverUrl,"caption":self.caption,"thumbnail":self.serverUrlThumbnail,"localUrl":self.localURL]
        if(self.editId != "") {
            photoJson["_id"] = JSON(self.editId)
        }
        print(photoJson);
        return photoJson
    }
    
    func rollbackVideoTableProgress() {
        do {
            
            let query = videos.select(id,post,captions,localUrl,url)
                .filter(url == "" && (videoUploadStatus == 1))
            
            for photo in try db.prepare(query) {
                self.updateStatus(videoID: photo[self.id], status: uploadStatus.UPLOAD_FAILED, urlString: "", thumbnailStr: "")
            }
        }
        catch {
            print(error);
        }
    }
    
    func dropVideoTable() {
        try! db.run(videos.drop(ifExists: true))
    }
    
    
}

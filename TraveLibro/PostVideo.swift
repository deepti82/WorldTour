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
    
    init() {
        do {
            try db.run(videos.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(post)
                t.column(captions)
                t.column(localUrl)
                t.column(url)
                t.column(thumbnail)
            })
        }
        catch {
            print("There was error in the system");
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func save() {
        var filename:URL!
        var filenameOnly = "";

        print(self.caption);
        let data = NSData(contentsOf: self.videoUrl)
        do {
            filenameOnly = String(Date().ticks) + "." + self.videoUrl.pathExtension
            filename = getDocumentsDirectory().appendingPathComponent( filenameOnly )
            try? data?.write(to: filename)
        }
        let insert = videos.insert(post <- Int64(self.postId) , captions <- self.caption ,localUrl <- filenameOnly,url <- "",thumbnail <- "")
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
    
    func upload() {
        do {
            var check = false;
            let query = videos.select(id,post,captions,localUrl,url)
                .filter(url == "")
                .limit(1)
            for photo in try db.prepare(query) {
                check = true;
                let url = getDocumentsDirectory().appendingPathComponent( String(photo[localUrl]) )
                request.uploadPhotos(url, localDbId: 0,completion: {(response) in
                    if response.error != nil {
                        print("response: \(response.error?.localizedDescription)")
                    }
                    else if response["value"].bool! {
                        do {
                            print(response)
                            let singlePhoto = self.videos.filter(self.id == photo[self.id])
                            let urlString = response["data"][0]["name"].stringValue
                            let urlthumbString = response["data"][0]["thumbnail"].stringValue
                            try db.run(singlePhoto.update(self.url <- urlString, self.thumbnail <- urlthumbString ))
                        }
                        catch {
                            
                        }
                        if(check) {
                            self.upload()
                        }
                    }
                    else {
                        print("response error")
                    }
                })
            }
            if(!check) {
                let po = Post();
                po.uploadPost();
            }
        }
        catch {
            print(error);
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
        print(self.serverUrl)
        print(self.caption)
        print(self.serverUrlThumbnail)
        var photoJson:JSON = ["name":self.serverUrl,"caption":self.caption,"thumbnail":self.serverUrlThumbnail,"localUrl":self.localURL]
        if(self.editId != "") {
            photoJson["_id"] = JSON(self.editId)
        }
        print(photoJson);
        return photoJson
    }
}

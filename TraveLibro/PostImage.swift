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

public class PostImage {
    var imageUrl: URL!
    var image = UIImage()
    var caption = ""
    var postId = 0
    var serverUrl = ""
    
    let photos = Table("Photos")
    
    let id = Expression<Int64>("id")
    let post = Expression<Int64>("post")
    let captions = Expression<String>("caption")
    let localUrl = Expression<String>("localUrl")
    let url = Expression<String>("url")
    
    init() {
        do {
            try db.run(photos.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(post)
                t.column(captions)
                t.column(localUrl)
                t.column(url)
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
        if let data = UIImageJPEGRepresentation(self.image, 0.8) {
            filenameOnly = String(Date().ticks) + ".jpg"
            filename = getDocumentsDirectory().appendingPathComponent( filenameOnly )
            try? data.write(to: filename)
        }
        let insert = photos.insert(post <- Int64(self.postId) , captions <- self.caption ,localUrl <- filenameOnly,url <- "")
        do {
            try db.run(insert)
        }
        catch {
            print("ERROR FOUND");
        }
    }
    func getAllImages(postNo:Int64) -> [PostImage] {
        var allImages:[PostImage] = []
        do {
            let id = Expression<Int64>("id")
            let post = Expression<Int64>("post")
            let captions = Expression<String>("caption")
            let localUrl = Expression<String>("localUrl")
            let url = Expression<String>("url")
            
            let query = photos.select(id,post,captions,localUrl,url)
                .filter(post == postNo)
            for photo in try db.prepare(query) {
                let p = PostImage();
                p.caption = String(photo[captions])
                p.serverUrl = String(photo[url])
                p.imageUrl = URL(fileURLWithPath: String(photo[localUrl]))
                allImages.append(p)
            }
        }
        catch {
        }
        return allImages
    }
    
    func uploadPhotos() {
        do {
            var check = false;
            let query = photos.select(id,post,captions,localUrl,url)
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
                            let singlePhoto = self.photos.filter(self.id == photo[self.id])
                            let urlString = response["data"][0].stringValue
                            try db.run(singlePhoto.update(self.url <- urlString ))
                        }
                        catch {
                            
                        }
                        if(check) {
                            self.uploadPhotos()
                        }
                    }
                    else {
                        print("response error")
                    }
                })
            }
            if(!check) {
                let po = Post();
                po.uploadPost()
            }
        }
        catch {
        }
        
    }
    func parseJson() -> JSON {
        let photoJson:JSON = ["name":self.url,"caption":self.serverUrl]
        return photoJson
    }
}


extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

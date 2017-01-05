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
    var image:UIImage!
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
    
    func urlToData(_ str:String) {
        self.serverUrl = adminUrl + "upload/readFile?file=" + str
        self.imageUrl = URL(string: self.serverUrl)
        cache.fetch(URL: URL(string:self.serverUrl)!).onSuccess({ (data) in
            self.image = UIImage(data: data as Data)
        })
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func save() {
        var filename:URL!
        var filenameOnly = "";
        self.image = self.image.resizeWith(width: 800.0)
        if let data = UIImageJPEGRepresentation(self.image, 0.5) {
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
                p.imageUrl = getDocumentsDirectory().appendingPathComponent( photo[localUrl] )
                var imageData = NSData(contentsOf: p.imageUrl)
                p.image = UIImage(data: imageData as! Data)!
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
                po.uploadPost();
            }
        }
        catch {
            print(error);
        }
        
    }
    
    func deletePhotos(_ post:Int64) {
        do {
            let query = self.photos.filter(self.post == post)
            try db.run(query.delete())
        }
        catch {
        }
        
    }
    
    func parseJson() -> JSON {
        let photoJson:JSON = ["name":self.serverUrl,"caption":self.caption]
        return photoJson
    }
}


extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}



extension UIImage {
    func resizeWith(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}

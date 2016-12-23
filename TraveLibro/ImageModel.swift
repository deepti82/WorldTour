//
//  ImageModel.swift
//  TraveLibro
//
//  Created by Chintan Shah on 20/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//
import Foundation
import SQLite

public class PostImage {
    var imageUrl: URL!
    var image = UIImage()
    var caption = ""
    var postId = 0
    
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
    
    func saveImage() {
        var filename:URL!
        
        if let data = UIImageJPEGRepresentation(self.image, 0.8) {
            filename = getDocumentsDirectory().appendingPathComponent( String(Date().ticks) + ".jpg" )
            try? data.write(to: filename)
        }
        let insert = photos.insert(post <- Int64(self.postId) , captions <- self.caption ,localUrl <- filename.absoluteString,url <- "")
        do {
            try db.run(insert)
        }
        catch {
            print("ERROR FOUND");
        }
    }
}


extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

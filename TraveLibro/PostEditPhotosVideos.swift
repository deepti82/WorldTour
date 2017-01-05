//
//  PostModel.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 10/18/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import Foundation
import SQLite

public class PostEditPhotosVideos {
    
    let addPhotosVideos_db = Table("AddPhotosVideos")
    
    let id_db = Expression<Int64>("id")
    let uniqueId_db = Expression<String>("uniqueId")
    
    init() {
        try! db.run(addPhotosVideos_db.create(ifNotExists: true) { t in
            t.column(id_db, primaryKey: true)
            t.column(uniqueId_db)
        })
    }
    
    func saveAddPhotosVideos(uniqueId:String,imageArr:[PostImage]) {
        let photoinsert = self.addPhotosVideos_db.insert(
            self.uniqueId_db <- uniqueId
        )
        do {
            let postId = try db.run(photoinsert)
            for image in imageArr {
                image.postId = Int(postId) + 10000
                image.save()
            }
        } catch _ {
            print("ERROR OCCURED");
        }
    }
    
    
    func uploadPostPhotosVideos() {
        do {
            var check = false;
            let query = addPhotosVideos_db.select(id_db,uniqueId_db)
                .limit(1)
            for post in try db.prepare(query) {
                check = true
                let str = String(post[uniqueId_db])
                var params:JSON = [ "uniqueId" : str,"type": "addPhotosVideos" ]
                let actualId = Int(post[id_db]) + 10000
                
                let i = PostImage();
                let imageArr:[PostImage] = i.getAllImages(postNo: Int64(actualId))
                
                var photosJson:[JSON] = []
                
                for img in imageArr {
                    photosJson.append(img.parseJson())
                }
                
                params["photosArr"] = JSON(photosJson)

                request.postAddPhotosVideos(param: params, completion: {(response) in
                    if response.error != nil {
                        print("response: \(response.error?.localizedDescription)")
                    }
                    else if response["value"].bool! {
                        do {
                            let singlePhoto = self.addPhotosVideos_db.filter(self.id_db == post[self.id_db])
                            try db.run(singlePhoto.delete())
                            i.deletePhotos(Int64(actualId));
                        }
                        catch {
                            
                        }
                        if(check) {
                            self.uploadPostPhotosVideos()
                        }
                    }
                    else {
                        print("response error")
                    }
                })
            }
            if(!check) {
                if globalNewTLViewController != nil {
                    globalNewTLViewController.getJourney()
                }
            }
        }
        catch {
            print("There is an error");
        }
    }
}



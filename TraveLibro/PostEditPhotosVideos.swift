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
    
    let db = TLModelManager.getSharedManager().db!
    
    var buddyJson:[JSON] = []
    
    let addPhotosVideos_db = Table("AddPhotosVideos")
    
    let id_db = Expression<Int64>("id")
    let uniqueId_db = Expression<String>("uniqueId")
    let buddyDb = Expression<String>("buddyDb")
    let postEditUploadStatus = Expression<Int64>("uploadStatus")
    
    init() {
        try! db.run(addPhotosVideos_db.create(ifNotExists: true) { t in
            t.column(id_db, primaryKey: true)
            t.column(uniqueId_db)
            t.column(buddyDb)
            t.column(postEditUploadStatus)
        })
    }
    
    func saveAddPhotosVideos(uniqueId:String,imageArr:[PostImage],buddy:String) {
        let photoinsert = self.addPhotosVideos_db.insert(
            self.uniqueId_db <- uniqueId,
            self.buddyDb <- buddy,
            self.postEditUploadStatus <- 0
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
            
            print("in in in ininin")
            print(" ******* postPhotoVideoCheck 1")
            
            var check = false;
            let query = addPhotosVideos_db.select(id_db,uniqueId_db,buddyDb)
                .filter(postEditUploadStatus == 0 || postEditUploadStatus == 3)
                .limit(1)
            
            for post in try db.prepare(query) {
                
                print(" ******* postPhotoVideoCheck 2")
                
                self.updateStatus(postID: post[self.id_db], status: uploadStatus.UPLOAD_IN_PROGRESS)
                
                check = true
                let str = String(post[uniqueId_db])
                var params:JSON = [ "uniqueId" : str!, "type": "addPhotosVideos","user": currentUser["_id"].stringValue]
                let actualId = Int(post[id_db]) + 10000
                
                let i = PostImage();
                let imageArr:[PostImage] = i.getAllImages(postNo: Int64(actualId))
                
                var photosJson:[JSON] = []
                
                for img in imageArr {
                    photosJson.append(img.parseJson())
                }
                
                params["photosArr"] = JSON(photosJson)
                let buddyStr = String(post[buddyDb])

                if let data = buddyStr?.data(using: String.Encoding.utf8) {
                    params["buddies"] = JSON(data:data)
                }
                
                request.editPost(param: params, completion: {(response) in
                    if response.error != nil {
                        print("response: \(response.error?.localizedDescription)")
                        self.updateStatus(postID: post[self.id_db], status: uploadStatus.UPLOAD_FAILED)
                    }
                    else if response["value"].bool! {
                        do {
                            self.updateStatus(postID: post[self.id_db], status: uploadStatus.UPLOAD_COMPLETE)
                            
                            let singlePhoto = self.addPhotosVideos_db.filter(self.id_db == post[self.id_db])
                            try self.db.run(singlePhoto.delete())
                            i.deletePhotos(Int64(actualId));
                        }
                        catch {
                            
                        }
                    }
                    else {
                        print("response error")
                        self.updateStatus(postID: post[self.id_db], status: uploadStatus.UPLOAD_FAILED)
                    }
                    print(" ******* postPhotoVideoCheck 3")
                    isUploadingInProgress = false
                    let i = PostImage()
                    i.uploadPhotos(delegate: nil)
                })
            }
            if(!check) {
                print(" ******* postPhotoVideoCheck 4")
                let po = LocalLifePostModel();
                po.uploadPost()
            }
        }
        catch {
            print(" ******* postPhotoVideoCheck 5")
            print("There is an error");
        }
    }
    
    func updateStatus(postID: Int64, status: uploadStatus) {
        print("\n photoId : \(postID)")
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
        
        let updaterow = self.addPhotosVideos_db.filter(self.id_db == postID)
        do {
            try self.db.run(updaterow.update(self.postEditUploadStatus <- Int64(toStatus))) 
        }
        catch {
            print("\n PostEditPhotoVideo update error FOUND")
        }
        
    }
    
}



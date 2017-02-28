//
//  PostModel.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 10/18/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import Foundation
import SQLite

public class QuickItinerary {
    
    let post = Table("QuickItinerary")
    var jsonPost:JSON!
    var imageArr:[PostImage] = []
    var loader = LoadingOverlay()
    let id = Expression<Int64>("id")
    let quickJson = Expression<String>("quickJson")
    let status = Expression<Bool>("status")
    
    init() {
        try! db.run(post.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(quickJson)
            t.column(status)
        })
    }
    
    func save(_ quickItinerary:JSON,imageArr:[PostImage],statusVal:Bool) {
        let photoinsert = self.post.insert(
            self.quickJson <- quickItinerary.rawString()!,
            self.status <- statusVal
        )
        do {
            let postId = try db.run(photoinsert)
            let actualId = Int(postId) + 30000
            for image in imageArr {
                image.postId = Int(actualId)
                image.save()
            }
        } catch _ {
            print("ERROR OCCURED");
        }
    }
    
    func getAll() -> [JSON] {
        var retVal:[JSON] = []
        
        do {
            var check = false;
            let query = post.select(id,quickJson,status)
            for post1 in try db.prepare(query) {
                check = true
                let p = LocalLifePostModel();
                
                var postID = post1[id]
                
                let id_temp = Int(post1[id])
                var quickItinery:JSON = JSON(data: (String(post1[quickJson])?.data(using: .utf8))! )
                let status_temp = Bool(post1[status])
                
                let actualId = Int(post1[id]) + 30000
                
                let i = PostImage();
                p.imageArr = i.getAllImages(postNo: Int64(actualId))
                
                var photosJson:[JSON] = []
                
                for img in p.imageArr {
                    photosJson.append(img.parseJson())
                }
                quickItinery["type"] = JSON("quick-itinerary");
                quickItinery["photos"] = JSON(photosJson)
                retVal.append(quickItinery)

            }
        }
        catch {
            print("There is an error");
        }

        
        return retVal
    }
    
    func getOne() {
        
    }
    
    func upload() {
        do {
            var check = false;
            let query = post.select(id,quickJson,status)
                .limit(1)
            for post1 in try db.prepare(query) {
                check = true
                let p = LocalLifePostModel();
                
                var postID = post1[id]
                
                let id_temp = Int(post1[id])
                let quickItinery:JSON = JSON(data: (String(post1[quickJson])?.data(using: .utf8))! )
                let status_temp = Bool(post1[status])
                
                let actualId = Int(post1[id]) + 30000
                
                let i = PostImage();
                p.imageArr = i.getAllImages(postNo: Int64(actualId))
                
                var photosJson:[JSON] = []
                
                for img in p.imageArr {
                    photosJson.append(img.parseJson())
                }
                
                request.postQuickitenary(title: quickItinery["title"].stringValue, year: quickItinery["year"].int!, month: quickItinery["month"].stringValue, duration:quickItinery["duration"].int!, description:quickItinery["description"].stringValue, itineraryType:quickItinery["itineraryType"], countryVisited:quickItinery["countryVisited"],photos:photosJson,status:status_temp,  completion: {(response) in
                    if response.error != nil {
                        print("response: \(response.error?.localizedDescription)")
                    }
                    else if response["value"].bool! {
                        do {
                            let singlePhoto = self.post.filter(self.id == postID)
                            try db.run(singlePhoto.delete())
                            i.deletePhotos(Int64(actualId));
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

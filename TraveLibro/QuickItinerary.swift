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
    
    let db = TLModelManager.getSharedManager().db!
    
    let post = Table("QuickItinerary")
    var jsonPost:JSON!
    var imageArr:[PostImage] = []
    var loader = LoadingOverlay()
    let id = Expression<Int64>("id")
    let quickJson = Expression<String>("quickJson")
    let status = Expression<Bool>("status")
    let editId = Expression<String>("editId")
    let QIUploadStatus = Expression<Int64>("uploadStatus")

    
    init() {
        try! db.run(post.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(quickJson)
            t.column(status)
            t.column(editId)
            t.column(QIUploadStatus)
        })
    }
    
    func save(_ quickItinerary:JSON,imageArr:[PostImage],statusVal:Bool) {
        print("save clicked")
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
    func save(_ quickItinerary:JSON,imageArr:[PostImage],statusVal:Bool,oldId:String) {
        print("save clicked")
        quickItinery["status"] = JSON(statusVal)
        
        let photoinsert = self.post.insert(
            self.quickJson <- quickItinerary.rawString()!,
            self.status <- statusVal,
            self.editId <- oldId,
            self.QIUploadStatus <- 0
        )
        do {
            let postId = try db.run(photoinsert)
            let actualId = Int(postId) + 30000
            print(imageArr);
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
            let query = post.select(id,quickJson,status,editId)
            for post1 in try db.prepare(query) {
            
                let p = LocalLifePostModel();
                
                var quickItineryL:JSON = JSON(data: (String(post1[quickJson])?.data(using: .utf8))! )
                
                let actualId = Int(post1[id]) + 30000
                
                let i = PostImage();
                p.imageArr = i.getAllImages(postNo: Int64(actualId))
                
                var photosJson:[JSON] = []
                
                for img in p.imageArr {
                    photosJson.append(img.parseJson())
                }
                quickItineryL["type"] = JSON("quick-itinerary");
                quickItineryL["photos"] = JSON(photosJson)
                retVal.append(quickItineryL)

            }
        }
        catch {
            print("There is an error");
        }

        
        return retVal
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
            try self.db.run(updaterow.update(self.id <- Int64(toStatus))) 
        }
        catch {
            print("\n QI update error FOUND")
        }
        
    }
    
    func upload() {
        
        print("\n Final upload completes")
        
        do {
            var check = false;
            
            var query: QueryType!
            
            if currentUploadingPostID == Int64(0) {
                print("\n if succeed")
                query = post.select(id,quickJson,status,editId)
                    .filter(QIUploadStatus == 0 || QIUploadStatus == 3)
                    .limit(1)                   
            }
            else {
                print("\n else succeed")
                query = post.select(id,quickJson,status,editId)
                    .filter((QIUploadStatus == 0 || QIUploadStatus == 3) && (id == currentUploadingPostID))
                    .limit(1)
            }
            
            for post1 in try db.prepare(query) {
                check = true
                
                self.updateStatus(postId: post1[id], status: (isNetworkReachable ? uploadStatus.UPLOAD_IN_PROGRESS : uploadStatus.UPLOAD_PENDING))
                
                let p = LocalLifePostModel();
                
                let postID = post1[id]
                
                let quickItineryL:JSON = JSON(data: (String(post1[quickJson])?.data(using: .utf8))! )
                let editid_temp = String(post1[editId])
                let status_temp = Bool(post1[status])
                
                let actualId = Int(post1[id]) + 30000
                
                let i = PostImage();
                p.imageArr = i.getAllImages(postNo: Int64(actualId))
                
                var photosJson:[JSON] = []
                
                for img in p.imageArr {
                    photosJson.append(img.parseJson())
                }
                
                request.postQuickitenary(title: quickItineryL["title"].stringValue, year: quickItineryL["year"].int!, month: quickItineryL["month"].stringValue, duration:quickItineryL["duration"].int!, description:quickItineryL["description"].stringValue, itineraryType:quickItineryL["itineraryType"], countryVisited:quickItineryL["countryVisited"],photos:photosJson,status:status_temp,editId:editid_temp!,  completion: {(response) in                    
                    if response.error != nil {
                        print("response: \(response.error?.localizedDescription)")
                        self.updateStatus(postId: post1[self.id], status: uploadStatus.UPLOAD_FAILED)
                    }
                    else if response["value"].bool! {
                        do {
                            let singlePhoto = self.post.filter(self.id == postID)
                            try self.db.run(singlePhoto.delete())
                            i.deletePhotos(Int64(actualId));                            
                        }
                        catch {
                            
                        }
                        if(check) {
                            self.upload()
                        }
                        self.updateStatus(postId: post1[self.id], status: uploadStatus.UPLOAD_COMPLETE)
                    }
                    else {
                        print("response error")
                        self.updateStatus(postId: post1[self.id], status: uploadStatus.UPLOAD_FAILED)
                    }
                    
                })
            }
            
            print("\n UploadFlag :::: \(uploadFlag)")
            if(!check && (uploadFlag == true)) {
                if globalNewTLViewController != nil {
                    if (globalNewTLViewController?.isSelfJourney(journeyID: (globalNewTLViewController?.fromOutSide)!, creatorId: (globalNewTLViewController?.journeyCreator)!))! {
                        globalNewTLViewController?.fetchJourneyData(false)
                    }
                    else {
                        request.getJourney(user.getExistingUser(), canGetCachedData: false, completion: {(response, isFromCache) in
                            //This call is just to update cached data
                        })
                        if ((!isSelfUser(otherUserID: currentUser["_id"].stringValue))) {
                            globalNewTLViewController?.fetchJourneyData(false)
                        }
                    }
                }
                else {
                    request.getJourney(user.getExistingUser(), canGetCachedData: false, completion: {(response, isFromCache) in
                        //This call is just to update cached data
                    })
                }
                if globalTLMainFeedsViewController != nil {                    
                        globalTLMainFeedsViewController.getDataMain()
                }
                
                isUploadingInProgress = false
                currentUploadingPostID = Int64(0)
                uploadFlag = false
                (UIApplication.shared.delegate as! AppDelegate).startUploadingPostInBackground()
            }
            else if (!check) {
                isUploadingInProgress = false
                currentUploadingPostID = Int64(0)
                uploadFlag = false
            }
        }
        catch {
            print("There is an error");
        }
    }    
    
    func rollbackItineraryTableProgress() {
        do {
            let query = post.select(id,quickJson,status,editId)
                .filter(QIUploadStatus == 1)
                
            
            for post in try db.prepare(query) {
                self.updateStatus(postId: post[self.id], status: uploadStatus.UPLOAD_FAILED)
            }
        }
        catch {
            print(error);
        }
    }
    
    func dropQITable() {
        try! db.run(post.drop(ifExists: true))
    }
}

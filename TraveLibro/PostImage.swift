import Foundation
import SQLite
import Haneke

// Post Image PostID Prefix Sum
// OTG NewPost - "0"
// EditOtgPost - NO OFFLINE
// AddPhotosAndVideos - "10000"
// LocalLife - "20000"
// QuickItinerary - "30000"

protocol TLUploadDelegate {
    func postUploadedSuccessfully()
}

public class PostImage {
    
    let db = TLModelManager.getSharedManager().db!
    
    private var delegate: TLUploadDelegate?
    
    var imageUrl: URL!
    var image:UIImage!
    var caption = ""
    var postId = 0
    var serverUrl = ""
    var editId = ""
    var stripServerURL = "";
    var isLoopingRequest = false
    
    let photos = Table("Photos")
    
    let id = Expression<Int64>("id")
    let post = Expression<Int64>("post")
    let captions = Expression<String>("caption")
    let localUrl = Expression<String>("localUrl")
    let url = Expression<String>("url")
    let editIdTable = Expression<String>("editIdTable")
    let photoUploadStatus = Expression<Int64>("uploadStatus")
    
    init() {
        do {
            try db.run(photos.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(post)
                t.column(captions)
                t.column(localUrl)
                t.column(url)
                t.column(editIdTable)
                t.column(photoUploadStatus)
            })
        }
        catch {
            print("There was error in the system");
        }
        
    }
    
    func urlToData(_ str:String) {
        self.serverUrl = adminUrl + "upload/readFile?file=" + str
        self.stripServerURL = str;
        self.imageUrl = URL(string: self.serverUrl)
        cache.fetch(URL: URL(string:self.serverUrl + "&width=200")!).onSuccess({ (data) in
            self.image = UIImage(data: data as Data)
        })
    }
    
    func urlToData(_ str:String,serverID:String) {
        self.serverUrl = adminUrl + "upload/readFile?file=" + str
        self.imageUrl = URL(string: self.serverUrl)
        self.editId = serverID;
        cache.fetch(URL: URL(string:self.serverUrl + "&width=200")!).onSuccess({ (data) in
            self.image = UIImage(data: data as Data)
        })
    }
    
    func save() {
        var filename:URL!
        var filenameOnly = "";
        if(self.serverUrl != "") {
            self.image = self.image.resizeWith(width: 800.0)
        }
        if let data = UIImageJPEGRepresentation(self.image, 0.5) {
            filenameOnly = String(Date().ticks) + ".jpg"
            filename = getDocumentsDirectory().appendingPathComponent( filenameOnly )
            try? data.write(to: filename)
        }
        
        let insert = photos.insert(post <- Int64(self.postId) , captions <- self.caption ,localUrl <- filenameOnly,url <- stripServerURL, editIdTable <- self.editId, photoUploadStatus <- 0)
        do {
            try db.run(insert)
        }
        catch {
            print("ERROR FOUND");
        }
    }
    
    func updateStatus(photoId: Int64, status: uploadStatus, urlString: String) {
        print("\n photoId : \(photoId) urlString: \(urlString)")
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
        
        let updaterow = self.photos.filter(self.id == photoId)
        do {
            try self.db.run(updaterow.update(self.photoUploadStatus <- Int64(toStatus), url <- urlString)) 
        }
        catch {
            print("\n PHOTO update error FOUND")
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
            
            let query = photos.select(id,post,captions,localUrl,url,editIdTable)
                .filter(post == postNo)
            for photo in try db.prepare(query) {
                let p = PostImage();
                p.caption = String(photo[captions])
                p.serverUrl = String(photo[url])
                p.imageUrl = getDocumentsDirectory().appendingPathComponent( photo[localUrl] )
                p.editId = String(photo[editIdTable])
                let imageData = NSData(contentsOf: p.imageUrl)
                
                p.image = UIImage(data: imageData as! Data)!
                allImages.append(p)
            }
        }
        catch {
        }
        return allImages
    }
    
    func uploadPhotos(delegate: TLUploadDelegate?) {
        if delegate != nil {
            self.delegate = delegate
        }
        print("\n isLoopingRequest : \(self.isLoopingRequest)")
        
        if !isUploadingInProgress || isLoopingRequest {
            
            isUploadingInProgress = true
            isLoopingRequest = false
            
            print(" ******* check 1")
            do {
                var check = false;
                let query = photos.select(id,post,captions,localUrl,url)
                    .filter(url == "" && (photoUploadStatus == 0 || photoUploadStatus == 4))
                    .limit(1)
                
                for photo in try db.prepare(query) {
                    
                    print(" ******* check 2")
                    self.updateStatus(photoId: photo[id], status: uploadStatus.UPLOAD_IN_PROGRESS, urlString: "")                
                    
                    check = true;
                    let url = getDocumentsDirectory().appendingPathComponent( String(photo[localUrl]) )
                    request.uploadPhotos(url, localDbId: 0,completion: {(response) in
                        if response.error != nil {
                            print("response: \(response.error?.localizedDescription)")
                            self.updateStatus(photoId: photo[self.id], status: uploadStatus.UPLOAD_FAILED, urlString: "")
                        }
                        else if response["value"].bool! {
                            self.updateStatus(photoId: photo[self.id], status: uploadStatus.UPLOAD_COMPLETE, urlString: response["data"][0].stringValue)
                        }
                        else {
                            print("response error")
                            self.updateStatus(photoId: photo[self.id], status: uploadStatus.UPLOAD_FAILED, urlString: "")
                        }
                        print(" ******* check 3")
                        self.isLoopingRequest = true
                        self.uploadPhotos(delegate: self.delegate)
                    })
                }
                
                if(!check) {
                    print(" ******* check 4")
                    let video = PostVideo();
                    video.uploadVideo();
                }
            }
            catch {
                print(" ******* check 5")
                print(error);
            }            
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
        var photoJson:JSON = ["name":self.serverUrl,"caption":self.caption]
        if(self.editId != "") {
            photoJson["_id"] = JSON(self.editId)
        }
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

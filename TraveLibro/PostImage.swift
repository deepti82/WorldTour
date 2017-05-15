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
    
    private var delegate: TLUploadDelegate?
    
    var imageUrl: URL!
    var image:UIImage!
    var caption = ""
    var postId = 0
    var serverUrl = ""
    var editId = ""
    var stripServerURL = "";
    
    let photos = Table("Photos")
    
    let id = Expression<Int64>("id")
    let post = Expression<Int64>("post")
    let captions = Expression<String>("caption")
    let localUrl = Expression<String>("localUrl")
    let url = Expression<String>("url")
    let editIdTable = Expression<String>("editIdTable")
    
    init() {
        do {
            try db.run(photos.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(post)
                t.column(captions)
                t.column(localUrl)
                t.column(url)
                t.column(editIdTable)
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

    
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
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
        
        let insert = photos.insert(post <- Int64(self.postId) , captions <- self.caption ,localUrl <- filenameOnly,url <- stripServerURL,editIdTable <- self.editId)
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
                            self.uploadPhotos(delegate: self.delegate)
                        }
                    }
                    else {
                        print("response error")
                    }
                })
            }
            if(!check) {
                let video = PostVideo();
                video.upload();
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

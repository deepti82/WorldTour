import UIKit
import Spring
import Player

class SinglePhotoViewController: UIViewController,PlayerDelegate {

    var player:Player!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var imageCaption: UILabel!
    
    @IBOutlet weak var likeButton: SpringButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var likeIcon: UILabel!
    @IBOutlet weak var commentIcon: UIImageView!
    
    @IBOutlet weak var likeText: UILabel!
    @IBOutlet weak var commentText: UILabel!
    var type = "Image"
    var index: Int!
    var currentIndex: Int!
    var postId: String!
    var photos: [JSON]!
    var videos:[JSON]!
    var singlePost: JSON!
    var allDataFromMyLife: [JSON] = []
    var likeCount:Int = 0
    var commentCount:Int = 0
    var hasLiked: Bool!
    
    var whichView = ""
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.showOverlay(self.view)
        print("current post \(postId!) \(index!)")
        
        let leftButton = UIButton(frame: CGRect(x: 20, y: 30, width: 30, height: 30))
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.layer.zPosition = 100
        self.view.addSubview(leftButton)
        self.customNavigationBar(left: leftButton, right: UIButton())
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if(self.type == "Video") {
            self.title = "Video";
        } else {
            self.title = "Photo";
        }
        
        bottomView.isHidden = true
        mainImage.isHidden = true
        
        self.view.backgroundColor = UIColor.black
        bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        bottomView.layer.zPosition = 100
        mainImage.contentMode = .scaleAspectFit
        mainImage.isUserInteractionEnabled = true
        
        likeButton.imageView?.contentMode = .scaleAspectFit
        commentButton.imageView?.contentMode = .scaleAspectFit
        shareButton.imageView?.contentMode = .scaleAspectFit
        
        likeButton.tintColor = UIColor.white
        commentButton.tintColor = UIColor.white
        shareButton.tintColor = UIColor.white
        commentIcon.tintColor = UIColor.white
        likeText.textColor = UIColor.white
        commentText.textColor = UIColor.white
        
        likeIcon.text = String(format: "%C", faicon["likes"]!)
        
        likeText.text = "0 Likes"
        commentText.text = "0 Comments"
        
        currentIndex = index
        
        if whichView == "detail_itinerary" {
            getSinglePhoto(photos[index]["_id"].stringValue)
        }
        else {
            getPost(postId!)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        //imageCache = nil
    }
    
    @IBAction func sendLike(_ sender: UIButton) {
       likeButton.animation = "pop"
        likeButton.animateTo()
        
        if(self.type == "Video") {
            request.postVideoLike(videos[currentIndex!]["_id"].string!, postId: postId!, userId: currentUser["_id"].string!, userName: currentUser["name"].string!, unlike: hasLiked!, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    loader.hideOverlayView()
                    if response.error != nil {
                        
                        print("error: \(response.error!.localizedDescription)")
                        
                    }
                    else if response["value"].bool! {
                        
                        if !self.hasLiked! {
                            
                            sender.setImage(UIImage(named: "favorite-heart-button")?.withRenderingMode(.alwaysTemplate), for: UIControlState())
                            self.likeCount = Int(self.likeCount) + 1
                            self.likeText.text = "\(self.likeCount) Likes"
                            self.hasLiked = !self.hasLiked
                            
                        }
                        else {
                            
                            sender.setImage(UIImage(named: "likeButton"), for: UIControlState())
                            self.likeCount = Int(self.likeCount) - 1
                            self.likeText.text = "\(self.likeCount) Likes"
                            self.hasLiked = !self.hasLiked
                            
                        }
                        
                    }
                    else {
                        
                    }
                    
                })
                
            })
        }
        else {
            
            var val = ""
            if whichView == "detail_itinerary" {
                val = photos[currentIndex]["itinerary"].stringValue
            }
            else {
                val = postId
            }
            
            request.postPhotosLike(photos[currentIndex!]["_id"].string!, postId: val, userId: currentUser["_id"].string!, userName: currentUser["name"].string!, unlike: hasLiked!, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    loader.hideOverlayView()
                    if response.error != nil {
                        
                        print("error: \(response.error!.localizedDescription)")
                        
                    }
                    else if response["value"].bool! {
                        
                        if !self.hasLiked! {
                            
                            sender.setImage(UIImage(named: "favorite-heart-button")?.withRenderingMode(.alwaysTemplate), for: UIControlState())
                            self.likeCount = Int(self.likeCount) + 1
                            self.likeText.text = "\(self.likeCount) Likes"
                            self.hasLiked = !self.hasLiked
                            
                        }
                        else {
                            
                            sender.setImage(UIImage(named: "likeButton"), for: UIControlState())
                            self.likeCount = Int(self.likeCount) - 1
                            self.likeText.text = "\(self.likeCount) Likes"
                            self.hasLiked = !self.hasLiked
                            
                        }
                        
                    }
                    else {
                        
                    }
                    
                })
                
            })
        }
        
    }
    
    @IBAction func sendComment(_ sender: UIButton) {
        let comment = storyboard?.instantiateViewController(withIdentifier: "photoComment") as! PhotoCommentViewController
        comment.postId = (whichView == "detail_itinerary" ? photos[currentIndex]["itinerary"].stringValue : postId!)
        comment.commentText = self.commentText
        if singlePhotoJSON != nil {
            comment.otherId = singlePhotoJSON["name"].string!
            comment.photoId = singlePhotoJSON["_id"].string!
        }
        if(self.type == "Video") {
            comment.type = "Video"
        }
        //self.navigationController?.pushViewController(comment, animated: true)
        self.navigationController?.pushViewController(comment, animated: true)
    }
    
    override func popVC(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    func leftSwipe(_ sender: AnyObject) {
        currentIndex = Int(currentIndex) + 1
        print("in swipe left postid : \(postId) \(currentIndex)")
        if postId == "" {
            if currentIndex >= allDataFromMyLife.count {
                currentIndex = Int(currentIndex) - 1
            } else {
                self.getSinglePhoto("")
            }
        }else{
        if currentIndex >= photos.count {
            currentIndex = Int(currentIndex) - 1
        } else {		
            self.getSinglePhoto(photos[currentIndex!]["_id"].string!)
        }
        }
    }
    
    func rightSwipe(_ sender: AnyObject) {
        currentIndex = Int(currentIndex) - 1
        print("in swipe right postid : \(postId) \(currentIndex)")
        if postId == "" {
            if currentIndex < 0 {
                currentIndex = Int(currentIndex) + 1
            } else {
                
                self.getSinglePhoto("")
            }
        }else{
            if currentIndex < 0 {
                currentIndex = Int(currentIndex) + 1
            } else {
                print(photos)
                print(photos[currentIndex])
                self.getSinglePhoto(photos[currentIndex!]["_id"].string!)
            }
        }
    }
    
    func setPhotos(indexNumber:Int) {
        print("in indexed....  \(allDataFromMyLife[indexNumber])")
        self.mainImage.hnk_setImageFromURL(getImageURL(allDataFromMyLife[indexNumber]["name"].stringValue, width: 200))
        
        self.bottomView.isHidden = false
        self.mainImage.isHidden = false
        
        let imageLeftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.leftSwipe(_:)))
        let imageRightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.rightSwipe(_:)))
        
        imageLeftSwipe.direction = .left
        imageRightSwipe.direction = .right
        
        self.mainImage.addGestureRecognizer(imageLeftSwipe)
        self.mainImage.addGestureRecognizer(imageRightSwipe)
    }
    
    func getPost(_ postId: String) {
        
        print("in print print....... \(postId) index \(self.currentIndex)")
        if postId == "" {
            
            if allDataFromMyLife[self.currentIndex]["type"].stringValue == "video" {
                self.getSingleVideo("")
            } else {
                self.getSinglePhoto("")
            }
            
        } else {
            
        request.getOneJourneyPost(id: postId, completion: {(response) in
            DispatchQueue.main.async(execute: {
                loader.hideOverlayView()
                if response.error != nil {
                    
                    print("response: \(response.error?.localizedDescription)")
                    
                } else if response["value"].bool! {
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    self.singlePost = response["data"]
                    self.photos = response["data"]["photos"].array!
                    self.videos = response["data"]["videos"].array!
                    
                    if(self.type == "Video") {
                        
                        self.getSingleVideo(self.videos[0]["_id"].string!)
                        
                    } else {
                        
                        self.getSinglePhoto(self.photos[self.index!]["_id"].string!)
                        self.title = "Photos (\(self.photos.count))"
                        
                    }
                } else {
                    print("response error!")
                }
            })
            
        })
            
        }
    }
    
    var singlePhotoJSON: JSON!
    
    func fromPhotoFunction(data:JSON) {
        let mainImageString = "\(adminUrl)upload/readFile?file=\(data["name"].string!)"
        self.mainImage.hnk_setImageFromURL(NSURL(string:mainImageString) as! URL)
        
        if data["caption"].string != nil && data["caption"].string != "" {
            
            self.imageCaption.text = data["caption"].string!
        }
        
        if data["like"].array!.contains(JSON(user.getExistingUser())) {
            
            self.likeButton.setImage(UIImage(named: "favorite-heart-button")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.likeButton.tintColor = UIColor.white
            self.hasLiked = true
        } else {
            
            self.likeButton.setImage(UIImage(named: "likeButton"), for: .normal)
            self.hasLiked = false
        }
        
        if(data["likeCount"].int != nil) {
            self.likeCount = data["likeCount"].int!
            self.likeText.text = "\(self.likeCount) Like"
        }
        if(data["commentCount"].int != nil) {
            self.commentCount = data["commentCount"].int!
            self.commentText.text = "\(self.commentCount) Comment"
        }
        
        
        self.bottomView.isHidden = false
        self.mainImage.isHidden = false
        
        let imageLeftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.leftSwipe(_:)))
        let imageRightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.rightSwipe(_:)))
        
        imageLeftSwipe.direction = .left
        imageRightSwipe.direction = .right
        
        self.mainImage.addGestureRecognizer(imageLeftSwipe)
        self.mainImage.addGestureRecognizer(imageRightSwipe)
    }
    
    func fromVideoFunction(data:JSON) {
        let mainImageString = "\(adminUrl)upload/readFile?file=\(data["name"].string!)"
        self.mainImage.hnk_setImageFromURL(NSURL(string:mainImageString) as! URL)
        
        if data["caption"].string != nil && data["caption"].string != "" {
            self.imageCaption.text = data["caption"].string!
        }
        
        
        if (data["likeDone"].bool != nil && data["likeDone"].bool! ) {
            self.likeButton.setImage(UIImage(named: "favorite-heart-button")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.likeButton.tintColor = UIColor.white
            self.hasLiked = true
        }
        else {
            self.likeButton.setImage(UIImage(named: "likeButton"), for: .normal)
            self.hasLiked = false
        }
        
        if(data["likeCount"].int != nil) {
            self.likeCount = data["likeCount"].int!
            self.likeText.text = "\(self.likeCount) Like"
        }
        if(data["commentCount"].int != nil) {
            self.commentCount = data["commentCount"].int!
            self.commentText.text = "\(self.commentCount) Comment"
        }
        
        self.bottomView.isHidden = false
        self.mainImage.isHidden = false
        
        
        self.player = Player()
        self.player.delegate = self
        self.player.view.frame = self.mainImage.bounds
        self.player.view.clipsToBounds = true
        self.player.playbackLoops = true
        self.player.muted = true
        var videoUrl:URL!
        videoUrl = URL(string:data["name"].stringValue)
        self.player.setUrl(videoUrl!)
        self.mainImage.addSubview(self.player.view)
    }
    
    func getSinglePhoto(_ photoId: String) {
       loader.hideOverlayView()
        if photoId == "" {
            self.fromPhotoFunction(data: allDataFromMyLife[self.currentIndex])
        }else{
            print("singlePost \(singlePost)")
            var val = ""
            if whichView == "detail_itinerary" {
                val = currentUser["_id"].stringValue
            }
            else {
                val = singlePost["user"]["_id"].string!
            }
        request.getOnePostPhotos(photoId, val, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                loader.hideOverlayView()
                if response.error != nil {
                    print("response: \(response.error?.localizedDescription)")
                }
                    
                else if response["value"].bool! {
                    let data: JSON = response["data"]
                    self.singlePhotoJSON = response["data"]

                    self.fromPhotoFunction(data: data)
                    
                }
                    
                    
                else {
                    print("response error!")
                }
            })
            
        })
        }
    }
    
    func playerReady(_ player: Player) {
        self.player.playFromBeginning()
    }
    
    func getSingleVideo(_ photoId: String) {
        if photoId == "" {
            self.fromVideoFunction(data: allDataFromMyLife[self.currentIndex])
        }else{

        request.getOnePostVideos(photoId, singlePost["user"]["_id"].string!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                loader.hideOverlayView()
                if response.error != nil {
                    print("response: \(response.error?.localizedDescription)")
                }
                    
                else if response["value"].bool! {
                    let data: JSON = response["data"]
                    self.singlePhotoJSON = response["data"]
                    print(data);
                    self.fromVideoFunction(data: data)
                }
                    
                    
                else {
                    print("response error!")
                }
            })
            
        })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

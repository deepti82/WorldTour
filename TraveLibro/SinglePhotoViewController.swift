import UIKit
import Spring
import Player
import QuartzCore
import iCarousel

class SinglePhotoViewController: UIViewController,PlayerDelegate, iCarouselDelegate, iCarouselDataSource {

    var player:Player!
    
    var carouselView: iCarousel!
    
    var photoFooterReview: ActivityFeedFooter!
    var currentImageView : UIImageView!
    var loader: LoadingOverlay = LoadingOverlay()
    var bgImage: UIImageView!
    
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
    var previousIndex: Int!
    var postId: String!
    var photos: [JSON]!
    var videos:[JSON]!
    var singlePost: JSON!
    var allDataCollection: [JSON] = []
    var likeCount:Int = 0
    var commentCount:Int = 0
    var hasLiked: Bool!
    var carouselDict: NSMutableDictionary = [:]
    
    var whichView = ""
    var imageLeftSwipe: UISwipeGestureRecognizer!
    var imageRightSwipe: UISwipeGestureRecognizer!
    
    var isSpecialHandling = false
    var shouldShowBottomView = true
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.showOverlay(self.view)
        
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
        
        setBackgroundBlur()
        
        bottomView.isHidden = true
        
        self.view.backgroundColor = UIColor.black
        bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        bottomView.layer.zPosition = 100
        
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
        
        if postId == "" {
            photos = allDataCollection
            isSpecialHandling = true
            setCarouselDataDictForSpecialHandling()
        }
        
        
        carouselView = iCarousel(frame: mainImage.frame)        
        carouselView.isHidden = true
        carouselView.clipsToBounds = true	
        carouselView.isPagingEnabled = true
        carouselView.backgroundColor = UIColor.clear
        carouselView.bounces = false
        self.view.addSubview(carouselView)
        self.view.bringSubview(toFront: bottomView)
        
        imageLeftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.imageSwiped(_:)))
        imageRightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.imageSwiped(_:)))
        
        imageLeftSwipe.direction = .left
        imageRightSwipe.direction = .right
        
        
        if whichView == "detail_itinerary" {
            getSinglePhoto(photos[index]["_id"].stringValue)
        }
        else {
            getPost(postId!)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        carouselView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.view.frame.size.height)
        mainImage.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        carouselView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.view.frame.size.height - 5)
        print("carouselView.frame : \(carouselView.frame)")
        
        carouselView.type = iCarouselType.linear      //iCarouselTypeCylinder
        carouselView.delegate = self
        carouselView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Actions
    
    @IBAction func sendLike(_ sender: UIButton) {
       likeButton.animation = "pop"
        likeButton.animateTo()
            
            var val = ""
            if whichView == "detail_itinerary" {
                val = photos[carouselView.currentItemIndex]["_id"].string!
            }
            else {
                val = photos[carouselView.currentItemIndex]["_id"].string!
            }
            if self.type == "Video" {
                val = videos[carouselView.currentItemIndex]["_id"].string!
            }
            
            request.globalLike(val, userId: currentUser["_id"].string!, unlike: hasLiked!, type: self.type, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    self.loader.hideOverlayView()
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
                        
//                        var currentDict  = self.carouselDict.value(forKey: self.photos[self.carouselView.currentItemIndex]["_id"].string!) as! JSON                        
//                        currentDict["likeCount"] = JSON(self.likeCount)
//                        self.carouselDict.setObject(currentDict, forKey: (self.photos[self.carouselView.currentItemIndex]["_id"].stringValue) as NSCopying)
                    }
                    else {
                        
                    }
                    
                })
                
            })
        
    }
    
    @IBAction func sendComment(_ sender: UIButton) {
        let comment = storyboard?.instantiateViewController(withIdentifier: "photoComment") as! PhotoCommentViewController
        comment.postId = (whichView == "detail_itinerary" ? photos[carouselView.currentItemIndex]["itinerary"].stringValue : postId!)
        comment.commentText = self.commentText
        print("[[[[]]]] \(singlePhotoJSON)")
        if singlePhotoJSON != nil {
            comment.otherId = singlePhotoJSON["name"].string!
            comment.photoId = singlePhotoJSON["_id"].string!
        }
        if(self.type == "Video") {
            comment.type = "Video"
        }
        self.navigationController?.pushViewController(comment, animated: true)
    }
    
    
    //MARK: - Gesture methods
    func imageSwiped(_ sender: AnyObject?) {
        
        mainImage.isUserInteractionEnabled = false
        mainImage.isHidden = true
        carouselView.isHidden = false
    }
    
    func leftSwipe(_ sender: AnyObject?) {
        
        if sender != nil {
            self.mainImage.removeGestureRecognizer(imageLeftSwipe)
            self.mainImage.removeGestureRecognizer(imageRightSwipe)
        }
        
        var currentIndexCopy = Int(carouselView.currentItemIndex) + 1        
        if postId == "" {
            if currentIndexCopy >= allDataCollection.count {
                currentIndexCopy = Int(currentIndex) - 1
            } else {
                self.getPost("")
            }
        }else{
            if currentIndexCopy >= photos.count {
                currentIndexCopy = Int(currentIndexCopy) - 1
            } else {	
                if !(carouselDict.allKeys.contains(value: photos[currentIndexCopy]["_id"].string!)) {
                    print("in swipe left : \(carouselView.currentItemIndex) fetching : \(photos[currentIndexCopy]["_id"].string!)")
                    self.getSinglePhoto(photos[currentIndexCopy]["_id"].string!)
                }
            }
        }
    }
    
    func rightSwipe(_ sender: AnyObject?) {
        var currentIndexCopy = Int(carouselView.currentItemIndex) - 1
        if postId == "" {
            if currentIndexCopy < 0 {
                currentIndexCopy = Int(carouselView.currentItemIndex) + 1
            } else {
                
                self.getPost("")
            }
        }else{
            if currentIndexCopy < 0 {
                currentIndexCopy = Int(carouselView.currentItemIndex) + 1
            } else {
                if !(carouselDict.allKeys.contains(value: photos[currentIndexCopy]["_id"].string!)) {
                    print("in swipe right : \(carouselView.currentItemIndex) fetching : \(photos[currentIndexCopy]["_id"].string!)")
                    self.getSinglePhoto(photos[currentIndexCopy]["_id"].string!)
                }
            }
        }
    }
    
    
    //MARK:- Bottom View Updation
    
    func fromPhotoFunction(data:JSON) {
        
        if postId == "" {
            
            print("\n data : \(data)")
            
            if data["likeCount"].intValue > 0 {
                self.likeButton.setImage(UIImage(named: "favorite-heart-button")?.withRenderingMode(.alwaysTemplate), for: .normal)
                self.likeButton.tintColor = UIColor.white
                self.hasLiked = true
            } 
            else {
                self.likeButton.setImage(UIImage(named: "likeButton"), for: .normal)
                self.hasLiked = false
            }            
        }
        
        else {
            if data["caption"].string != nil && data["caption"].string != "" {            
                self.imageCaption.text = data["caption"].string!
            }
            
            if data["like"].array!.contains(JSON(user.getExistingUser())) {
                
                self.likeButton.setImage(UIImage(named: "favorite-heart-button")?.withRenderingMode(.alwaysTemplate), for: .normal)
                self.likeButton.tintColor = UIColor.white
                self.hasLiked = true
            } 
            else {
                
                self.likeButton.setImage(UIImage(named: "likeButton"), for: .normal)
                self.hasLiked = false
            }
        }
            
        if(data["likeCount"].int != nil) {
            self.likeCount = data["likeCount"].int!
            self.likeText.text = "\(self.likeCount) Like"
        }
        else{
            self.likeCount = 0
            self.likeText.text = "0 Like"
        }
        
        if(data["commentCount"].int != nil) {
            self.commentCount = data["commentCount"].int!
            self.commentText.text = "\(self.commentCount) Comment"
        }
        else{
            self.commentCount = 0
            self.commentText.text = "0 Comment"
        }
        
        if shouldShowBottomView {
            self.bottomView.isHidden = false            
        }
                
    }
    
    func fromVideoFunction(data:JSON) {
        let mainImageString = "\(adminUrl)upload/readFile?file=\(data["name"].string!)"
        self.mainImage.hnk_setImageFromURL(NSURL(string:mainImageString) as! URL)
        self.carouselView.isHidden = true
        self.mainImage.isHidden = false
        
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
        
        if shouldShowBottomView {
            self.bottomView.isHidden = false            
        }
        self.mainImage.isHidden = false
        
//        self.mainImage.addGestureRecognizer(imageLeftSwipe)
//        self.mainImage.addGestureRecognizer(imageRightSwipe)
//        
//        if !(mainImage.isUserInteractionEnabled) {
//            mainImage.isUserInteractionEnabled = true
//        }
        
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
    
    //MARK: - Play
    
    func playerReady(_ player: Player) {
        self.player.playFromBeginning()
    }
    
    
    //MARK: - Helper
    
    var singlePhotoJSON: JSON!
    
    func setCarouselDataDictForSpecialHandling() {
        
        for data in allDataCollection {
            carouselDict.setObject(data, forKey: data["_id"].stringValue as NSCopying)
        }
    }
    
    func getSingleVideo(_ photoId: String) {
        if photoId == "" {
            self.fromVideoFunction(data: allDataCollection[self.currentIndex])
        }else{

        request.getOnePostVideos(photoId, singlePost["user"]["_id"].string!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                self.loader.hideOverlayView()
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
    
    func getPost(_ postId: String) {
        
        print("in print print....... \(postId) index \(self.currentIndex)")
        if postId == "" {
            
//            if allDataCollection[self.currentIndex]["type"].stringValue == "video" {
//                self.getSingleVideo("")
//            } else {
//                self.getSinglePhoto("")
//            }
            
            if carouselView.isHidden {
                carouselView.isHidden = false
            }
            carouselView.currentItemIndex = index
            carouselView.reloadData()
            carouselView.scrollToItem(at: index, animated: true)
        }
            
        else {
            
            request.getOneJourneyPost(id: postId, completion: {(response) in
                DispatchQueue.main.async(execute: {
                    self.loader.hideOverlayView()
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
    
    func getSinglePhoto(_ photoId: String) {
        loader.hideOverlayView()
        if photoId == "" {
        }
        else{
            var val = ""
            if whichView == "detail_itinerary" {
                val = currentUser["_id"].stringValue
            }
            else {
                val = singlePost["user"]["_id"].string!
            }
            request.getOnePostPhotos(photoId, val, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    self.loader.hideOverlayView()
                    if response.error != nil {
                        print("response: \(response.error?.localizedDescription)")
                    }
                        
                    else if response["value"].bool! {
                        let data: JSON = response["data"]
                        self.carouselDict.setObject(data, forKey: photoId as NSCopying)
                        if self.carouselView.isHidden {
                            self.carouselView.isHidden = false
                            self.carouselView.currentItemIndex = self.index
                            self.carouselView.reloadData()
                            self.carouselView.scrollToItem(at: self.index, animated: true)
                        }
                        else{
                            self.carouselView.reloadData()
                        }
                        
                    }
                    else {
                        print("response error!")
                    }
                })
                
            })
        }
    }
    
    func loadMore() {
        if !isSpecialHandling {
            loadPreviousData()
            loadNextData()            
        }
    }
    
    func loadPreviousData() {
        rightSwipe(nil)
    }
    
    func loadNextData() {
        leftSwipe(nil)
    }
    
    
    //MARK: - Carousel Datasource and Delegates
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        
        if !carousel.isHidden {
            if photos != nil {
                return photos.count
            }
        }
        return 0
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        var shouldCreateView = false
        
        if view != nil {
            if(view?.tag == 999){
                currentImageView = view as! UIImageView
            }
            else{
                shouldCreateView = true
            }
        }
        else {
            shouldCreateView = true
        }
        
        let currentJson = photos[index]
        
        if shouldCreateView {
            currentImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: carousel.frame.size.width*0.80, height: carousel.frame.size.height*0.70))
            currentImageView.contentMode = .scaleAspectFill
            currentImageView.clipsToBounds = true
            currentImageView.backgroundColor = UIColor.clear
            currentImageView.tag = 999
            currentImageView.layer.borderColor = UIColor.lightGray.cgColor
            currentImageView.layer.borderWidth = 0.5
            currentImageView.layer.cornerRadius = 5.0
        }
        currentImageView.image = UIImage(named: "logo-default")
        
        if currentJson != nil {            
            currentImageView.hnk_setImageFromURL(getImageURL((currentJson["name"].stringValue), width: Int(carousel.frame.size.width*0.8)))
        }
        
        return currentImageView
    }   
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        
        if carousel.currentItemIndex != -1 {
            
            let key = photos[carousel.currentItemIndex]["_id"].string!
            let currentJson = carouselDict.value(forKey: key) as? JSON
            singlePhotoJSON = currentJson
            
            print("\n CurrentJSON : \(currentJson) key :\(key)  current index: \(carousel.currentItemIndex)")
            
            if currentJson != nil {
                self.fromPhotoFunction(data: currentJson! )
                bgImage.hnk_setImageFromURL(getImageURL((currentJson?["name"].stringValue)!, width: Int(carousel.frame.size.width*0.8)))
            }
            else{
                print("\n current JSON is nil")
                print("\n Carousal : \(carouselDict)")
            }
            
//            currentIndex = carousel.currentItemIndex
            self.loadMore()
        }
    }
    
    
    //MARK: - Blur effect
    
    func setBackgroundBlur() {
        
        bgImage = UIImageView(frame: self.view.frame)
        bgImage.layer.zPosition = -1
        bgImage.isUserInteractionEnabled = false
        self.view.addSubview(bgImage)
        self.view.sendSubview(toBack: bgImage)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bgImage.addSubview(blurEffectView)
    }
    
}

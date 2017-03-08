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
    var allDataFromMyLife: [JSON] = []
    var likeCount:Int = 0
    var commentCount:Int = 0
    var hasLiked: Bool!
    var carouselDict: NSMutableDictionary = [:]
    
    var whichView = ""
    var imageLeftSwipe: UISwipeGestureRecognizer!
    var imageRightSwipe: UISwipeGestureRecognizer!
    
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
        
        print("\n allDataFromMyLife : \(allDataFromMyLife) \n")
        if postId == "" {
            photos = allDataFromMyLife
        }
        
        carouselView = iCarousel(frame: mainImage.frame)
        carouselView.type = iCarouselType.linear      //iCarouselTypeCylinder
        carouselView.delegate = self
        carouselView.dataSource = self
        carouselView.isHidden = true
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
            print("\n\n PHOTOS::: \n\(photos) \n\n")
            getSinglePhoto(photos[currentIndex]["_id"].stringValue)
        }
        else {
            getPost(postId!)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        carouselView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        print("carouselView.frame : \(carouselView.frame)")
        mainImage.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Actions
    
    @IBAction func sendLike(_ sender: UIButton) {
       likeButton.animation = "pop"
        likeButton.animateTo()
        
        if(self.type == "Video") {
            request.postVideoLike(videos[currentIndex!]["_id"].string!, postId: postId!, userId: currentUser["_id"].string!, userName: currentUser["name"].string!, unlike: hasLiked!, completion: {(response) in
                
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
        
        var currentIndexCopy = Int(currentIndex) + 1        
        if postId == "" {
            if currentIndexCopy >= allDataFromMyLife.count {
                currentIndexCopy = Int(currentIndex) - 1
            } else {
                self.getPost("")
            }
        }else{
            if currentIndexCopy >= photos.count {
                currentIndexCopy = Int(currentIndexCopy) - 1
            } else {	
                if !(carouselDict.allKeys.contains(value: photos[currentIndexCopy]["_id"].string!)) {
                    print("in swipe left : \(currentIndex) fetching : \(photos[currentIndexCopy]["_id"].string!)")
                    self.getSinglePhoto(photos[currentIndexCopy]["_id"].string!)
                }
            }
        }
    }
    
    func rightSwipe(_ sender: AnyObject?) {
        var currentIndexCopy = Int(currentIndex) - 1
        if postId == "" {
            if currentIndexCopy < 0 {
                currentIndexCopy = Int(currentIndex) + 1
            } else {
                
                self.getPost("")
            }
        }else{
            if currentIndexCopy < 0 {
                currentIndexCopy = Int(currentIndex) + 1
            } else {
                if !(carouselDict.allKeys.contains(value: photos[currentIndexCopy]["_id"].string!)) {
                    print("in swipe right : \(currentIndex) fetching : \(photos[currentIndexCopy]["_id"].string!)")
                    self.getSinglePhoto(photos[currentIndexCopy]["_id"].string!)
                }
            }
        }
    }
    
    
    //MARK:- Bottom View Updation
    
    func fromPhotoFunction(data:JSON) {
        
        if postId == "" {
            
            print("\n data : \(data)")
            
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
        
        self.bottomView.isHidden = false        
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
        
        self.bottomView.isHidden = false
        self.mainImage.isHidden = false
        
        self.mainImage.addGestureRecognizer(imageLeftSwipe)
        self.mainImage.addGestureRecognizer(imageRightSwipe)
        
        if !(mainImage.isUserInteractionEnabled) {
            mainImage.isUserInteractionEnabled = true
        }
        
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
    
    func setCarouselDataArray() {
        
        
    }
    
    func getSingleVideo(_ photoId: String) {
        if photoId == "" {
            self.fromVideoFunction(data: allDataFromMyLife[self.currentIndex])
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
            
            if allDataFromMyLife[self.currentIndex]["type"].stringValue == "video" {
                self.getSingleVideo("")
            } else {
                self.getSinglePhoto("")
            }
            
        } else {
            
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
//            self.fromPhotoFunction(data: allDataFromMyLife[self.currentIndex])
            if carouselView.isHidden {
                carouselView.isHidden = false
            }
            carouselView.reloadData()
            carouselView.currentItemIndex = self.currentIndex
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
//                        print("\n\n self.carouselDataArray : \(self.carouselDict)")
//                        self.singlePhotoJSON = response["data"]
                        
                        print("\n Reload on carousel called")
                        self.carouselView.reloadData()
                        
                        if self.carouselView.isHidden {
                            self.carouselView.isHidden = false
                            self.carouselView.currentItemIndex = self.currentIndex
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
        loadPreviousData()
        loadNextData()
    }
    
    func loadPreviousData() {
        rightSwipe(nil)
    }
    
    func loadNextData() {
        leftSwipe(nil)
    }
    
    
    //MARK: - Carousel Datasource and Delegates
    
    func numberOfItems(in carousel: iCarousel) -> Int {
//        return carouselDict.allKeys.count
        if photos != nil {
            return photos.count
        }
        else{
            if postId == ""{
                return allDataFromMyLife.count
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
        
        let key = photos[index]["_id"].string!
        var currentJson = carouselDict.value(forKey: key) as! JSON!
        if postId == "" {
            currentJson = allDataFromMyLife[currentIndex]
        }
        if shouldCreateView {
            currentImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: carousel.frame.size.width*0.80, height: carousel.frame.size.height*0.70))
            currentImageView.contentMode = .scaleAspectFill
            currentImageView.clipsToBounds = true
            currentImageView.image = UIImage(named: "logo-default")
            currentImageView.backgroundColor = UIColor.clear
            currentImageView.tag = 999
            currentImageView.layer.borderColor = UIColor.white.cgColor
            currentImageView.layer.borderWidth = 2.0
            currentImageView.layer.cornerRadius = 5.0
        }
        
//        currentImageView.center = carousel.center        
        if currentJson != nil {
            let mainImageString = "\(adminUrl)upload/readFile?file=\((currentJson?["name"].stringValue)!)"
            currentImageView.hnk_setImageFromURL(NSURL(string:mainImageString) as! URL)
        }
        
        return currentImageView
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        
        if carousel.currentItemIndex != -1 {
            
            let key = photos[currentIndex!]["_id"].string!
            var currentJson = carouselDict.value(forKey: key)
            if postId == "" {
                currentJson = allDataFromMyLife[currentIndex]
            }
            if currentJson != nil {
                self.fromPhotoFunction(data: currentJson as! JSON)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { 
                self.bgImage.image = self.currentImageView.image
            })
            
            currentIndex = carousel.currentItemIndex
            self.loadMore()
        }
    }
    
    func carouselDidEndDecelerating(_ carousel: iCarousel) {
        print("carouselDidEndDecelerating")
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        print("\n Carousal didSelect : \(index)")
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
    
//    func setPhotos(indexNumber:Int) {
//        print("in indexed....  \(allDataFromMyLife[indexNumber])")
//        self.mainImage.hnk_setImageFromURL(getImageURL(allDataFromMyLife[indexNumber]["name"].stringValue, width: 200))
//        
//        self.bottomView.isHidden = false
//        self.mainImage.isHidden = false
//        
//        let imageLeftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.leftSwipe(_:)))
//        let imageRightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.rightSwipe(_:)))
//        
//        imageLeftSwipe.direction = .left
//        imageRightSwipe.direction = .right
//        
//        self.mainImage.addGestureRecognizer(imageLeftSwipe)
//        self.mainImage.addGestureRecognizer(imageRightSwipe)
//    }
    
//    override func popVC(_ sender: UIButton) {
//        self.navigationController!.popViewController(animated: true)
//    }

}

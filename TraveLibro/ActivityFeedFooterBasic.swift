import UIKit
import Spring
import AVFoundation

class ActivityFeedFooterBasic: UIView {
    
    @IBOutlet weak var lineView1: UIView!
    @IBOutlet weak var localLifeTravelImage: UIImageView!
    @IBOutlet weak var footerColorView: UIView!
    var postTop:JSON!
    
    
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var dropShadowActivity: UIView!
    @IBOutlet var starImageArray: [UIImageView]!
    @IBOutlet weak var ratingStack: UIStackView!
    @IBOutlet weak var rateThisButton: UIButton!
    @IBOutlet weak var likeButton: SpringButton!
    @IBOutlet weak var commentButton: SpringButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var likeHeart: UILabel!
    @IBOutlet weak var likeViewLabel: UILabel!
    @IBOutlet weak var commentIcon: UIImageView!
    @IBOutlet weak var commentCount: UILabel!
    var topLayout:VerticalLayout!
    var backgroundReview: UIView!
    var rating: AddRating!
    var newRating:JSON!
    let like =  Bundle.main.path(forResource: "tiny1", ofType: "mp3")!
    var audioPlayer = AVAudioPlayer()

    var type="ActivityFeeds"
    var footerType = ""
    var dropView: DropShadow2!
    var likeCount:Int = 0
    var commentCounts:Int = 0
    var photoId = ""
    var photoPostId = ""
    let border = CALayer()
    let border1 = CALayer()
    
    var photoCount = 0
    var videoCount = 0
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        print("\n bundle : \(bundle)")
        let nib = UINib(nibName: "ActivityFeedFooterBasic", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        //        transparentCardWhite(footerColorView)
        
        self.followBtn.isHidden = true
       
        let tapout = UITapGestureRecognizer(target: self, action: #selector(ActivityFeedFooterBasic.checkMyRating(_:)))
        ratingStack.addGestureRecognizer(tapout)
        likeButton.tintColor = mainBlueColor
        commentButton.tintColor = mainBlueColor
        shareButton.tintColor = mainBlueColor
        optionButton.tintColor = mainBlueColor
        commentIcon.tintColor = mainBlueColor
        likeButton.contentMode = .scaleAspectFit
        likeButton.setImage(UIImage(named:"likeButton"), for: UIControlState())
        shareButton.imageView?.contentMode = .scaleAspectFit
        commentButton.imageView?.contentMode = .scaleAspectFit
        likeButton.imageView?.contentMode = .scaleAspectFit
        self.likeHeart.text = String(format: "%C", faicon["likes"]!)

        let tapout1 = UITapGestureRecognizer(target: self, action: #selector(ActivityFeedFooterBasic.showLike(_:)))
        tapout1.numberOfTapsRequired = 1
        likeViewLabel.addGestureRecognizer(tapout1)

        let tapout2 = UITapGestureRecognizer(target: self, action: #selector(ActivityFeedFooterBasic.showComment(_:)))
        tapout2.numberOfTapsRequired = 1
        commentCount.addGestureRecognizer(tapout2)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: like))
        }
        catch{
            print(error)
        }
        audioPlayer.prepareToPlay()
    
    }
    
    func isBuddy() -> Bool {
        
        if postTop["buddies"].contains(where: {$0.1["_id"].stringValue == user.getExistingUser()}) {
            return true
        }else{
            return false
        }
    }
    
    func setView(feed:JSON) {
        
        postTop = feed
        
        if feed["photos"] != nil {
            photoCount = feed["photos"].count
        }
        if feed["videos"] != nil {
            videoCount = feed["videos"].count
        }
        let cnt = photoCount + videoCount
        if cnt > 1 {
            lineView.isHidden = false
        }else{
            lineView.isHidden = true
        }
        
        
        if currentUser != nil {
            optionButton.isHidden = false
            rateThisButton.isHidden = false
        }else{
            optionButton.isHidden = true
            rateThisButton.isHidden = true
        }
        
        
        if feed["review"][0] != nil && feed["review"].count > 0 {
            ratingStack.isHidden = false
            rateThisButton.isHidden = true
            afterRating(starCnt: feed["review"][0]["rating"].intValue, review: feed["review"][0]["review"].stringValue)
        }else{
            if feed["checkIn"] != nil && feed["checkIn"]["category"].stringValue != "" {
                if user.getExistingUser() == postTop["postCreator"]["_id"].stringValue {
                    ratingStack.isHidden = true
                    rateThisButton.isHidden = false
                }else{
                    ratingStack.isHidden = true
                    rateThisButton.isHidden = true
                }
            }else{
                ratingStack.isHidden = true
                rateThisButton.isHidden = true
            }
        }
    }
    
    
    //MARK: - Options

    @IBAction func optionClick(_ sender: UIButton) {
        print(user.getExistingUser())
        print(postTop)
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if user.getExistingUser() == postTop["postCreator"]["_id"].stringValue{
            
            if(self.type == "MyLifeFeeds") {
                let EditCheckIn: UIAlertAction = UIAlertAction(title: "Edit Activity", style: .default)
                {action -> Void in
                    //            self.isEdit = true
                    //                globalNewTLViewController.showEditActivity(Post())
                    globalMyLifeViewController.showEditActivity(self.postTop)
                    //print("inside edit check in \(self.addView), \(self.newScroll.isHidden)")
                }
//                actionSheetControllerIOS8.addAction(EditCheckIn)
                
                let EditDnt: UIAlertAction = UIAlertAction(title: "Change Date & Time", style: .default)
                { action -> Void in
                    globalMyLifeViewController.changeDateAndTime(self)
                }
                actionSheetControllerIOS8.addAction(EditDnt)
                
                let DeletePost: UIAlertAction = UIAlertAction(title: "Delete Activity", style: .default)
                { action -> Void in
                    
                    let alert = UIAlertController(title: "", message: "Are you sure you want to delete this Activtiy", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
                        request.deletePost(self.postTop["_id"].string!, uniqueId: self.postTop["uniqueId"].string!, user:currentUser["_id"].stringValue, completion: {(response) in
                            
                            let a = globalMyLifeContainerViewController.onTab
                            globalMyLifeContainerViewController.loadData(a, pageNumber: 1)
                               
                        })

                        
                    }))
                    globalMyLifeViewController.present(alert, animated: true, completion: nil)
                    
                }
                actionSheetControllerIOS8.addAction(DeletePost)
                let share: UIAlertAction = UIAlertAction(title: "Add Photos/Videos", style: .default)
                { action -> Void in
                    globalMyLifeViewController.showEditAddActivity(self.postTop)
                }
//                actionSheetControllerIOS8.addAction(share)
                
                let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
                { action -> Void in
                    
                }
                actionSheetControllerIOS8.addAction(cancel)
                
            } else {
                if isBuddy() {
                    let DeletePost: UIAlertAction = UIAlertAction(title: "Delete Activity", style: .default)
                    { action -> Void in
                        
                        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this Activtiy", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
                            request.deletePost(self.postTop["_id"].string!, uniqueId: self.postTop["uniqueId"].string!, user:currentUser["_id"].stringValue, completion: {(response) in
                                
                                let a = globalMyLifeContainerViewController.onTab
                                globalMyLifeContainerViewController.loadData(a, pageNumber: 1)
                                
                            })
                            
                            
                        }))
                        globalMyLifeViewController.present(alert, animated: true, completion: nil)
                        
                    }
                    actionSheetControllerIOS8.addAction(DeletePost)

                }
                let reportActionButton: UIAlertAction = UIAlertAction(title: "Hide", style: .default)
                {action -> Void in
                    let alert = UIAlertController(title: "Hide", message: "Hided successfuly", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    globalNavigationController.present(alert, animated: true, completion: nil)
                }
                actionSheetControllerIOS8.addAction(reportActionButton)
                
                let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
                { action -> Void in
                    
                }
                actionSheetControllerIOS8.addAction(cancel)
            }
            
        }else{
            if isBuddy() {
                let DeletePost: UIAlertAction = UIAlertAction(title: "Delete Activity", style: .default)
                { action -> Void in
                    
                    let alert = UIAlertController(title: "", message: "Are you sure you want to delete this Activtiy", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
                        request.deletePost(self.postTop["_id"].string!, uniqueId: self.postTop["uniqueId"].string!, user:currentUser["_id"].stringValue, completion: {(response) in
                            
                            let a = globalMyLifeContainerViewController.onTab
                            globalMyLifeContainerViewController.journeyLoader()
                            globalMyLifeContainerViewController.loadData(a, pageNumber: 1)
                            
                        })
                        
                        
                    }))
                    globalMyLifeViewController.present(alert, animated: true, completion: nil)
                    
                }
                actionSheetControllerIOS8.addAction(DeletePost)
                
            }
            let reportActionButton: UIAlertAction = UIAlertAction(title: "Report", style: .default)
            {action -> Void in
                let alert = UIAlertController(title: "Report", message: "Reported successfuly", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                globalNavigationController.present(alert, animated: true, completion: nil)
            }
            actionSheetControllerIOS8.addAction(reportActionButton)
            
            let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
            { action -> Void in
                
            }
            actionSheetControllerIOS8.addAction(cancel)
        }
        globalNavigationController.topViewController?.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    
    //MARK: - Like
    
    @IBAction func sendLikes(_ sender: UIButton) {
        if currentUser != nil {
            audioPlayer.play()
            likeButton.animation = "pop"
            likeButton.velocity = 2
            likeButton.force = 2
            likeButton.damping = 10
            likeButton.curve = "spring"
            likeButton.animateTo()
            
            var hasLiked = false
            if sender.tag == 1 {
                hasLiked = true
                sender.tag = 0
            }
            else {
                sender.tag = 1
            }
            
            self.updateLikeSuccess(sender: sender)
            
            if type == "TripPhotos" {
                request.globalLike(photoId, userId: user.getExistingUser(), unlike: hasLiked, type: footerType, completion: {(response) in
                    
                    DispatchQueue.main.async(execute: {                        
                        if response.error != nil {
                            print("error: \(response.error!.localizedDescription)")
                        }
                        else if response["value"].bool! {
                        }
                        else {
                            self.updateLikeFailure(sender: sender)
                        }
                    })
                })
            }
            else{
                request.globalLike(postTop["_id"].stringValue, userId: user.getExistingUser(), unlike: hasLiked, type: postTop["type"].stringValue, completion: {(response) in
                    DispatchQueue.main.async(execute: {
                        if response.error != nil {
                            print("error: \(response.error!.localizedDescription)")
                        }
                        else if response["value"].bool! {
                        }
                        else {
                            self.updateLikeFailure(sender: sender)
                        }
                    })
                })
            }
            
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
    }
    
    func updateLikeSuccess(sender : UIButton) {
        if sender.tag == 1 {
            self.setLikeSelected(true)
            self.likeCount = self.likeCount + 1
            self.setLikeCount(self.likeCount)
        }
        else {
            self.setLikeSelected(false)
            if self.likeCount <= 0 {
                self.likeCount = 0
            } else {
                self.likeCount = self.likeCount - 1
            }
            self.setLikeCount(self.likeCount)
        }
    }
    
    func updateLikeFailure(sender : UIButton) {
        if sender.tag == 1 {
            self.setLikeSelected(false)
            if self.likeCount <= 0 {
                self.likeCount = 0
            } else {
                self.likeCount = self.likeCount - 1
            }
            self.setLikeCount(self.likeCount)
        }
        else {
            self.setLikeSelected(true)
            self.likeCount = self.likeCount + 1
            self.setLikeCount(self.likeCount)            
        }
    }
    
    func setLikeSelected (_ isSelected:Bool) {
        if(isSelected) {
            self.likeButton.tag = 1
            self.likeButton.setImage(UIImage(named: "liked"), for: .normal)
            
        } else {
            self.likeButton.tag = 0
            self.likeButton.setImage(UIImage(named: "likeButton"), for: .normal)
        }
    }
    
    func showLike(_ sender: UITapGestureRecognizer) {
        print("in footer tap out \(postTop)")
        if currentUser != nil {
            let feedVC = storyboard!.instantiateViewController(withIdentifier: "likeTable") as! LikeUserViewController
            feedVC.postId = postTop["_id"].stringValue
            feedVC.type = postTop["type"].stringValue
            feedVC.title = postTop["name"].stringValue
            globalNavigationController.pushViewController(feedVC, animated: true)
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
    }
    
    func setLikeCount(_ post_likeCount:Int!) {
        if(post_likeCount != nil) {
            self.likeCount = post_likeCount
            if(post_likeCount == 0) {
                self.likeViewLabel.text = "0 Like"
            } else if(post_likeCount == 1) {
                self.likeViewLabel.text = "1 Like"
            } else if(post_likeCount > 1) {
                let counts = String(post_likeCount)
                self.likeViewLabel.text = "\(counts) Likes"
            }
        }
        self.checkHideView()
    }
    
    
    //MARK: - Comment
    
    @IBAction func sendComments(_ sender: UIButton) {
        if currentUser != nil {
            print("in activity feed layout \(postTop)")
            toCommentPage()
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
    }
    
    func showComment(_ sender: UITapGestureRecognizer) {
        if currentUser != nil {
            toCommentPage()
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
    }
    
    func toCommentPage() {
        if currentUser != nil {            
            if type == "TripPhotos" {
                let comment = storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsViewController
                comment.postId = photoPostId
                comment.ids = postTop["_id"].stringValue
                comment.footerViewBasic = self
                if(self.footerType == "videos") {
                    comment.type = "Video"
                }else{
                    comment.type = "Photo"
                }
                globalNavigationController?.setNavigationBarHidden(false, animated: true)
                globalNavigationController?.pushViewController(comment, animated: true)
            }
            else{
                let comment = storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsViewController
                comment.postId = postTop["uniqueId"].stringValue
                comment.ids = postTop["_id"].stringValue
                comment.footerViewBasic = self
                switch postTop["type"].stringValue {
                case "ended-journey", "on-the-go-journey":
                    comment.type = "journey"
                case "quick-itinerary", "detail-itinerary":
                    comment.type = "itinerary"
                case "travel-life", "local-life":
                    comment.type = "post"
                default:
                    comment.type = "photo"
                }
                globalNavigationController?.setNavigationBarHidden(false, animated: true)
                globalNavigationController?.pushViewController(comment, animated: true)
            }
            
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
    }
    
    func setCommentCount(_ post_commentCount:Int!) {
        
        if(post_commentCount != nil) {
            self.commentCounts = post_commentCount
            if(post_commentCount == 0) {
                self.commentCount.text = "0 Comment"
            } else if(post_commentCount == 1) {
                self.commentCount.text = "1 Comment"
            } else if(post_commentCount > 1) {
                let counts = String(post_commentCount)
                self.commentCount.text = "\(counts) Comments"
            }
        }
        self.checkHideView()
    }
    
    
    //MARK: - Hide Like Comment View
    
    func checkHideView() {
        if(self.commentCounts == 0  && self.likeCount == 0) {
            self.frame.size.height = 53;
            
            border1.removeFromSuperlayer()
            border.isHidden = false
            let width = CGFloat(2)
            
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
            border.borderColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 0.5).cgColor
            border.borderWidth = width
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
            
        } else {
            self.frame.size.height = 90;
            
            border.removeFromSuperlayer()
            border1.isHidden = false
            let width = CGFloat(2)
            border1.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
            border1.borderColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 0.5).cgColor
            border1.borderWidth = width
            self.layer.addSublayer(border1)
            
            self.layer.masksToBounds = true
            
        }
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:[.bottomRight, .bottomLeft],
                                cornerRadii: CGSize(width: 10, height:  10))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        topLayout.layoutSubviews()
        if(self.type == "LocalLife") {
            globalLocalLifeInside.addHeightToLayout()
        } else if(self.type == "ActivityFeeds") {
            globalActivityFeedsController.addHeightToLayout()
        } else if(self.type == "TripPhotos") {
            globalListPhotosViewController.addHeightToLayout()
        } else if(self.type == "MyLifeFeeds") {
            globalMyLifeContainerViewController.addHeightToLayout()
        }
    }
    
    
    //MARK: - Rating
    
    @IBAction func rateThisClicked(_ sender: UIButton) {
        openRating()
    }
    
    func openRating() {
        let tapout = UITapGestureRecognizer(target: self, action: #selector(ActivityFeedFooterBasic.reviewTapOut(_:)))
        
        backgroundReview = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: (globalNavigationController.topViewController?.view.frame.size.height)!))
        backgroundReview.addGestureRecognizer(tapout)
        backgroundReview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        globalNavigationController.topViewController?.view.addSubview(backgroundReview)
        //        globalNavigationController.topViewController?.view.bringSubview(toFront: backgroundReview)
        
        
        
        rating = AddRating(frame: CGRect(x: 0, y: 0, width: width - 40, height: 335))
        rating.activityJson = postTop
        
        if postTop["type"].stringValue == "travel-life" {
            rating.whichView = "otg"
            rating.switchSmily()
        }else{
            rating.whichView = ""
            rating.switchSmily()
        }
        
        rating.activityBasic = self
        rating.checkView = "activityFeed"
        
        
        if postTop["review"][0]["rating"] != nil  && postTop["review"].count != 0 {
            if newRating != nil {
                rating.starCount = newRating["rating"].intValue
                rating.ratingDisplay(newRating)
            }else{
                rating.starCount = postTop["review"][0]["rating"].intValue
                rating.ratingDisplay(postTop["review"][0])
            }
        }else{
            if newRating != nil {
                rating.starCount = newRating["rating"].intValue
                rating.ratingDisplay(newRating)
                
            }else{
                rating.starCount = 1
            }
        }
        
        
        
        rating.center = backgroundReview.center
        rating.layer.cornerRadius = 5
        rating.clipsToBounds = true
        //        rating.navController = globalNavigationController
        //        backgroundReview.addSubview(rating)
        globalNavigationController.topViewController?.view.addSubview(rating)
    }
    
    func checkMyRating(_ sender: UITapGestureRecognizer) {
        print("check i im the creator")        
        if user.getExistingUser() == postTop["postCreator"]["_id"].stringValue {
            openRating()
        }
    }
    
    func reviewTapOut(_ sender: UITapGestureRecognizer) {
        print("in footer tap out")
        backgroundReview.removeFromSuperview()
        rating.removeFromSuperview()
        
    }
    
    func afterRating(starCnt:Int, review:String) {        
        if starCnt != 0 {            
            for rat in starImageArray {
                if rat.tag > starCnt {
                    rat.image = UIImage(named: "star_uncheck")
                }else{
                    rat.image = UIImage(named: "star_check")
                    if postTop["type"].stringValue == "travel-life" {
                        rat.tintColor = mainOrangeColor
                    }else{
                        rat.tintColor = endJourneyColor
                    }                    
                }
            }
            newRating = ["rating":"\(starCnt)","review":review]
            ratingStack.isHidden = false
            rateThisButton.isHidden = true
        }
    }
    
    
    
    //MARK: - Share
    
    @IBAction func sharingTap(_ sender: Any) {
        if currentUser != nil {
            sharingUrl(url:  postTop["sharingUrl"].stringValue, onView: globalNavigationController.topViewController!)            
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
    }
    
}

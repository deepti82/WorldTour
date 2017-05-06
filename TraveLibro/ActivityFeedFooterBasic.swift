import UIKit
import Spring
import AVFoundation

protocol TLFooterDelegate {
    func footerOptionButtonClicked(sender: UIButton)
}

class ActivityFeedFooterBasic: UIView {
    
    var postTop:JSON!
    var pageType: viewType!
    var parentController: UIViewController!
    
    private var delegate: TLFooterDelegate?
    
    @IBOutlet weak var upperView: UIView!    
    @IBOutlet var starImageArray: [UIImageView]!
    @IBOutlet weak var ratingStack: UIStackView!
    @IBOutlet weak var rateThisButton: UIButton!
    @IBOutlet weak var likeButton: SpringButton!
    @IBOutlet weak var commentButton: SpringButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!
    
    @IBOutlet weak var bottomView: UIView!    
    @IBOutlet weak var likeHeart: UILabel!
    @IBOutlet weak var commentIcon: UIImageView!    
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var commentCountButton: UIButton!
    
    @IBOutlet weak var leadingToRatingStackConstraint: NSLayoutConstraint!    
    @IBOutlet weak var leadingToRateThisConstraint: NSLayoutConstraint!
    @IBOutlet weak var lowerViewHeightConstraint: NSLayoutConstraint!
    
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
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: like))
        }
        catch{
            print(error)
        }
        audioPlayer.prepareToPlay()
    
    }
    
    func fillFeedFooter(feed: JSON, pageType: viewType?, delegate: TLFooterDelegate?) {
        
        self.postTop = feed
        self.pageType = pageType!
        self.delegate = delegate
        
        if currentUser != nil {
            if (isSelfUser(otherUserID: postTop["user"]["_id"].stringValue) && self.pageType == viewType.VIEW_TYPE_MY_LIFE) {
                optionButton.isHidden = true
            }
            else {
                optionButton.isHidden = false
            }
        }
        else {
            optionButton.isHidden = true
        }
        
        self.setLikeCount(postTop["likeCount"].intValue)
        self.setCommentCount(postTop["commentCount"].intValue)
        self.setLikeSelected(postTop["likeDone"].boolValue)
        
        rateThisButton.isUserInteractionEnabled = true
        ratingStack.isUserInteractionEnabled = true
        ratingStack.isHidden = false
        rateThisButton.isHidden = false
        
        if feed["review"][0] != nil && feed["review"].count > 0 {
            ratingStack.isHidden = false
            rateThisButton.isHidden = true            
            afterRating(starCnt: feed["review"][0]["rating"].intValue, review: feed["review"][0]["review"].stringValue)
            if !isSelfUser(otherUserID: postTop["user"]["_id"].stringValue) {
                rateThisButton.isUserInteractionEnabled = false
            }
        }
        else {            
            if feed["checkIn"] != nil && feed["checkIn"]["category"].stringValue != "" {
                ratingStack.isHidden = true
                if canRate() {
                    rateThisButton.setTitle("Rate this now", for: .normal)
                }
                else {
                    rateThisButton.setTitle("", for: .normal)
                    rateThisButton.isUserInteractionEnabled = false
                }
            }
            else{
                ratingStack.isHidden = true
                rateThisButton.isHidden = true
            }
        }
        
        if (isSelfUser(otherUserID: postTop["user"]["_id"].stringValue) && self.pageType != viewType.VIEW_TYPE_MY_LIFE) {
            optionButton.isHidden = true
            leadingToRatingStackConstraint.constant = CGFloat(-30)
            leadingToRateThisConstraint.constant = CGFloat(-30)
        }
        else {
            optionButton.isHidden = false
            leadingToRatingStackConstraint.constant = CGFloat(8)
            leadingToRateThisConstraint.constant = CGFloat(8)
        }
        
        self.removeTargetActions()
        
        self.addTargetActions()
    }
    
    func removeTargetActions() {
        self.likeButton.removeTarget(self, action: #selector(self.sendLikes(_:)), for: .touchUpInside)
        self.commentButton.removeTarget(self, action: #selector(self.sendComments(_:)), for: .touchUpInside)
        self.likeCountButton.removeTarget(self, action: #selector(self.likeCountTabbed(_:)), for: .touchUpInside)
        self.commentCountButton.removeTarget(self, action: #selector(self.commentCountTabbed(_:)), for: .touchUpInside)
        self.shareButton.removeTarget(self, action: #selector(self.sharingTap(_:)), for: .touchUpInside)
        self.optionButton.removeTarget(self, action: #selector(self.optionClick(_:)), for: .touchUpInside)
        self.rateThisButton.removeTarget(self, action: #selector(self.rateThisClicked(_:)), for: .touchUpInside)
        
        for recognizer in self.ratingStack.gestureRecognizers ?? [] {
            self.removeGestureRecognizer(recognizer)
        }
    }
    
    func addTargetActions() {
        self.likeButton.addTarget(self, action: #selector(self.sendLikes(_:)), for: .touchUpInside)        
        self.commentButton.addTarget(self, action: #selector(self.sendComments(_:)), for: .touchUpInside)
        self.likeCountButton.addTarget(self, action: #selector(self.likeCountTabbed(_:)), for: .touchUpInside)
        self.commentCountButton.addTarget(self, action: #selector(self.commentCountTabbed(_:)), for: .touchUpInside)
        self.shareButton.addTarget(self, action: #selector(self.sharingTap(_:)), for: .touchUpInside)
        self.optionButton.addTarget(self, action: #selector(self.optionClick(_:)), for: .touchUpInside)
        self.rateThisButton.addTarget(self, action: #selector(self.rateThisClicked(_:)), for: .touchUpInside)
        
        let tapout = UITapGestureRecognizer(target: self, action: #selector(self.openRating))
        ratingStack.addGestureRecognizer(tapout)
    }
    
    //MARK: - Like
    
    @IBAction func likeCountTabbed(_ sender: UIButton) {
        self.showLike()
    }
    
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
    
    func showLike() {
        print("in footer tap out \(postTop)")
        if currentUser != nil {
            let feedVC = storyboard!.instantiateViewController(withIdentifier: "likeTable") as! LikeUserViewController
            feedVC.postId = postTop["_id"].stringValue
            feedVC.type = postTop["type"].stringValue
            feedVC.title = postTop["name"].stringValue
            parentController.navigationController?.pushViewController(feedVC, animated: true)
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
    }
    
    func setLikeCount(_ post_likeCount:Int!) {
        if(post_likeCount != nil) {
            self.likeCount = post_likeCount
            if(post_likeCount == 0) {
                self.likeCountButton.setTitle("0 Like", for: .normal)
            } else if(post_likeCount == 1) {
                self.likeCountButton.setTitle("1 Like", for: .normal)
            } else if(post_likeCount > 1) {
                let counts = String(post_likeCount)
                self.likeCountButton.setTitle("\(counts) Likes", for: .normal)
            }
        }
    }
    
    
    //MARK: - Comment
    
    @IBAction func commentCountTabbed(_ sender: UIButton) {
        self.showComment()
    }
    
    @IBAction func sendComments(_ sender: UIButton) {
        if currentUser != nil {
            print("in activity feed layout \(postTop)")
            toCommentPage()
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
    }
    
    func showComment() {
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
                parentController.navigationController?.setNavigationBarHidden(false, animated: false)
                parentController.navigationController?.pushViewController(comment, animated: true)
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
                parentController.navigationController?.setNavigationBarHidden(false, animated: false)
                parentController.navigationController?.pushViewController(comment, animated: true)
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
                self.commentCountButton.setTitle("0 Comment", for: .normal)
            } else if(post_commentCount == 1) {
                self.commentCountButton.setTitle("1 Comment", for: .normal)
            } else if(post_commentCount > 1) {
                let counts = String(post_commentCount)
                self.commentCountButton.setTitle("\(counts) Comments", for: .normal)
                
                
            }
        }
    }
    
    
    //MARK: - Share
    
    @IBAction func sharingTap(_ sender: Any) {
        sharingUrl(url:  postTop["sharingUrl"].stringValue, onView: parentController)
    }
    
    
    //MARK: - Rating
    
    @IBAction func rateThisClicked(_ sender: UIButton) {
        openRating()
    }
    
    func openRating() {
        let tapout = UITapGestureRecognizer(target: self, action: #selector(ActivityFeedFooterBasic.reviewTapOut(_:)))
        
        backgroundReview = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: (parentController.view.frame.size.height)))
        backgroundReview.addGestureRecognizer(tapout)
        backgroundReview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        parentController.view.addSubview(backgroundReview)
        
        rating = AddRating(frame: CGRect(x: 0, y: 0, width: width - 40, height: 335))
        rating.activityJson = postTop
        rating.canRate = canRate()
        
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
        
        rating.addReviewText.isUserInteractionEnabled = true
        rating.reviewTextView.isEditable = true
        rating.postReview.setTitle("Post", for: .normal)
        
        if !(canRate()) {
            rating.addReviewText.isUserInteractionEnabled = false
            rating.reviewTextView.isEditable = false
            rating.postReview.setTitle("Close", for: .normal)
        }       
        
        parentController.view.addSubview(rating)
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
                        rat.tintColor = mainGreenColor
                    }                    
                }
            }
            newRating = ["rating":"\(starCnt)","review":review]
            ratingStack.isHidden = false
            rateThisButton.isHidden = true
        }
    }
    
    
    //MARK: - Options
    
    @IBAction func optionClick(_ sender: UIButton) {
        
        delegate?.footerOptionButtonClicked(sender: sender)
        
        var shouldPresent = true
        
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if isSelfUser(otherUserID: postTop["user"]["_id"].stringValue) {
            
            if(self.type == "MyLifeFeeds" && isSelfUser(otherUserID: currentUser["_id"].stringValue)) {
                let EditCheckIn: UIAlertAction = UIAlertAction(title: "Edit Activity", style: .default)
                {action -> Void in                   
                    globalMyLifeViewController.showEditActivity(self.postTop)
                }
                
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
                    showPopover(optionsController: alert, sender: sender, vc: globalMyLifeViewController)
                    
                }
                actionSheetControllerIOS8.addAction(DeletePost)
                let share: UIAlertAction = UIAlertAction(title: "Add Photos/Videos", style: .default)
                { action -> Void in
                    globalMyLifeViewController.showEditAddActivity(self.postTop)
                }
                
                let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
                { action -> Void in
                    
                }
                actionSheetControllerIOS8.addAction(cancel)
                
            } 
            else {
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
                        showPopover(optionsController: alert, sender: sender, vc: globalMyLifeViewController)                                                
                    }
                    actionSheetControllerIOS8.addAction(DeletePost)
                    
                }
                
                let reportActionButton: UIAlertAction = UIAlertAction(title: "Hide", style: .default) {action -> Void in
                    let alert = UIAlertController(title: "Hide", message: "Hided successfuly", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    showPopover(optionsController: alert, sender: sender, vc: globalNavigationController)
                    
                }
                
                let reportActionButton1: UIAlertAction = UIAlertAction(title: "Report", style: .default) {action -> Void in
                    let alert = UIAlertController(title: "Report", message: "Reported Successfully", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    showPopover(optionsController: alert, sender: sender, vc: globalNavigationController)                    
                }
                
                if isSelfUser(otherUserID: currentUser["_id"].stringValue) {
                    shouldPresent = false
                    
                }else{
                    actionSheetControllerIOS8.addAction(reportActionButton1)
                    let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
                    { action -> Void in
                        
                    }
                    actionSheetControllerIOS8.addAction(cancel)
                    
                }
                
                
            }
            
        }
        else{
            if isBuddy() {
                if self.type == "MyLifeFeeds"{
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
                        showPopover(optionsController: alert, sender: sender, vc: globalMyLifeViewController)                        
                    }
                    actionSheetControllerIOS8.addAction(DeletePost)
                }
                
            }
            
            let reportActionButton1: UIAlertAction = UIAlertAction(title: "Report", style: .default) {action -> Void in
                let alert = UIAlertController(title: "Report", message: "Reported Successfully", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                showPopover(optionsController: alert, sender: sender, vc: globalNavigationController)
            }
            
            let reportActionButton: UIAlertAction = UIAlertAction(title: "Hide", style: .default) {action -> Void in
                let alert = UIAlertController(title: "Hide", message: "Hided successfuly", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                showPopover(optionsController: alert, sender: sender, vc: globalNavigationController)
            }
            
            if self.type == "popular"{
                actionSheetControllerIOS8.addAction(reportActionButton1)
            }
            else{
                
                if isSelfUser(otherUserID: postTop["user"]["_id"].stringValue) {
                    actionSheetControllerIOS8.addAction(reportActionButton)
                    
                }else{
                    actionSheetControllerIOS8.addAction(reportActionButton1)
                    
                }
            }
            
            
            let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
            { action -> Void in
                
            }
            actionSheetControllerIOS8.addAction(cancel)
        }
        
        if shouldPresent {
            showPopover(optionsController: actionSheetControllerIOS8, sender: sender, vc: globalNavigationController)
        }
        
    }
    
    
    //MARK: - Helper functions
    
    func isBuddy() -> Bool {
        
        if postTop["buddies"].contains(where: {$0.1["_id"].stringValue == user.getExistingUser()}) && user.getExistingUser() == currentUser["_id"].stringValue {
            return true
        }else{
            return false
        }
    }
    
    func canRate() -> Bool {
        if (self.pageType == viewType.VIEW_TYPE_MY_LIFE) {
            if isSelfUser(otherUserID: currentUser["_id"].stringValue) {
                return true
            }
            else {
                return false
            }
        }
        else {
            if isSelfUser(otherUserID: postTop["postCreator"]["_id"].stringValue) {
                return true
            }
            else {
                return false
            }
        }
    }
    
}

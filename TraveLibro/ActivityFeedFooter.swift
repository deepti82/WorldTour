//
//  PhotoOTGFooter.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 28/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Spring
import AVFoundation

class ActivityFeedFooter: UIView {
    
   
    var backgroundReview: UIView!
   
    var postTop: JSON!
    var pageType: viewType!
    var parentController: UIViewController!
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var likeButton: SpringButton!
    @IBOutlet weak var commentButton: SpringButton!    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!
    
    @IBOutlet weak var lowerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lowerView: UIView!
    @IBOutlet weak var likeHeart: UILabel!    
    @IBOutlet weak var commentIcon: UIImageView!        
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var commentCountButton: UIButton!
    
    var topLayout:VerticalLayout!
    var type="ActivityFeeds"
    let like =  Bundle.main.path(forResource: "tiny1", ofType: "mp3")!
    var audioPlayer = AVAudioPlayer()
    var likeCount:Int = 0
    var commentCounts:Int = 0
    var reviewCount:Int = 0
    let border = CALayer()
    let border1 = CALayer()
    
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ActivityFeedFooter", bundle: bundle)
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
    
    func fillFeedFooter(feed: JSON, pageType: viewType?) {
        self.postTop = feed
        self.pageType = pageType
        
        if currentUser != nil {
            if (isSelfUser(otherUserID: postTop["user"]["_id"].stringValue) && self.type != "MyLifeFeeds") {
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
        
        self.removeTargetActions()
        
        self.addTargetActions()
    }
    
    func removeTargetActions() {
        self.likeButton.removeTarget(self, action: #selector(self.sendLikes(_:)), for: .touchUpInside)
        self.commentButton.removeTarget(self, action: #selector(self.sendComments(_:)), for: .touchUpInside)
        self.likeCountButton.removeTarget(self, action: #selector(self.likeCountTapped(_:)), for: .touchUpInside)
        self.commentCountButton.removeTarget(self, action: #selector(self.commentCountTabbed(_:)), for: .touchUpInside)
        self.shareButton.removeTarget(self, action: #selector(self.sharingTap(_:)), for: .touchUpInside)
        self.optionButton.removeTarget(self, action: #selector(self.optionClick(_:)), for: .touchUpInside)
    }
    
    func addTargetActions() {
        self.likeButton.addTarget(self, action: #selector(self.sendLikes(_:)), for: .touchUpInside)        
        self.commentButton.addTarget(self, action: #selector(self.sendComments(_:)), for: .touchUpInside)
        self.likeCountButton.addTarget(self, action: #selector(self.likeCountTapped(_:)), for: .touchUpInside)
        self.commentCountButton.addTarget(self, action: #selector(self.commentCountTabbed(_:)), for: .touchUpInside)
        self.shareButton.addTarget(self, action: #selector(self.sharingTap(_:)), for: .touchUpInside)
        self.optionButton.addTarget(self, action: #selector(self.optionClick(_:)), for: .touchUpInside)
    }
    
    func setView(feed:JSON) {
        postTop = feed
        
        if (isSelfUser(otherUserID: postTop["user"]["_id"].stringValue) && self.type != "MyLifeFeeds") {
            optionButton.isHidden = true
        }
        else {
            optionButton.isHidden = false
        }
    }
        
    
    //MARK: - Like    
    
    @IBAction func likeCountTapped(_ sender: UIButton) {
        if currentUser != nil {
            let feedVC = storyboard?.instantiateViewController(withIdentifier: "likeTable") as! LikeUserViewController
            feedVC.postId = postTop["_id"].stringValue
            feedVC.type = postTop["type"].stringValue
            feedVC.title = postTop["name"].stringValue
            parentController.navigationController?.pushViewController(feedVC, animated: true)
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
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
            
            print("like button tapped \(sender.titleLabel!.text)")
            
            var hasLiked = false
            if sender.tag == 1 {
                hasLiked = true
                sender.tag = 0
            }
            else {
                sender.tag = 1
            }
            
            self.updateLikeSuccess(sender: sender)
            
            request.globalLike(postTop["_id"].stringValue, userId: user.getExistingUser(), unlike: hasLiked, type: postTop["type"].stringValue, completion: {(response) in
                DispatchQueue.main.async(execute: {
                    if response.error != nil {
                        print("error: \(response.error!.localizedDescription)")
                    }
                    else if response["value"].bool! {
                    } else {
                        self.updateLikeFailure(sender: sender)
                    }
                })
            })
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
    
    func setLikeSelected (_ isSelected:Bool) {         
        if(isSelected) {
            self.likeButton.tag = 1
            self.likeButton.setImage(UIImage(named: "liked"), for: .normal)            
        } else {
            self.likeButton.setImage(UIImage(named: "likeButton"), for: .normal)
            self.likeButton.tag = 0            
        }
    }
    
    //MARK: - Comment
    
    @IBAction func commentCountTabbed(_ sender: UIButton) {
        print("\n commentCountTabbed")
        toCommentView(sender: sender)        
    }    
    
    @IBAction func sendComments(_ sender: UIButton) {
        print("\n sendComments")
        toCommentView(sender: sender)
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
    
    func toCommentView(sender: UIButton) {
        if currentUser != nil {            
            let comment = storyboard!.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsViewController
            comment.postId = postTop["uniqueId"].stringValue
            comment.ids = postTop["_id"].stringValue
            comment.footerViewFooter = self
            switch postTop["type"].stringValue {
            case "ended-journey", "on-the-go-journey":
                comment.type = "journey"
            case "quick-itinerary", "detail-itinerary":
                comment.type = "itinerary"
            case "travel-life", "local-life":
                comment.type = "post"
            default:
                comment.type = "post"
            }
            
            parentController.navigationController?.setNavigationBarHidden(false, animated: false)
            parentController.navigationController?.pushViewController(comment, animated: true)
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
        
        
    }
    
    //MARK: - Share
    
    @IBAction func sharingTap(_ sender: UIButton) {
        sharingUrl(url:  postTop["sharingUrl"].stringValue, onView: parentController)
    }
    
    //MARK: - Option
    
    @IBAction func optionClick(_ sender: UIButton) {
//        print(postTop)
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if(self.type == "MyLifeFeeds") {
            
            if(postTop["type"].stringValue == "detail-itinerary") {
                if isSelfUser(otherUserID: currentUser["_id"].stringValue) {
                    
                    let editActionButton: UIAlertAction = UIAlertAction(title: "Edit", style: .default)
                    {action -> Void in
                        let alert = UIAlertController(title: "Edit Itinerary", message: "You can only edit your Itinerary on Web.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        globalMyLifeContainerViewController.present(alert, animated: true, completion: nil)
                    }
                    actionSheetControllerIOS8.addAction(editActionButton)
                    
                    //                let changeCoverActionButton: UIAlertAction = UIAlertAction(title: "Change Cover Photo", style: .default)
                    //                {action -> Void in
                    //                }
                    //                actionSheetControllerIOS8.addAction(changeCoverActionButton)
                    
                    //                let deleteActionButton: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive)
                    //                {action -> Void in
                    //                }
                    //                actionSheetControllerIOS8.addAction(deleteActionButton)
                }else{
                    let reportActionButton: UIAlertAction = UIAlertAction(title: "Report", style: .default)
                    {action -> Void in
                        let alert = UIAlertController(title: "Report", message: "Reported Successfully.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        showPopover(optionsController: alert, sender: sender, vc: self.parentController)
                    }
                    actionSheetControllerIOS8.addAction(reportActionButton)
                }
                
                let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
                { action -> Void in
                    
                }
                actionSheetControllerIOS8.addAction(cancel)
                
            }
            
            if(postTop["type"].stringValue == "quick-itinerary") {
                let editActionButton: UIAlertAction = UIAlertAction(title: "Edit", style: .default)
                {action -> Void in
                    let itineraryVC = storyboard?.instantiateViewController(withIdentifier: "qiPVC") as! QIViewController
                    itineraryVC.editID = self.postTop["_id"].stringValue
                    globalMyLifeContainerViewController.navigationController?.pushViewController(itineraryVC, animated: true)
                }
                actionSheetControllerIOS8.addAction(editActionButton)
                
                let deleteActionButton: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive)
                {action -> Void in
                    
                    let alert = UIAlertController(title: "", message: "Are you sure you want to delete this Itinerary.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
                        request.deleteItinerary(id: self.postTop["_id"].stringValue, completion: {(response) in
                            
                            let a = globalMyLifeContainerViewController.onTab
                            globalMyLifeContainerViewController.loadData(type: a, pageNumber: 1, fromVC: nil)
                            
                        })
                        
                        
                    }))
                    showPopover(optionsController: alert, sender: sender, vc: globalMyLifeViewController)
                    
                    //                        globalMyLifeViewController.present(alert, animated: true, completion: nil)
                    
                    
                }
                actionSheetControllerIOS8.addAction(deleteActionButton)
                
                let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
                { action -> Void in
                    
                }
                actionSheetControllerIOS8.addAction(cancel)
            }
            if postTop["type"].stringValue == "travel-life" || postTop["type"].stringValue == "local-life" {
                if isBuddy() && self.type == "MyLifeFeeds" && isSelfUser(otherUserID: currentUser["_id"].stringValue){
                    
                    let DeletePost: UIAlertAction = UIAlertAction(title: "Delete Activity", style: .default)
                    { action -> Void in
                        
                        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this Activtiy", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
                            request.deletePost(self.postTop["_id"].string!, uniqueId: self.postTop["uniqueId"].string!, user:currentUser["_id"].stringValue, completion: {(response) in
                                
                                let a = globalMyLifeContainerViewController.onTab
                                globalMyLifeContainerViewController.loadData(type: a, pageNumber: 1, fromVC: nil)
                                
                            })
                            
                            
                        }))
                        showPopover(optionsController: alert, sender: sender, vc: globalMyLifeViewController)
                        
                        //                            globalMyLifeViewController.present(alert, animated: true, completion: nil)
                        
                    }
                    actionSheetControllerIOS8.addAction(DeletePost)
                    
                }
            }
            if(postTop["type"].stringValue == "ended-journey" || postTop["type"].stringValue == "on-the-go-journey") {
                if isSelfUser(otherUserID: currentUser["_id"].stringValue) {
                    
                    let changeNameActionButton: UIAlertAction = UIAlertAction(title: "Change Journey Name", style: .default)
                    {action -> Void in
                        
                        
                        //1. Create the alert controller.
                        let alert = UIAlertController(title: "", message: "Change Journey Name", preferredStyle: .alert)
                        //2. Add the text field. You can configure it however you need.
                        alert.addTextField { (textField) in
                            textField.text = self.postTop["name"].stringValue
                        }
                        
                        // 3. Grab the value from the text field, and print it when the user clicks OK.
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                            print("Text field: \(textField?.text)")
                            request.journeyChangeName((textField?.text)!, journeyId: self.postTop["_id"].stringValue, completion: { response  in
                                print(response);
                            })
                        }))
                        
                        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
                        { action -> Void in
                            
                        }
                        alert.addAction(cancel)
                        
                        // 4. Present the alert.
                        showPopover(optionsController: alert, sender: sender, vc: globalMyLifeContainerViewController)
                        
                        //                        globalMyLifeContainerViewController.present(alert, animated: true, completion: nil)
                        
                    }
                    actionSheetControllerIOS8.addAction(changeNameActionButton)
                    
                    let changeDateActionButton: UIAlertAction = UIAlertAction(title: "Change End Journey Date", style: .default)
                    {action -> Void in
                        globalMyLifeViewController.changeDateAndTimeEndJourney(self)
                    }
                    
                    if(self.postTop["endTime"].string != nil) {
                        actionSheetControllerIOS8.addAction(changeDateActionButton)
                    }
                    
                    let crateCountriesActionButton: UIAlertAction = UIAlertAction(title: "Rate Countries", style: .default)
                    {action -> Void in
                        let end = storyboard!.instantiateViewController(withIdentifier: "endJourney") as! EndJourneyViewController
                        end.journeyId = self.postTop["_id"].stringValue
                        end.type = "MyLife"
                        globalMyLifeContainerViewController.navigationController?.pushViewController(end, animated: true)
                    }
                    actionSheetControllerIOS8.addAction(crateCountriesActionButton)
                    
                    let changeCoverCountriesActionButton: UIAlertAction = UIAlertAction(title: "Change Cover Photo", style: .default)
                    {action -> Void in
                        let end = storyboard!.instantiateViewController(withIdentifier: "endJourney") as! EndJourneyViewController
                        end.journeyId = self.postTop["_id"].stringValue
                        end.type = "MyLife"
                        globalMyLifeContainerViewController.navigationController?.pushViewController(end, animated: true)
                    }
                    actionSheetControllerIOS8.addAction(changeCoverCountriesActionButton)
                }else{
                    let reportActionButton: UIAlertAction = UIAlertAction(title: "Report", style: .default)
                    {action -> Void in
                        let alert = UIAlertController(title: "Report", message: "Reported Successfully.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        showPopover(optionsController: alert, sender: sender, vc: self.parentController)
                    }
                    actionSheetControllerIOS8.addAction(reportActionButton)
                }
                
                
                let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
                { action -> Void in
                    
                }
                actionSheetControllerIOS8.addAction(cancel)
                
                //                let changeCoverCountriesActionButton: UIAlertAction = UIAlertAction(title: "Delete Journey", style: .destructive)
                //                {action -> Void in
                //                }
                //                actionSheetControllerIOS8.addAction(changeCoverCountriesActionButton)
                
            }
        }
        else {
            let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            }
            //let UnFollow: UIAlertAction = UIAlertAction(title: "UnFollow", style: .default)
            //{action -> Void in
            //}
            //actionSheetControllerIOS8.addAction(UnFollow)
            actionSheetControllerIOS8.addAction(cancelActionButton)
            let reportActionButton: UIAlertAction = UIAlertAction(title: "Report", style: .default)
            {action -> Void in
                let alert = UIAlertController(title: "Report", message: "Reported Successfully.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                showPopover(optionsController: alert, sender: sender, vc: self.parentController)
            }
            actionSheetControllerIOS8.addAction(reportActionButton)
        }
        showPopover(optionsController: actionSheetControllerIOS8, sender: sender, vc: self.parentController)
    }
    
    
    //MARK: - Helper
    
    func isBuddy() -> Bool {
        
        if postTop["buddies"].contains(where: {$0.1["_id"].stringValue == user.getExistingUser()}) {
            return true
        }else{
            return false
        }
    }
    
    func checkHideView() {
        if(self.commentCounts == 0  && self.likeCount == 0 && self.reviewCount == 0) {
            self.frame.size.height = 51;
            
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
        }
    }
    
    
    
    
}

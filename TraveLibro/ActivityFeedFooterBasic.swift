//
//  PhotoOTGFooter.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 28/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Spring

class ActivityFeedFooterBasic: UIView {
    
    //    @IBOutlet weak var LineView1: UIView!
    
    
    @IBOutlet weak var localLifeTravelImage: UIImageView!
    @IBOutlet weak var footerColorView: UIView!
    var postTop:JSON!
    
    
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

    var type="ActivityFeeds"
    
    var likeCount:Int = 0
    var commentCounts:Int = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ActivityFeedFooterBasic", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        transparentCardWhite(footerColorView)
        
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
        
        
        
    }
    var photoCount = 0
    var videoCount = 0
    
    func setView(feed:JSON) {
        //  RATING
        if feed["type"].stringValue == "travel-life" {
            localLifeTravelImage.image = UIImage(named: "travel_life")
        }else{
            localLifeTravelImage.image = UIImage(named: "local_life")
            localLifeTravelImage.tintColor = endJourneyColor
        }
        
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
        
        if feed["review"][0] != nil && feed["review"].count > 0 {
            ratingStack.isHidden = false
            rateThisButton.isHidden = true
            afterRating(starCnt: feed["review"][0]["rating"].intValue)
        }else{
            if feed["checkIn"] != nil && feed["checkIn"]["category"].stringValue != "" {
                if currentUser["_id"].stringValue == postTop["postCreator"]["_id"].stringValue {
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
    
    @IBAction func rateThisClicked(_ sender: UIButton) {
        openRating()
    }
    
    func openRating() {
        let tapout = UITapGestureRecognizer(target: self, action: #selector(ActivityFeedFooterBasic.reviewTapOut(_:)))
        
        backgroundReview = UIView(frame: (globalNavigationController.topViewController?.view.frame)!)
        backgroundReview.addGestureRecognizer(tapout)
        backgroundReview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        globalNavigationController.topViewController?.view.addSubview(backgroundReview)
        globalNavigationController.topViewController?.view.bringSubview(toFront: backgroundReview)
        
        let rating = AddRating(frame: CGRect(x: 0, y: 0, width: width - 40, height: 335))
        rating.activityJson = postTop
        rating.activityBasic = self
        rating.checkView = "activityFeed"
        
        if postTop["review"][0]["rating"] != nil  && postTop["review"].count != 0 {
            rating.starCount = postTop["review"][0]["rating"].intValue
            rating.ratingDisplay(postTop["review"][0])
        }else{
            rating.starCount = 1
        }
        
        
        
        rating.center = backgroundReview.center
        rating.layer.cornerRadius = 5
        rating.clipsToBounds = true
        rating.navController = globalNavigationController
        backgroundReview.addSubview(rating)
    }
    
    func reviewTapOut(_ sender: UITapGestureRecognizer) {
        print("in footer tap out")
        backgroundReview.removeFromSuperview()
        
    }
    func checkMyRating(_ sender: UITapGestureRecognizer) {
        print("check i im the creator")
        
        if currentUser["_id"].stringValue == postTop["postCreator"]["_id"].stringValue {
            openRating()
        }
    }
    
    func afterRating(starCnt:Int) {
        if starCnt != 0 {
            print("start rating")
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
            ratingStack.isHidden = false
            rateThisButton.isHidden = true
        }
    }
    
    @IBAction func sendComments(_ sender: UIButton) {
        let comment = storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsViewController
        comment.postId = postTop["uniqueId"].stringValue
        comment.otherId = postTop["_id"].stringValue
        
        globalNavigationController?.setNavigationBarHidden(false, animated: true)
        globalNavigationController?.pushViewController(comment, animated: true)
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
    
    func checkHideView() {
        if(self.commentCounts == 0  && self.likeCount == 0) {
            self.frame.size.height = 50;
        } else {
            self.frame.size.height = 90;
        }
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:[.bottomRight, .bottomLeft],
                                cornerRadii: CGSize(width: 5, height:  5))
        
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
    
    func setLikeSelected (_ isSelected:Bool) {
        if(isSelected) {
            self.likeButton.tag = 1
            self.likeButton.setImage(UIImage(named: "favorite-heart-button"), for: .normal)
            self.likeButton.tintColor = mainOrangeColor
            
        } else {
            self.likeButton.tag = 0
            self.likeButton.tintColor = mainBlueColor
        }
    }
    
    @IBAction func sendLikes(_ sender: UIButton) {
        
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
        
        request.likePost(postTop["uniqueId"].stringValue, userId: currentUser["_id"].string!, userName: currentUser["name"].string!, unlike: hasLiked, completion: {(response) in
            DispatchQueue.main.async(execute: {
                if response.error != nil {
                    print("error: \(response.error!.localizedDescription)")
                }
                else if response["value"].bool! {
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
                else {
                    
                }
            })
        })
    }
    
    @IBAction func optionClick(_ sender: UIButton) {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        let EditCheckIn: UIAlertAction = UIAlertAction(title: "Report", style: .default)
        {action -> Void in

        }
        actionSheetControllerIOS8.addAction(EditCheckIn)
        
        
        globalNavigationController.topViewController?.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
}

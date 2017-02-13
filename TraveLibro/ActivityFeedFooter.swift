//
//  PhotoOTGFooter.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 28/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Spring

class ActivityFeedFooter: UIView {
    
    //    @IBOutlet weak var LineView1: UIView!
    
    
    @IBOutlet weak var localLifeTravelImage: UIImageView!
    var backgroundReview: UIView!
    @IBOutlet weak var footerColorView: UIView!
    var postTop:JSON!
    
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var likeButton: SpringButton!
    @IBOutlet weak var commentButton: SpringButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var likeHeart: UILabel!
    @IBOutlet weak var likeViewLabel: UILabel!
    @IBOutlet weak var commentIcon: UIImageView!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var commentCount: UILabel!
    var topLayout:VerticalLayout!
    var type="ActivityFeeds"
    
    var likeCount:Int = 0
    var commentCounts:Int = 0
    var reviewCount:Int = 0
    let border = CALayer()
    let border1 = CALayer()
    
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
//        transparentCardWhite(footerColorView)
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
    
    func setReviewCount(count:Int!) {
        if count != nil {
            self.reviewCount = count
            if(count == 0) {
                self.reviewLabel.text = "0 Review"
            } else if(count == 1) {
                self.reviewLabel.text = "1 Review"
            } else if(count > 1) {
                let counts = String(count)
                self.reviewLabel.text = "\(counts) Reviews"
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
        if(self.commentCounts == 0  && self.likeCount == 0 && self.reviewCount == 0) {
            self.frame.size.height = 50;
            
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
        
        if (postTop["type"].stringValue == "quick-itinerary" || postTop["type"].stringValue == "detail-itinerary") {
            request.likeItinerary(postTop["uniqueId"].stringValue, userId: currentUser["_id"].string!, userName: currentUser["name"].string!, unlike: hasLiked, itinerary: postTop["_id"].stringValue, completion: {(response) in
                DispatchQueue.main.async(execute: {
                    if response.error != nil {
                        print("error: \(response.error!.localizedDescription)")
                    }
                    else if response["value"].bool! {
                        if sender.tag == 1 {
                            self.setLikeSelected(true)
                            self.likeCount = self.likeCount + 1
                            self.setLikeCount(self.likeCount)
                        } else {
                            self.setLikeSelected(false)
                            if self.likeCount <= 0 {
                                self.likeCount = 0
                            } else {
                                self.likeCount = self.likeCount - 1
                            }
                            self.setLikeCount(self.likeCount)
                        }
                    } else {
                        
                    }
                })
            })
        }else if (postTop["type"].stringValue == "ended-journey" || postTop["type"].stringValue == "on-the-go-journey") {
            request.likeStartEnd(postTop["uniqueId"].stringValue, userId: currentUser["_id"].string!, userName: currentUser["name"].string!, unlike: hasLiked, journey: postTop["_id"].stringValue, completion: {(response) in
                DispatchQueue.main.async(execute: {
                    if response.error != nil {
                        print("error: \(response.error!.localizedDescription)")
                    }
                    else if response["value"].bool! {
                        if sender.tag == 1 {
                            self.setLikeSelected(true)
                            self.likeCount = self.likeCount + 1
                            self.setLikeCount(self.likeCount)
                        } else {
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
    }
    
    @IBAction func optionClick(_ sender: UIButton) {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if(self.type == "MyLifeFeeds") {
            
            if(postTop["type"].stringValue == "detail-itinerary") {
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
                
//                let changeCoverActionButton: UIAlertAction = UIAlertAction(title: "Change Cover Photo", style: .default)
//                {action -> Void in
//                }
//                actionSheetControllerIOS8.addAction(changeCoverActionButton)
                
                let deleteActionButton: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive)
                {action -> Void in
                }
                actionSheetControllerIOS8.addAction(deleteActionButton)
                
                let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
                { action -> Void in
                    
                }
                actionSheetControllerIOS8.addAction(cancel)
            }
            if(postTop["type"].stringValue == "ended-journey" || postTop["type"].stringValue == "on-the-go-journey") {
                
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
                    globalMyLifeContainerViewController.present(alert, animated: true, completion: nil)
                    
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
            let UnFollow: UIAlertAction = UIAlertAction(title: "UnFollow", style: .default)
            {action -> Void in
            }
            actionSheetControllerIOS8.addAction(UnFollow)
            actionSheetControllerIOS8.addAction(cancelActionButton)
            let reportActionButton: UIAlertAction = UIAlertAction(title: "Report", style: .default)
            {action -> Void in
            }
            actionSheetControllerIOS8.addAction(reportActionButton)
        }
        globalNavigationController.topViewController?.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    
    @IBAction func reviewClicked(_ sender: UIButton) {
        let tapout = UITapGestureRecognizer(target: self, action: #selector(ActivityFeedFooter.reviewTapOut(_:)))
        
        backgroundReview = UIView(frame: (globalNavigationController.topViewController?.view.frame)!)
        backgroundReview.addGestureRecognizer(tapout)
        backgroundReview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        globalNavigationController.topViewController?.view.addSubview(backgroundReview)
        globalNavigationController.topViewController?.view.bringSubview(toFront: backgroundReview)
        
        let rating = AddRating(frame: CGRect(x: 0, y: 0, width: width - 40, height: 335))
        rating.activityJson = postTop
        rating.activity = self
        rating.checkView = "activity"
        
        if postTop["userReview"][0]["rating"] != nil  && postTop["userReview"].count != 0 {
            rating.starCount = postTop["userReview"][0]["rating"].intValue
            rating.ratingDisplay(postTop["userReview"][0])
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
}

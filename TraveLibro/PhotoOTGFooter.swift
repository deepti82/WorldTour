//
//  PhotoOTGFooter.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 28/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Spring

class PhotoOTGFooter: UIView {
    
//    @IBOutlet weak var LineView1: UIView!
    
    
    @IBOutlet weak var lineViewTop: UIView!
    @IBOutlet weak var localLifeTravelImage: UIImageView!
    @IBOutlet weak var footerColorView: UIView!
    var postTop:Post!
    @IBOutlet weak var likeButton: SpringButton!
    @IBOutlet weak var commentButton: SpringButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var likeHeart: UILabel!
    @IBOutlet weak var likeViewLabel: UILabel!
    @IBOutlet weak var commentIcon: UIImageView!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var dropShadow: UIView!
    var PhotoOtg:PhotosOTG2!
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
        let nib = UINib(nibName: "PhotoOTGFooter", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        transparentCardWhite(footerColorView)
        likeButton.tintColor = mainBlueColor
        commentButton.tintColor = mainBlueColor
        shareButton.tintColor = mainBlueColor
        optionButton.tintColor = mainBlueColor
        commentIcon.tintColor = mainBlueColor
        likeButton.contentMode = .scaleAspectFit
//        LineView1.alpha = 0.3
//        footerView.alpha = 0.9
        
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width: -20, height: -20)
//        self.layer.shadowOpacity = 1;
//        self.layer.shadowRadius = 1.0;

        
        shareButton.imageView?.contentMode = .scaleAspectFit
        commentButton.imageView?.contentMode = .scaleAspectFit
        likeButton.imageView?.contentMode = .scaleAspectFit
        
        self.likeHeart.text = String(format: "%C", faicon["likes"]!)
            }
    
    @IBAction func sendComments(_ sender: UIButton) {
        let comment = storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsViewController
        comment.postId = postTop.post_uniqueId
        comment.otherId = postTop.post_ids
        comment.footerView = self;
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
            self.frame.size.height = 85;
            
        }
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:[.bottomRight, .bottomLeft],
                                cornerRadii: CGSize(width: 5, height:  5))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        PhotoOtg.layoutSubviews()
        globalNewTLViewController.addHeightToLayout(height: 500)
        
    }
    
    func setLikeSelected (_ isSelected:Bool) {
        if(isSelected) {
            self.likeButton.tag = 1
            self.likeButton.setImage(UIImage(named: "favorite-heart-button"), for: .normal)
            self.likeButton.tintColor = mainOrangeColor
            
        } else {
            self.likeButton.tag = 0
            self.likeButton.setImage(UIImage(named: "likeButton"), for: .normal)
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
        
        request.likePost(postTop.post_uniqueId, userId: currentUser["_id"].string!, userName: currentUser["name"].string!, unlike: hasLiked, completion: {(response) in
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
        let EditCheckIn: UIAlertAction = UIAlertAction(title: "Edit Activity", style: .default)
        {action -> Void in
            //            self.isEdit = true
            globalNewTLViewController.showEditActivity(self.postTop)
            //print("inside edit check in \(self.addView), \(self.newScroll.isHidden)")
        }
        actionSheetControllerIOS8.addAction(EditCheckIn)
        
        let EditDnt: UIAlertAction = UIAlertAction(title: "Change Date & Time", style: .default)
        { action -> Void in
            globalNewTLViewController.changeDateAndTime(self)
        }
        actionSheetControllerIOS8.addAction(EditDnt)
        let DeletePost: UIAlertAction = UIAlertAction(title: "Delete Activity", style: .default)
        { action -> Void in
            let alert = UIAlertController(title: "", message: "Are you sure you want to delete this Activtiy", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
                globalNewTLViewController.deletePost(self)
            }))
            globalNewTLViewController.present(alert, animated: true, completion: nil)
            
            //  request.deletePost(self.currentPost["_id"].string!, uniqueId: self.myJourney["uniqueId"].string!, user: self.currentPost["user"]["_id"].string!, completion: {(response) in
            //  })
        }
        actionSheetControllerIOS8.addAction(DeletePost)
        let share: UIAlertAction = UIAlertAction(title: "Add Photos/Videos", style: .default)
        { action -> Void in
            globalNewTLViewController.showEditAddActivity(self.postTop)
        }
        actionSheetControllerIOS8.addAction(share)
        globalNavigationController.topViewController?.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
}

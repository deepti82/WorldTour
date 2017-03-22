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

class PhotoOTGFooter: UIView {
    
//    @IBOutlet weak var LineView1: UIView!
    
    
    @IBOutlet weak var shadow: UIView!
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
    let like =  Bundle.main.path(forResource: "tiny1", ofType: "mp3")!
    var audioPlayer = AVAudioPlayer()

    
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
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: like))
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
//            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch{
            print(error)
        }
//         audioPlayer = AVAudioPlayer(contentsOfURL: like, error: nil)
        audioPlayer.prepareToPlay()
        
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
        likeViewLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showLike(_:))))
//        footerColorView.layer.borderWidth = 1.0
//        footerColorView.layer.borderColor = UIColor.black.cgColor
        
        
        
        
//        shadow.layer.borderWidth = 1.0
//        shadow.layer.borderColor = UIColor.black.cgColor
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
    
    func showLike(_ sender: UITapGestureRecognizer) {
        print("fahsldkjfhlaksjdhfalkjsfhlk")
        let feedVC = storyboard!.instantiateViewController(withIdentifier: "likeTable") as! LikeUserViewController
//        feedVC.postId = postTop["_id"].stringValue
        globalNavigationController.pushViewController(feedVC, animated: true)
        
    }
    
//    func showLike(_ sender: UITapGestureRecognizer) {
//        print("in footer tap out \(postTop)")
//        let feedVC = storyboard!.instantiateViewController(withIdentifier: "likeTable") as! LikeUserViewController
//        feedVC.postId = postTop["_id"].stringValue
//        feedVC.type = postTop["type"].stringValue
//        feedVC.title = postTop["name"].stringValue
//        globalNavigationController.pushViewController(feedVC, animated: true)
//    }

    
    
    @IBAction func sendComments(_ sender: UIButton) {
        print("comment clicked")
        if currentUser != nil {

        let comment = storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsViewController
        comment.postId = postTop.post_uniqueId
        comment.ids = postTop.post_ids
        comment.type = "post"
        
        comment.footerViewOtg = self;
        globalNavigationController?.setNavigationBarHidden(false, animated: true)
        globalNavigationController?.pushViewController(comment, animated: true)
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
            self.frame.size.height = 52;
            border1.removeFromSuperlayer()
           border.isHidden = false
            let width = CGFloat(2)
           
            
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
            border.borderColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 0.5).cgColor
            border.borderWidth = width
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
 
        } else {
            self.frame.size.height = 85;
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
        PhotoOtg.layoutSubviews()
        
        

                globalNewTLViewController.addHeightToLayout(height: 500)
        
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
        
        var unLike = false
        if sender.tag == 1 {
            unLike = true
            sender.tag = 0
        }
        else {
            sender.tag = 1
        }
        if !unLike {
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
        
        
        var usr:String = ""
        let userm = User()
        if currentUser["_id"].stringValue == userm.getExistingUser() {
            usr = currentUser["_id"].stringValue
        }else{
            usr = userm.getExistingUser()
        }
        request.likePost(postTop.jsonPost["uniqueId"].stringValue, userId: usr, unlike: unLike,postId: postTop.jsonPost["_id"].stringValue, completion: {(response) in
            print(response);
            DispatchQueue.main.async(execute: {
                if response.error != nil {
                    print("error: \(response.error!.localizedDescription)")
                    if unLike {
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
                else if response["value"].bool! {
                    
                }
                else {
                    
                }
            })
        })
    }
    else {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
    }
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

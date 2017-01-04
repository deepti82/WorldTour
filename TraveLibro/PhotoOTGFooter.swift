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

    var postTop:Post!
    @IBOutlet weak var likeButton: SpringButton!
    @IBOutlet weak var commentButton: SpringButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var likeHeart: UILabel!
    @IBOutlet weak var likeViewLabel: UILabel!
    @IBOutlet weak var commentIcon: UIImageView!
    @IBOutlet weak var commentCount: UILabel!
    
    var likeCount:Int = 0
   
    
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
        
        likeButton.tintColor = mainBlueColor
        commentButton.tintColor = mainBlueColor
        shareButton.tintColor = mainBlueColor
        optionButton.tintColor = mainBlueColor
        commentIcon.tintColor = mainBlueColor
        
        self.likeHeart.text = String(format: "%C", faicon["likes"]!)
        
    }

    @IBAction func sendComments(_ sender: UIButton) {
        let comment = storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsViewController
        comment.postId = postTop.post_uniqueId
        comment.otherId = postTop.post_ids
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
        
    }
    func setCommentCount(_ post_commentCount:Int!) {
        
        if(post_commentCount != nil) {
            if(post_commentCount == 0) {
                self.commentCount.text = "0 Comment"
            } else if(post_commentCount == 1) {
                self.commentCount.text = "1 Comment"
            } else if(post_commentCount > 1) {
                let counts = String(post_commentCount)
                self.commentCount.text = "\(counts) Comments"
            }
        }
    }
    
    func setLikeSelected (_ isSelected:Bool) {
        if(isSelected) {
            self.likeButton.tag = 1
            self.likeButton.setImage(UIImage(named: "favorite-heart-button"), for: .normal)
            self.likeButton.tintColor = mainOrangeColor
        } else {
            self.likeButton.tag = 0
            self.likeButton.setImage(UIImage(named: "like_empty_icon"), for: .normal)
            self.likeButton.tintColor = mainBlueColor
        }
    }
    
    @IBAction func sendLikes(_ sender: UIButton) {
        
        likeButton.animation = "pop"
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
                        self.setLikeSelected(true)
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

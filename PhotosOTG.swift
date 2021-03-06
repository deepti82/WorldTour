//
//  PhotosOTG.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 16/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import ActiveLabel

class PhotosOTG: UIView {

    @IBOutlet weak var postDp: UIImageView!
    @IBOutlet weak var stackView: UIView!
//    @IBOutlet weak var timestampView: UIView!
    @IBOutlet weak var likeHeart: UILabel!
//    @IBOutlet weak var photosTitle: ActiveLabel!
    @IBOutlet weak var photosTitle: ActiveLabel!
    @IBOutlet weak var likeViewLabel: UILabel!
//    @IBOutlet var mainView: UIView!
    @IBOutlet weak var photosStack: UIStackView!
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet var otherPhotosStack: [UIImageView]!
    @IBOutlet weak var whatPostIcon: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var commentIcon: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var photosHC: NSLayoutConstraint!
    
    var likeCount = 0
    
    @IBAction func sendLikes(sender: UIButton) {
            
        print("like button tapped \(sender.titleLabel!.text)")
        
        var hasLiked = false
        
        if sender.tag == 1 {
            
            hasLiked = true
            sender.tag = 0
            
        }
        else {
            
            sender.tag = 1
        }
        
        print("send likes: \(sender.tag) \(hasLiked)")
        
        request.likePost(sender.titleLabel!.text!, userId: currentUser["_id"].string!, userName: currentUser["name"].string!, unlike: hasLiked, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"] {
                    
                    if sender.tag == 1 {
                        
                        sender.setImage(UIImage(named: "favorite-heart-button"), forState: .Normal)
                        self.likeCount += 1
                        self.likeViewLabel.text = "\(self.likeCount) Likes"
                        
                    }
                    else {
                        
                        sender.setImage(UIImage(named: "like_empty_icon"), forState: .Normal)
                        self.likeCount -= 1
                        self.likeViewLabel.text = "\(self.likeCount) Likes"
                        
                    }
                    
                }
                else {
                    
                }
                
            })
            
        })
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        postDp.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])&width=100")!)!)
        makeTLProfilePicture(postDp)
        
        photosTitle.numberOfLines = 0
        let customType = ActiveType.Custom(pattern: "\\swith\\b") //Regex that looks for "with"
        photosTitle.enabledTypes = [.Mention, .Hashtag, .URL, customType]
        photosTitle.textColor = .blackColor()
        photosTitle.handleHashtagTap { hashtag in
            print("Success. You just tapped the \(hashtag) hashtag")
        }
        
        mainPhoto.autoresizingMask = [.FlexibleHeight]
        
        likeHeart.text = String(format: "%C", faicon["likes"]!)
        commentIcon.text = String(format: "%C", faicon["comments"]!)
        clockLabel.text = String(format: "%C", faicon["clock"]!)
        calendarLabel.text = String(format: "%C", faicon["calendar"]!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "PhotosOTG", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}
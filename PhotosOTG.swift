//
//  PhotosOTG.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 16/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Spring

class PhotosOTG: UIView {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var postDp: UIImageView!
    @IBOutlet weak var stackView: UIView!
    @IBOutlet weak var likeHeart: UILabel!
    @IBOutlet weak var photosTitle: ActiveLabel!
    @IBOutlet weak var likeViewLabel: UILabel!
    @IBOutlet weak var photosStack: UIStackView!
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet var otherPhotosStack: [UIImageView]!
    @IBOutlet weak var whatPostIcon: UIButton!
    @IBOutlet weak var lineUp: drawLine!
    
    @IBOutlet weak var likeButton: SpringButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var commentIcon: UIImageView!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var photosHC: NSLayoutConstraint!
    
    var likeCount = 0
    var mapImage: String!
    
    @IBAction func sendLikes(_ sender: UIButton) {
            
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
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    if sender.tag == 1 {
                        sender.setImage(UIImage(named: "favorite-heart-button"), for: .normal)
                        sender.tintColor = mainOrangeColor
                        self.likeCount += 1
                        self.likeViewLabel.text = "\(self.likeCount) Likes"
                        
                    }
                    else {
                        
                        sender.setImage(UIImage(named: "like_empty_icon"), for: .normal)
                        sender.tintColor = mainBlueColor
                        if self.likeCount <= 0 {
                            self.likeCount = 0
                        } else {
                            self.likeCount -= 1
                        }
                        
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
        
        postDp.hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])&width=100")!)
        makeTLProfilePicture(postDp)
        
        bgView.layer.cornerRadius = 5
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = CGSize(width: 2, height: 1)
        
        photosTitle.numberOfLines = 0
        let customType = ActiveType.custom(pattern: "\\swith\\b") //Regex that looks for "with"
        likeButton.tintColor = mainBlueColor
        commentButton.tintColor = mainBlueColor
        shareButton.tintColor = mainBlueColor
        optionsButton.tintColor = mainBlueColor
        commentIcon.tintColor = mainBlueColor
        likeButton.imageView?.contentMode = .scaleAspectFit
        commentButton.imageView?.contentMode = .scaleAspectFit
        shareButton.imageView?.contentMode = .scaleAspectFit
        
        mainPhoto.autoresizingMask = [.flexibleHeight]
        
        likeHeart.text = String(format: "%C", faicon["likes"]!)
        clockLabel.text = String(format: "%C", faicon["clock"]!)
        calendarLabel.text = String(format: "%C", faicon["calendar"]!)
        
        lineUp.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PhotosOTG", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    @IBAction func popEffect(_ sender: SpringButton) {
        likeButton.animation = "pop"
        likeButton.animateTo()
    }
    func setMapImage(mapUrl: String) {
        mainPhoto.hnk_setImageFromURL(URL(string: mapUrl)!)
    }
    func generatePost(_ post: Post) {
        post.getThought()
        self.photosTitle.text = post.finalThought
        
        
        post.getTypeOfPost()
        print(post.typeOfPost);
        if((post.typeOfPost) != nil) {
            switch(post.typeOfPost) {
            case "Location":
                self.whatPostIcon.setImage(UIImage(named: "location_icon"), for: .normal)
            case "Image":
                self.whatPostIcon.setImage(UIImage(named: "camera_icon"), for: .normal)
            case "Videos":
                self.whatPostIcon.setImage(UIImage(named: "video"), for: .normal)
            case "Thoughts":
                self.whatPostIcon.setImage(UIImage(named: "pen_icon"), for: .normal)
            default:
                break
            }
        }
    }
}

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

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var postDp: UIImageView!
    @IBOutlet weak var stackView: UIView!
//    @IBOutlet weak var timestampView: UIView!
    @IBOutlet weak var likeHeart: UILabel!
//    @IBOutlet weak var photosTitle: ActiveLabel!
    @IBOutlet weak var photosTitle: UILabel!
    @IBOutlet weak var likeViewLabel: UILabel!
//    @IBOutlet var mainView: UIView!
    @IBOutlet weak var photosStack: UIStackView!
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet var otherPhotosStack: [UIImageView]!
    @IBOutlet weak var whatPostIcon: UIButton!
    @IBOutlet weak var lineUp: drawLine!
    
    @IBOutlet weak var likeButton: UIButton!
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
                        
                        sender.setImage(UIImage(named: "favorite-heart-button"), for: UIControlState())
                        self.likeCount += 1
                        self.likeViewLabel.text = "\(self.likeCount) Likes"
                        
                    }
                    else {
                        
                        sender.setImage(UIImage(named: "like_empty_icon"), for: UIControlState())
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
        
        postDp.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])&width=100")!))
        makeTLProfilePicture(postDp)
        
        bgView.layer.cornerRadius = 5
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = CGSize(width: 1, height: 1)
        
//        photosTitle.numberOfLines = 0
//        let customType = ActiveType.custom(pattern: "\\swith\\b") //Regex that looks for "with"
//        photosTitle.enabledTypes = [.mention, .hashtag, .url, customType]
//        photosTitle.textColor = UIColor.black
//        photosTitle.handleHashtagTap { hashtag in
//            print("Success. You just tapped the \(hashtag) hashtag")
//        }
        
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

}

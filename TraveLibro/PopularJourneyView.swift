//
//  PopularJourneysView.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 23/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Spring

class PopularJourneyView: UIView {

    @IBOutlet weak var followHideShow: UIButton!
    @IBOutlet weak var follow: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!    
    @IBOutlet weak var journeyStartTime: UILabel!
    @IBOutlet weak var journetStartDate: UILabel!
    @IBOutlet weak var journeyCreatorLabel: UILabel!
    @IBOutlet weak var journeyCreatorImage: UIImageView!
    
    @IBOutlet weak var TitleLabelView: UIView!
    @IBOutlet weak var journeyTitleLabel: UILabel!
    @IBOutlet weak var journeyDescription: UILabel!
    
    @IBOutlet weak var commentLabelFA: UILabel!
    @IBOutlet weak var flag1: UIImageView!
    @IBOutlet weak var flag2: UIImageView!
    @IBOutlet weak var flag3: UIImageView!
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var commentButton: SpringButton!
    @IBOutlet weak var likeButton: SpringButton!
    @IBAction func followButton(_ sender: AnyObject) {
        
        follow.setTitle("Following", for: UIControlState())
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        makeTLProfilePictureBorderWhiteCorner(flag1)
        makeTLProfilePictureBorderWhiteCorner(flag2)
        makeTLProfilePictureBorderWhiteCorner(flag3)
       makeBuddiesTLProfilePicture(journeyCreatorImage)
        calendarLabel.text = String(format: "%C", faicon["clock"]!)
        clockLabel.text = String(format: "%C", faicon["calendar"]!)
        likeLabel.text = String(format: "%C", faicon["likes"]!)       
        commentButton.tintColor = mainBlueColor
        likeButton.tintColor = mainBlueColor
        TitleLabelView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
//        followHideShow.isHidden = true
        mainPhoto.layer.zPosition = -10
        
        cardView.layer.cornerRadius = 5
        //cardView.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PopularJourneyView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }

    @IBAction func likeButtonTap(_ sender: UIButton) {
        
        if currentUser != nil {
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
            
            print("\n hasLiked: \(hasLiked)")
        }
            
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
    }
    
    @IBAction func commentButtonTap(_ sender: UIButton) {
        
        if currentUser != nil {
            //Do some action
        }
            
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
        
    }
}

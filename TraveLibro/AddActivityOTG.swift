//
//  AddActivityOTG.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 9/9/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class AddActivityOTG: UIView {

    @IBOutlet weak var checkInCategoryEdit: UIButton!
    @IBOutlet weak var checkInCategory: UILabel!
    @IBOutlet weak var checkInPlace: UILabel!
    @IBOutlet weak var checkInMainView: UIView!
    
    @IBOutlet weak var photosCount: UILabel!
    @IBOutlet weak var photoOne: UIImageView!
    @IBOutlet weak var photoTwo: UIImageView!
    @IBOutlet weak var photoThree: UIImageView!
    @IBOutlet weak var photoFour: UIImageView!
    @IBOutlet weak var photosMainView: UIView!
    
    @IBOutlet weak var videosCount: UILabel!
    @IBOutlet weak var videoOne: UIImageView!
    @IBOutlet weak var videoTwo: UIImageView!
    @IBOutlet weak var videoThree: UIImageView!
    @IBOutlet weak var videoFour: UIImageView!
    @IBOutlet weak var videosMainView: UIView!
    
    @IBOutlet weak var thoughtsText: UITextView!
    @IBOutlet weak var thoughtsCharacterCount: UILabel!
    @IBOutlet weak var thoughtsMainView: UIView!
    
    @IBOutlet weak var tagFriends: UILabel!
    @IBOutlet weak var friendsCount: UIButton!
    @IBOutlet weak var friendsMainView: UIView!
    
    @IBOutlet weak var fbShare: UIButton!
    @IBOutlet weak var whatsappShare: UIButton!
    @IBOutlet weak var googleShare: UIButton!
    @IBOutlet weak var twitterShare: UIButton!
    @IBOutlet weak var moreShare: UIButton!
    
    @IBOutlet weak var postButton: UIButton!
    
    var blurViewTwo: UIVisualEffectView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        postButton.layer.cornerRadius = 5
        postButton.layer.borderColor = UIColor.whiteColor().CGColor
        postButton.layer.borderWidth = 2.0
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame.size.height = self.frame.height
        blurView.frame.size.width = self.frame.width
        blurView.layer.zPosition = -1
        blurView.userInteractionEnabled = false
        self.addSubview(blurView)
        
        let lightBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurViewTwo = UIVisualEffectView(effect: lightBlur)
        blurViewTwo.layer.zPosition = -1
        blurViewTwo.userInteractionEnabled = false
        
        getStylesOn(checkInMainView)
        getStylesOn(photosMainView)
        getStylesOn(videosMainView)
        getStylesOn(thoughtsMainView)
        getStylesOn(friendsMainView)
        
        let edit = String(format: "%C", faicon["edit"]!)
        checkInCategoryEdit.setTitle(edit, forState: .Normal)
        
//        blurViewTwo.frame.size.height = photosMainView.frame.height
//        blurViewTwo.frame.size.width = photosMainView.frame.width
//        photosMainView.addSubview(blurViewTwo)
//        
//        blurViewTwo.frame.size.height = videosCount.frame.height
//        blurViewTwo.frame.size.width = videosCount.frame.width
//        videosCount.addSubview(blurViewTwo)
//        
//        blurViewTwo.frame.size.height = thoughtsMainView.frame.height
//        blurViewTwo.frame.size.width = thoughtsMainView.frame.width
//        thoughtsMainView.addSubview(blurViewTwo)
//        
//        blurViewTwo.frame.size.height = friendsMainView.frame.height
//        blurViewTwo.frame.size.width = friendsMainView.frame.width
//        friendsMainView.addSubview(blurViewTwo)
        
//        blurViewTwo.frame.size.height = checkInMainView.frame.height
//        blurViewTwo.frame.size.width = checkInMainView.frame.width
//        checkInMainView.addSubview(blurViewTwo)
        
        
//        self.layer.opacity = 0.0
        
        
    }
    
    func getStylesOn(view: UIView) {
        
        view.layer.cornerRadius = 5
        blurViewTwo.frame.size.height = view.frame.height
        blurViewTwo.frame.size.width = view.frame.width
        view.addSubview(blurViewTwo)
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 2
        view.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "AddActivityOTG", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

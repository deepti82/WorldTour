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
    @IBOutlet weak var timestampView: UIView!
    @IBOutlet weak var likeHeart: UILabel!
//    @IBOutlet weak var photosTitle: ActiveLabel!
    @IBOutlet weak var photosTitle: ActiveLabel!
    @IBOutlet weak var likeView: UILabel!
    @IBOutlet weak var likeViewLabel: UILabel!
    @IBOutlet var mainView: UIView!
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let timestamp = DateAndTime(frame: CGRect(x: 0, y: 0, width: 200, height: timestampView.frame.size.height))
        timestampView.addSubview(timestamp)
        
//        let sideIcon = IconButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//        sideIcon.center = CGPointMake(self.frame.size.width - 30, 10)
//        mainView.addSubview(sideIcon)
        postDp.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])&width=100")!)!)
        makeTLProfilePicture(postDp)
        
        photosTitle.numberOfLines = 0
        let customType = ActiveType.Custom(pattern: "\\swith\\b") //Regex that looks for "with"
        photosTitle.enabledTypes = [.Mention, .Hashtag, .URL, customType]
        photosTitle.textColor = .blackColor()
        photosTitle.handleHashtagTap { hashtag in
            print("Success. You just tapped the \(hashtag) hashtag")
        }
        
        likeViewLabel.textColor = mainBlueColor
        
        likeHeart.font = UIFont(name: "FontAwesome", size: 12)
        likeHeart.text = String(format: "%C", faicon["likes"]!)
        
        let seperatorLine = drawSeperatorLineTwo(frame: CGRect(x: 10, y: line1.frame.size.height/2, width: self.frame.size.width - 25, height: 10))
        seperatorLine.backgroundColor = UIColor.clearColor()
        line1.addSubview(seperatorLine)
        
        let seperatorLineTwo = drawSeperatorLineTwo(frame: CGRect(x: 10, y: line2.frame.size.height/3, width: self.frame.size.width - 25, height: 10))
        seperatorLineTwo.backgroundColor = UIColor.clearColor()
        line2.addSubview(seperatorLineTwo)
        
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
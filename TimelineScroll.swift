//
//  TImelineScroll.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 16/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class TimelineScroll: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let textLabel = UILabel(frame: CGRect(x: 50, y: 120, width: 200, height: 100))
        self.addSubview(textLabel)
        
        let locationImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width/4, height: 40))
        locationImage.center = CGPointMake(self.frame.size.width/2, 150)
        locationImage.image = UIImage(named: "you_are_in_image")
        self.addSubview(locationImage)
        
        let info = TripInfoView(frame: CGRect(x: 0, y: 170, width: self.frame.size.width, height: self.frame.size.width - 60))
        info.layer.cornerRadius = 10
        info.layer.shadowColor = UIColor.blackColor().CGColor
        info.layer.shadowOffset = CGSizeZero
        info.layer.shadowOpacity = 0.2
        self.addSubview(info)
        
        
        let bubble = SpeechBubbleView(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
        bubble.center = CGPointMake(self.frame.size.width/2, 700)
        self.addSubview(bubble)
        
        let photosOne = PhotosOTG(frame: CGRect(x: 0, y: 900, width: self.frame.size.width, height: 535))
        self.addSubview(photosOne)
        
        let photosTwo = OnlyPhoto(frame: CGRect(x: 0, y: 1500, width: self.frame.size.width, height: 475))
        self.addSubview(photosTwo)
        
        let cloudPatch = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 25))
        cloudPatch.center = CGPointMake(self.frame.size.width/2, 2145)
        cloudPatch.backgroundColor = UIColor(red: 207/255, green: 237/255, blue: 250/255, alpha: 1)
        self.addSubview(cloudPatch)
        
        let ratingIcon = IconButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        ratingIcon.center = CGPointMake(self.frame.size.width/2, 2100)
        ratingIcon.button.backgroundColor = UIColor(red: 17/255, green: 211/255, blue: 205/255, alpha: 1)
        ratingIcon.button.setImage(UIImage(named: "sad_smiley_icon"), forState: .Normal)
        ratingIcon.layer.cornerRadius = 15
        ratingIcon.clipsToBounds = true
        self.addSubview(ratingIcon)
        
        let ratingIconLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        ratingIconLabel.center = CGPointMake(self.frame.size.width/2, 2145)
        ratingIconLabel.text = "Reviewed In Love"
        ratingIconLabel.font = UIFont(name: "Avenir-Roman", size: 12)
        ratingIconLabel.textColor = mainBlueColor
        self.addSubview(ratingIconLabel)
        
        let photosThree = StatusView(frame: CGRect(x: 0, y: 2250, width: self.frame.size.width, height: 160))
        self.addSubview(photosThree)
        
        let cloudPatchTwo = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 25))
        cloudPatchTwo.center = CGPointMake(self.frame.size.width/2, 2535)
        cloudPatchTwo.backgroundColor = UIColor(red: 207/255, green: 237/255, blue: 250/255, alpha: 1)
        self.addSubview(cloudPatchTwo)
        
        let ratingIconTwo = IconButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        ratingIconTwo.center = CGPointMake(self.frame.size.width/2, 2500)
        ratingIconTwo.button.setImage(UIImage(named: "star_rate_icon"), forState: .Normal)
        self.addSubview(ratingIconTwo)
        
        let ratingIconLabelTwo = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        ratingIconLabelTwo.center = CGPointMake(self.frame.size.width/2, 2530)
        ratingIconLabelTwo.text = "Rate Girgaon?"
        ratingIconLabelTwo.textAlignment = .Center
        ratingIconLabelTwo.font = UIFont(name: "Avenir-Roman", size: 12)
        ratingIconLabelTwo.textColor = mainBlueColor
        self.addSubview(ratingIconLabelTwo)
        
        let addFriend = AddFriendOTG(frame: CGRect(x: 0, y: 0, width: 338, height: 255))
        addFriend.center = CGPointMake(self.frame.size.width/2, 2750)
        self.addSubview(addFriend)
        
        let photosFour = OnlyPhoto(frame: CGRect(x: 0, y: 3000, width: self.frame.size.width, height: 475))
        photosFour.photosTitle.removeFromSuperview()
        self.addSubview(photosFour)
        
        let newPlaceLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width/3, height: 50))
        newPlaceLabel.center = CGPointMake(self.frame.size.width/2, 3550)
        let angle:CGFloat = (-10.0 * 3.14/180.0) as CGFloat
        let rotation = CGAffineTransformMakeRotation(angle)
        newPlaceLabel.transform = rotation
        newPlaceLabel.text = "Edinburg"
        newPlaceLabel.font = UIFont(name: "Avenir-Black", size: 14)
        newPlaceLabel.textColor = UIColor.whiteColor()
        newPlaceLabel.backgroundColor = mainOrangeColor
        newPlaceLabel.layer.cornerRadius = 10
        newPlaceLabel.clipsToBounds = true
        newPlaceLabel.textAlignment = .Center
        self.addSubview(newPlaceLabel)
        
        let newPlaceTimestamp = DateAndTime(frame: CGRect(x: 0, y: 0, width: 200, height: 25))
        newPlaceTimestamp.center = CGPointMake(self.frame.size.width/2, 3600)
        self.addSubview(newPlaceTimestamp)
        
        let photosFive = OnlyPhoto(frame: CGRect(x: 0, y: 3750, width: self.frame.size.width, height: 475))
        photosFive.photosTitle.removeFromSuperview()
        self.addSubview(photosFive)
        
        let videoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 100))
        videoLabel.center = CGPointMake(photosFive.mainPhoto.frame.size.width/2, photosFive.mainPhoto.frame.size.height/2)
        videoLabel.font = UIFont(name: "FontAwesome", size: 56)
        videoLabel.text = String(format: "%C", faicon["videoPlay"]!)
        videoLabel.textColor = mainOrangeColor
        videoLabel.textAlignment = .Center
        photosFive.mainPhoto.addSubview(videoLabel)
        
        let byeFriend = SayBye(frame: CGRect(x: 0, y: 0, width: 250, height: 210))
        byeFriend.center = CGPointMake(self.frame.size.width/2, 4400)
        self.addSubview(byeFriend)
        
        let photosSix = OnlyPhoto(frame: CGRect(x: 0, y: 4600, width: self.frame.size.width, height: 475))
        self.addSubview(photosSix)
        
        
        let cloudPatchThree = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 25))
        cloudPatchThree.center = CGPointMake(self.frame.size.width/2, 5185)
        cloudPatchThree.backgroundColor = UIColor(red: 207/255, green: 237/255, blue: 250/255, alpha: 1)
        self.addSubview(cloudPatchThree)
        
        let ratingIconThree = IconButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        ratingIconThree.center = CGPointMake(self.frame.size.width/2, 5150)
        ratingIconThree.button.setImage(UIImage(named: "star_rate_icon"), forState: .Normal)
        self.addSubview(ratingIconThree)
        
        let ratingIconLabelThree = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        ratingIconLabelThree.center = CGPointMake(self.frame.size.width/2, 5180)
        ratingIconLabelThree.text = "Rate Girgaon?"
        ratingIconLabelThree.textAlignment = .Center
        ratingIconLabelThree.font = UIFont(name: "Avenir-Roman", size: 12)
        ratingIconLabelThree.textColor = mainBlueColor
        self.addSubview(ratingIconLabelThree)
        
        let newPlaceLabelTwo = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 60))
        newPlaceLabelTwo.center = CGPointMake(self.frame.size.width/2, 5300)
        newPlaceLabelTwo.text = "Mumbai"
        newPlaceLabelTwo.font = UIFont(name: "Avenir-Black", size: 17)
        newPlaceLabelTwo.textColor = UIColor.whiteColor()
        newPlaceLabelTwo.backgroundColor = mainOrangeColor
        newPlaceLabelTwo.layer.cornerRadius = 10
        newPlaceLabelTwo.clipsToBounds = true
        newPlaceLabelTwo.textAlignment = .Center
        self.addSubview(newPlaceLabelTwo)
        
        let newPlaceTimestampTwo = DateAndTime(frame: CGRect(x: 0, y: 0, width: 200, height: 25))
        newPlaceTimestampTwo.center = CGPointMake(newPlaceLabelTwo .frame.size.width/2, newPlaceLabelTwo.frame.size.height-10)
        newPlaceLabelTwo.addSubview(newPlaceTimestampTwo)
        
        let cloudPatchFour = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 25))
        cloudPatchFour.center = CGPointMake(self.frame.size.width/2, 5480)
        cloudPatchFour.backgroundColor = UIColor(red: 207/255, green: 237/255, blue: 250/255, alpha: 1)
        self.addSubview(cloudPatchFour)
        
        let ratingIconFour = IconButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        ratingIconFour.center = CGPointMake(self.frame.size.width/2, 5450)
        ratingIconFour.button.setImage(UIImage(named: "flag_icon"), forState: .Normal)
        ratingIconFour.layer.cornerRadius = ratingIconFour.frame.size.height/2
        ratingIconFour.button.backgroundColor = mainBlueColor
        ratingIconFour.clipsToBounds = true
        self.addSubview(ratingIconFour)
        
        let ratingIconLabelFour = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        ratingIconLabelFour.center = CGPointMake(self.frame.size.width/2, 5480)
        ratingIconLabelFour.text = "until we meet again!"
        ratingIconLabelFour.textAlignment = .Center
        ratingIconLabelFour.font = UIFont(name: "Avenir-Roman", size: 12)
        ratingIconLabelFour.textColor = mainBlueColor
        self.addSubview(ratingIconLabelFour)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "TimelineScroll", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

//
//  RatingCheckIn.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 08/10/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class RatingCheckIn: UIView {
    
    @IBOutlet weak var line: drawLine!
    @IBOutlet weak var rateCheckInLabel: UILabel!
    @IBOutlet weak var rateCheckInButton: UIButton!
    var photosOtg:PhotosOTG2!
    var backgroundReview:UIView!
    var review:JSON!
    let moodArr = ["Disappointed", "Sad", "Good", "Super", "In Love"]
    let imageArr = ["disapointed", "sad", "good", "superface", "love"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        print("rating rev..")
        
        rateCheckInLabel.shadowColor = UIColor.black
        rateCheckInLabel.shadowOffset = CGSize(width: 0.8, height: 0.8)
//        rateCheckInLabel.layer.shadowOpacity = 0.8
        rateCheckInLabel.layer.masksToBounds = true
        line.backgroundColor = UIColor.clear
        
        rateCheckInButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        rateCheckInButton.setTitle("", for: .normal)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RatingCheckIn", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
//        print(self.photosOtg)
//        print(photosOtg.postTop.jsonPost["review"])
//        if( photosOtg.postTop.jsonPost["review"] != nil && (photosOtg.postTop.jsonPost["review"].array?.count)! > 0 ) {
//            let num = Int(self.review["rating"].stringValue)! - 1
//            self.review = photosOtg.postTop.jsonPost["review"].arrayValue[0]
//            self.rateCheckInButton.setImage(UIImage(named:imageArr[ num ]  ), for: UIControlState())
//        }
    }
    
    @IBAction func ratePost(_ sender: Any) {
        backgroundReview = UIView(frame: (globalNavigationController.topViewController?.view.frame)!)

        backgroundReview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        globalNavigationController.topViewController?.view.addSubview(backgroundReview)
        globalNavigationController.topViewController?.view.bringSubview(toFront: backgroundReview)

        let rating = AddRating(frame: CGRect(x: 0, y: 0, width: width - 40, height: 335))
        rating.post = photosOtg.postTop
        rating.checkIn = self
        rating.json = self.review
        rating.starCount = Int(review["rating"].stringValue)!
        rating.ratingDisplay(rating.json)
        
        rating.center = backgroundReview.center
        rating.layer.cornerRadius = 5
        rating.clipsToBounds = true
        rating.navController = globalNavigationController
        backgroundReview.addSubview(rating)
    }
    
    func reviewTapOut(_ sender: UITapGestureRecognizer) {
        backgroundReview.removeFromSuperview()
    }
    func modifyAsReview() {
        let num = Int(review["rating"].stringValue)! - 1
        self.rateCheckInButton.setImage(UIImage(named:imageArr[num]), for: UIControlState() )
        self.rateCheckInLabel.text = moodArr[num]
    }
    
    func modifyAsReview(num:Int) {
        print(num)
        self.rateCheckInButton.setImage(UIImage(named:imageArr[num]), for: UIControlState() )
        self.rateCheckInLabel.text = moodArr[num]
    }
    
    
}

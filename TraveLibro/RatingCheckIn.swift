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
        rateCheckInLabel.shadowColor = UIColor.black
        rateCheckInLabel.shadowOffset = CGSize(width: 0.5, height: 0.5)
        rateCheckInLabel.layer.shadowOpacity = 0.6
        rateCheckInLabel.layer.shadowRadius = 1.0
//        rateCheckInLabel.layer.shadowOpacity = 0.3
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
        if isUserMe(user: currentUser["_id"].stringValue) {
            let tapout = UITapGestureRecognizer(target: self, action: #selector(RatingCheckIn.reviewTapOut(_:)))
            
            backgroundReview = UIView(frame: (globalNavigationController.topViewController?.view.frame)!)
            backgroundReview.addGestureRecognizer(tapout)
            backgroundReview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            globalNavigationController.topViewController?.view.addSubview(backgroundReview)
            globalNavigationController.topViewController?.view.bringSubview(toFront: backgroundReview)
            
            let rating = AddRating(frame: CGRect(x: 0, y: 0, width: width - 40, height: 335))
            rating.post = photosOtg.postTop
            rating.checkIn = self
            rating.json = self.review
            print("get Review \(rating.json)")
            if review != nil  {
                rating.starCount = Int(review["rating"].stringValue)!
                rating.ratingDisplay(rating.json)
                
            }else{
                rating.starCount = 1
                
            }
            
            rating.center = backgroundReview.center
            rating.layer.cornerRadius = 5
            rating.clipsToBounds = true
            rating.navController = globalNavigationController
            backgroundReview.addSubview(rating)
        }
        
    }
    
    func reviewTapOut(_ sender: UITapGestureRecognizer) {
        backgroundReview.removeFromSuperview()
    }
    func modifyAsReview() {
        let num = Int(review["rating"].stringValue)!
        self.rateCheckInButton.setImage(UIImage(named:imageArr[num - 1]), for: UIControlState() )
        self.rateCheckInLabel.text = moodArr[num - 1]
    }
    
    func modifyAsReview(num:Int, reviewR:String) {
        print(num)
        print("reviewwww")
        print(reviewR)
        self.rateCheckInButton.setImage(UIImage(named:imageArr[num - 1]), for: UIControlState())
        self.rateCheckInButton.setBackgroundImage(UIImage(named:"box8"), for: UIControlState())
        self.rateCheckInLabel.text = moodArr[num - 1]
        review = ["rating":"\(num)", "review":reviewR]
    }
    
    
}

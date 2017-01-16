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

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
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
    }
    
    @IBAction func ratePost(_ sender: Any) {
        let tapout = UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.reviewTapOut(_:)))
        
        backgroundReview = UIView(frame: (globalNavigationController.topViewController?.view.frame)!)
        backgroundReview.addGestureRecognizer(tapout)
        backgroundReview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        globalNavigationController.topViewController?.view.addSubview(backgroundReview)
        globalNavigationController.topViewController?.view.bringSubview(toFront: backgroundReview)
        
        let rating = AddRating(frame: CGRect(x: 0, y: 0, width: width - 40, height: 335))
        rating.center = backgroundReview.center
        rating.layer.cornerRadius = 5
        rating.clipsToBounds = true
        rating.navController = globalNavigationController
        backgroundReview.addSubview(rating)
    }
    
//    func addRatingPost(_ sender: UIButton) {
//        let tapout = UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.reviewTapOut(_:)))
//        
//        backgroundReview = UIView(frame: (globalNavigationController.topViewController?.view.frame)!)
//        backgroundReview.addGestureRecognizer(tapout)
//        backgroundReview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
//        globalNavigationController.topViewController?.view.addSubview(backgroundReview)
//        globalNavigationController.topViewController?.view.bringSubview(toFront: backgroundReview)
//        
//        let rating = AddRating(frame: CGRect(x: 0, y: 0, width: width - 40, height: 335))
//        rating.center = backgroundReview.center
//        rating.layer.cornerRadius = 5
//        rating.postReview.setTitle(sender.titleLabel!.text!, for: .application)
//        rating.clipsToBounds = true
//        rating.navController = globalNavigationController
//        backgroundReview.addSubview(rating)
//    }
    
    func reviewTapOut(_ sender: UITapGestureRecognizer) {
        
        backgroundReview.removeFromSuperview()
        
    }
    
}

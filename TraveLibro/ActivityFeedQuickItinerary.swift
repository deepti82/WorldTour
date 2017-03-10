//
//  ActivityFeedQuickItinerary.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 19/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class ActivityFeedQuickItinerary: UIView {

    @IBOutlet var activityFeedQuickView: UIView!
    @IBOutlet weak var activityFeedQuickThree: UIImageView!
    @IBOutlet weak var activityQuickFlagTwo: UIImageView!
    @IBOutlet weak var activityQuickFlagOne: UIImageView!
    @IBOutlet weak var activityQuickCoverPic: UIImageView!
    @IBOutlet var ActivityQuickFlagCollection: [UIImageView]!
    @IBOutlet weak var countryStackView: UIStackView!
    @IBOutlet weak var activityFeedItineraryName: UILabel!
    @IBOutlet weak var activityFeedYear: UILabel!
    @IBOutlet weak var activityFeedDaysCount: UILabel!
    @IBOutlet weak var categoryStackView: UIStackView!
    @IBOutlet weak var categoryOne: UIImageView!
    @IBOutlet weak var categoryTwo: UIImageView!
    @IBOutlet weak var categoryThree: UIImageView!
    
    @IBOutlet var quickBadge: UILabel!
    @IBOutlet weak var dayText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
//        quickBadge.clipsToBounds = true
//        quickBadge.layer.cornerRadius = 10
        transparentCardWhite(activityFeedQuickView)
        makeTLProfilePictureBorderWhiteCorner(activityQuickFlagOne)
        makeTLProfilePictureBorderWhiteCorner(activityQuickFlagTwo)
        makeTLProfilePictureBorderWhiteCorner(activityFeedQuickThree)
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.quickBadge.frame
        rectShape.position = self.quickBadge.center
        rectShape.path = UIBezierPath(roundedRect: self.quickBadge.bounds, byRoundingCorners: [.topRight , .topLeft], cornerRadii: CGSize(width: 5, height: 5)).cgPath
        
        self.quickBadge.layer.backgroundColor = UIColor.green.cgColor
        self.quickBadge.layer.mask = rectShape
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fillData(feed:JSON) {
        activityFeedYear.text = feed["month"].stringValue + " " + feed["year"].stringValue
        activityFeedYear.sizeToFit()
        activityFeedDaysCount.text = feed["duration"].stringValue
        
        if feed["duration"] > 1 {
            dayText.text = "Days"
        } else {
            dayText.text = "Day"
        }
        
        for country in countryStackView.subviews {
            country.isHidden = true
        }
        if feed["countryVisited"][0] != nil {
            activityQuickFlagOne.isHidden = false
            activityQuickFlagOne.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["countryVisited"][0]["country"]["flag"])", width: 100))
        }
        if feed["countryVisited"][1] != nil {
            activityQuickFlagTwo.isHidden = false
            activityQuickFlagTwo.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["countryVisited"][1]["country"]["flag"])", width: 100))
        }
        if feed["countryVisited"][2] != nil {
            activityFeedQuickThree.isHidden = false
            activityFeedQuickThree.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["countryVisited"][2]["country"]["flag"])", width: 100))
        }
        
        //  CATEGOTY
        for category in categoryStackView.subviews {
            category.isHidden = true
        }
        if feed["itineraryType"][0] != nil {
            categoryOne.isHidden = false
            categoryOne.image = UIImage(named: categoryImage(feed["itineraryType"][0].stringValue))
            categoryOne.tintColor = UIColor.white
        }
        if feed["itineraryType"][1] != nil {
            categoryTwo.isHidden = false
            categoryTwo.image = UIImage(named: categoryImage(feed["itineraryType"][1].stringValue))
            categoryTwo.tintColor = UIColor.white
        }
        if feed["itineraryType"][2] != nil {
            categoryThree.isHidden = false
            categoryThree.image = UIImage(named: categoryImage(feed["itineraryType"][2].stringValue))
            categoryThree.tintColor = UIColor.white
        }

        
        activityFeedItineraryName.text = feed["name"].stringValue
        
        if feed["coverPhoto"] != nil && feed["coverPhoto"] != "" {
            activityQuickCoverPic.hnk_setImageFromURL(getImageURL(feed["coverPhoto"].stringValue, width: 300))
        }else{
            if feed["photos"] != nil && feed["photos"] != "" {
                activityQuickCoverPic.hnk_setImageFromURL(getImageURL(feed["photos"][0]["name"].stringValue, width: 300))
            }else{
                if feed["startLocationPic"] != nil && feed["startLocationPic"] != "" {

                    activityQuickCoverPic.hnk_setImageFromURL(getImageURL(feed["startLocationPic"].stringValue, width: 300))

                }else{

                    activityQuickCoverPic.image = UIImage(named: "logo-default")

                }
            }
        }
        
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ActivityFeedQuickItinerary", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
    }

}


//
//  PopularItinerary.swift
//  TraveLibro
//
//  Created by Jagruti  on 16/03/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class PopularItinerary: UIView {

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
    @IBOutlet weak var creatorPic: UIImageView!
    @IBOutlet weak var creatorName: UILabel!
    
    @IBOutlet weak var gradiantView: UIView!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var dayText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        makeTLProfilePictureFollowers(creatorPic)
        
        let gradient = CAGradientLayer()
        
        let blackColour = UIColor.black.withAlphaComponent(0.8).cgColor as CGColor
        let transparent = UIColor.clear.cgColor as CGColor
        
        gradient.frame = self.gradiantView.bounds
        gradient.frame.size.width = gradiantView.frame.width + 40
        gradient.colors = [blackColour, transparent]
        gradient.locations = [0.0, 0.75]
        
        self.gradiantView.layer.addSublayer(gradient)

        
        transparentCardWhite(activityFeedQuickView)
        makeFlagBorderWhiteCorner(activityQuickFlagOne)
        makeFlagBorderWhiteCorner(activityQuickFlagTwo)
        makeFlagBorderWhiteCorner(activityFeedQuickThree)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fillData(feed:JSON) {
        
        activityFeedYear.text = "\(feed["startTimeApp"].stringValue) to \(feed["endTimeApp"].stringValue)"
        creatorName.text = feed["creator"]["name"].stringValue
        creatorPic.hnk_setImageFromURL(getImageURL(feed["creator"]["profilePicture"].stringValue, width: 200))
        
        activityFeedDaysCount.text = feed["duration"].stringValue
        
        if feed["currency"] != nil && feed["currency"].stringValue != "null" {
            budget.text?.append(feed["currency"].stringValue)
        }
        if (feed["cost"] != nil) && (feed["cost"] != 0) {
            budget.text = feed["cost"].stringValue
        }
        
        
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
        let nib = UINib(nibName: "PopularItinerary", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
    }

}

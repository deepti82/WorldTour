//
//  ActivityDetailItinerary.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 19/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class ActivityDetailItinerary: UIView {

   
    @IBOutlet var activityDetailItineraryView: UIView!
    @IBOutlet weak var detailItineraryImage: UIImageView!
    @IBOutlet weak var detailItineraryCost: UILabel!
    @IBOutlet weak var detailItineraryDays: UILabel!
    @IBOutlet weak var blueBoxImage: UIImageView!
    @IBOutlet weak var detailItineraryName: UILabel!
    @IBOutlet weak var detailFlagOne: UIImageView!
    @IBOutlet weak var detailFlagTwo: UIImageView!
    @IBOutlet weak var detailFlagThree: UIImageView!
    @IBOutlet var detailFlagsCollection: [UIImageView]!
    @IBOutlet weak var countryStackView: UIStackView!
    @IBOutlet weak var categoryStackView: UIStackView!
    @IBOutlet weak var categoryOne: UIImageView!
    @IBOutlet weak var categoryTwo: UIImageView!
    @IBOutlet weak var categoryThree: UIImageView!
    @IBOutlet weak var dayText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        transparentCardWhite(activityDetailItineraryView)
        makeTLProfilePictureBorderWhiteCorner(detailFlagOne)
        makeTLProfilePictureBorderWhiteCorner(detailFlagTwo)
        makeTLProfilePictureBorderWhiteCorner(detailFlagThree)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fillData(feed:JSON) {
        if feed["duration"] != nil {
            
            detailItineraryDays.text = feed["duration"].stringValue
            
        }
        
        if feed["duration"] > 1 {
            dayText.text = "Days"
        }else{
            dayText.text = "Day"
        }

        for country in countryStackView.subviews {
            country.isHidden = true
        }
        if feed["countryVisited"][0] != nil {
            detailFlagOne.isHidden = false
            detailFlagOne.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["countryVisited"][0]["country"]["flag"])", width: 100))
        }
        if feed["countryVisited"][1] != nil {
            detailFlagTwo.isHidden = false
            detailFlagTwo.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["countryVisited"][1]["country"]["flag"])", width: 100))
        }
        if feed["countryVisited"][2] != nil {
            detailFlagThree.isHidden = false
            detailFlagThree.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["countryVisited"][2]["country"]["flag"])", width: 100))
        }
        
        //  CATEGOTY
        for category in categoryStackView.subviews {
            category.isHidden = true
        }
        if feed["itineraryType"][0] != nil {
            categoryOne.isHidden = false
            categoryOne.image = UIImage(named: (feed["itineraryType"][0].stringValue).lowercased())
            categoryOne.tintColor = UIColor.white

        }
        if feed["itineraryType"][1] != nil {
            categoryTwo.isHidden = false
            categoryThree.image = UIImage(named: (feed["itineraryType"][1].stringValue).lowercased())
            categoryThree.tintColor = UIColor.white

        }
        if feed["itineraryType"][2] != nil {
            categoryThree.isHidden = false
            categoryThree.image = UIImage(named: (feed["itineraryType"][2].stringValue).lowercased())
            categoryThree.tintColor = UIColor.white

        }
        

        
        detailItineraryName.text = feed["name"].stringValue
        if feed["cost"].intValue == 0 {
            detailItineraryCost.text = ""
        }
        else {
            detailItineraryCost.text = feed["currency"].stringValue + " " + feed["cost"].stringValue
        }
        detailItineraryCost.sizeToFit()
        
//        CameraCount.text = feed["photoCount"].stringValue
//        videoCount.text = feed["videoCount"].stringValue
//        checkInCount.text = feed["checkInCount"].stringValue
        
        if feed["coverPhoto"] != nil && feed["coverPhoto"] != "" {
            detailItineraryImage.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["coverPhoto"])", width: 100))
        }else{
            if feed["photos"] != nil && feed["photos"] != "" {
                detailItineraryImage.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["photos"][0]["name"])", width: 100))
            }else{
            detailItineraryImage.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["startLocationPic"])", width: 100))
            }
        }
        
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ActivityDetailItinerary", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
    }


}

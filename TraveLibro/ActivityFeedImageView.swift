//
//  ActivityFeedImageView.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 18/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class ActivityFeedImageView: UIView {
    @IBOutlet weak var nameJourneyActivityFeed: UILabel!
    @IBOutlet weak var flagOne: UIImageView!
    @IBOutlet weak var flageTwo: UIImageView!
    @IBOutlet weak var flagThree: UIImageView!
    @IBOutlet weak var OnTheGOText: UITextField!
    @IBOutlet weak var ImageChange: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var countryStackView: UIStackView!
    @IBOutlet weak var photoVideoCheckInCount: UIStackView!

    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var kindOfJourneyThree: UIImageView!
    @IBOutlet weak var kindOfJourneyTwo: UIImageView!
    @IBOutlet weak var kindOfJourneyOne: UIImageView!
    @IBOutlet var kindOfJourneyCollection: [UIImageView]!
    @IBOutlet weak var CameraCount: UILabel!
    @IBOutlet weak var videoCount: UILabel!
    @IBOutlet weak var checkInCount: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var videoIcon: UIImageView!
    @IBOutlet weak var CameraIcon: UIImageView!
    @IBOutlet var ImageCollectionCount: [UIImageView]!
    @IBOutlet var ActivityImageView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
       transparentCardWhite(ActivityImageView)
        makeTLProfilePictureBorderWhiteCorner(flagOne)
        makeTLProfilePictureBorderWhiteCorner(flageTwo)
        makeTLProfilePictureBorderWhiteCorner(flagThree)
        kindOfJourneyOne.tintColor = UIColor.white
        kindOfJourneyTwo.tintColor = UIColor.white
        kindOfJourneyThree.tintColor = UIColor.white
        locationIcon.tintColor = UIColor.white
        videoIcon.tintColor = UIColor.white
        CameraIcon.tintColor = UIColor.white
        
        OnTheGOText.layer.cornerRadius = 5
        locationIcon.clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fillData(feed:JSON) {
        
        for country in countryStackView.subviews {
            country.isHidden = true
        }
        if feed["countryVisited"][0] != nil {
            flagOne.isHidden = false
            flagOne.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["countryVisited"][2]["country"]["flag"])", width: 100))
        }
        if feed["countryVisited"][1] != nil {
            flageTwo.isHidden = false
            flageTwo.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["countryVisited"][1]["country"]["flag"])", width: 100))
        }
        if feed["countryVisited"][2] != nil {
            flagThree.isHidden = false
            flagThree.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["countryVisited"][0]["country"]["flag"])", width: 100))
        }
        
        for category in stackView.subviews {
            category.isHidden = true
        }
        if feed["kindOfJourney"][0] != nil {
            kindOfJourneyOne.isHidden = false
            kindOfJourneyOne.image = UIImage(named: categoryImage(feed["kingOfJourney"][2].stringValue) )
        }
        if feed["kindOfJourney"][1] != nil {
            kindOfJourneyTwo.isHidden = false
            kindOfJourneyTwo.image = UIImage(named: categoryImage(feed["kindOfJourney"][1].stringValue))
        }
        if feed["kindOfJourney"][2] != nil {
            kindOfJourneyThree.isHidden = false
            kindOfJourneyThree.image = UIImage(named: categoryImage(feed["kindOfJourney"][0].stringValue))
        }
        
        nameJourneyActivityFeed.text = feed["name"].stringValue
        CameraCount.text = feed["photoCount"].stringValue
        videoCount.text = feed["videoCount"].stringValue
        checkInCount.text = feed["checkInCount"].stringValue
        
        if feed["coverPhoto"] != nil && feed["coverPhoto"] != "" {
            ImageChange.hnk_setImageFromURL(getImageURL(feed["coverPhoto"].stringValue, width: 300))
        }else if feed["startLocationPic"] != nil && feed["startLocationPic"] != "" {
            ImageChange.hnk_setImageFromURL(getImageURL(feed["startLocationPic"].stringValue, width: 300))
        }else{
            ImageChange.image = UIImage(named: "logo-default")
        }
        
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ActivityFeedImageView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.addSubview(view)
    }

}

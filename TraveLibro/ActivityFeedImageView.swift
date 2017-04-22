//
//  ActivityFeedImageView.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 18/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class ActivityFeedImageView: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var nameJourneyActivityFeed: UILabel!
    @IBOutlet weak var flagOne: UIImageView!
    @IBOutlet weak var flageTwo: UIImageView!
    @IBOutlet weak var flagThree: UIImageView!
    @IBOutlet weak var OnTheGOText: UITextField!
    @IBOutlet weak var ImageChange: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var countryStackView: UIStackView!
    @IBOutlet weak var photoVideoCheckInCount: UIStackView!

    @IBOutlet weak var blueBox: UIImageView!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var days: UILabel!
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
        makeFlagBorderWhiteCorner(flagOne)
        makeFlagBorderWhiteCorner(flageTwo)
        makeFlagBorderWhiteCorner(flagThree)
        kindOfJourneyOne.tintColor = UIColor.white
        kindOfJourneyTwo.tintColor = UIColor.white
        kindOfJourneyThree.tintColor = UIColor.white
        locationIcon.tintColor = UIColor.white
        videoIcon.tintColor = UIColor.white
        CameraIcon.tintColor = UIColor.white
        
        OnTheGOText.layer.cornerRadius = 5
        OnTheGOText.delegate = self
        locationIcon.clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fillData(feed:JSON) {
        
        self.daysLabel.text = feed["duration"].stringValue
        
        if feed["duration"].intValue == 0 || feed["duration"] == nil {
            self.blueBox.isHidden = true
            self.days.isHidden = true
            self.daysLabel.isHidden = true
        }
        
        if feed["duration"].intValue < 2 {
            self.days.text = "Day"
        }else{
            self.days.text = "Days"
        }
        
        for country in countryStackView.subviews {
            country.isHidden = true
        }
        if feed["countryVisited"][0] != nil {
            flagOne.isHidden = false
            flagOne.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["countryVisited"][0]["country"]["flag"])", width: SMALL_PHOTO_WIDTH))
        }
        if feed["countryVisited"][1] != nil {
            flageTwo.isHidden = false
            flageTwo.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["countryVisited"][1]["country"]["flag"])", width: SMALL_PHOTO_WIDTH))
        }
        if feed["countryVisited"][2] != nil {
            flagThree.isHidden = false
            flagThree.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["countryVisited"][2]["country"]["flag"])", width: SMALL_PHOTO_WIDTH))
        }
        
//        for category in stackView.subviews {
//            category.isHidden = true
//        }
        
        if feed["kindOfJourney"][0] != nil {
            print("in 0th \(feed["kindOfJourney"][2])")
            kindOfJourneyOne.isHidden = false
            kindOfJourneyOne.image = UIImage(named: categoryImage(feed["kindOfJourney"][2].stringValue) )
        }
        if feed["kindOfJourney"][1] != nil {
            print("in 1th \(feed["kindOfJourney"][1])")

            kindOfJourneyTwo.isHidden = false
            kindOfJourneyTwo.image = UIImage(named: categoryImage(feed["kindOfJourney"][1].stringValue))
        }
        if feed["kindOfJourney"][2] != nil {
            print("in 2th \(feed["kindOfJourney"][0])")

            kindOfJourneyThree.isHidden = false
            kindOfJourneyThree.image = UIImage(named: categoryImage(feed["kindOfJourney"][0].stringValue))
        }
        
        nameJourneyActivityFeed.text = feed["name"].stringValue
        CameraCount.text = feed["photoCount"].stringValue
        CameraCount.sizeToFit()
        videoCount.text = feed["videoCount"].stringValue
        checkInCount.text = feed["checkInCount"].stringValue
        
        if feed["coverPhoto"] != nil && feed["coverPhoto"] != "" {
            ImageChange.hnk_setImageFromURL(getImageURL(feed["coverPhoto"].stringValue, width: 0))
        }else if feed["startLocationPic"] != nil && feed["startLocationPic"] != "" {
            ImageChange.hnk_setImageFromURL(getImageURL(feed["startLocationPic"].stringValue, width: 0))
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
    
    
    //MARK: - TextField Delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    

}

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
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        transparentCardWhite(activityFeedQuickView)
        makeTLProfilePicture(activityQuickFlagOne)
        makeTLProfilePicture(activityQuickFlagTwo)
        makeTLProfilePicture(activityFeedQuickThree)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fillData(feed:JSON) {
        
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
        
        
        activityFeedItineraryName.text = feed["name"].stringValue
//        CameraCount.text = feed["photoCount"].stringValue
//        videoCount.text = feed["videoCount"].stringValue
//        checkInCount.text = feed["checkInCount"].stringValue
        
        if feed["coverPhoto"] != nil && feed["coverPhoto"] != "" {
            activityQuickCoverPic.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["coverPhoto"])", width: 100))
        }else{
            activityQuickCoverPic.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["startLocationPic"])", width: 100))
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

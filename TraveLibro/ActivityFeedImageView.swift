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
        makeTLProfilePicture(flagOne)
        makeTLProfilePicture(flageTwo)
        makeTLProfilePicture(flagThree)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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

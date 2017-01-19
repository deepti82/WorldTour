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
    @IBOutlet weak var activityFeedItineraryName: UILabel!
    @IBOutlet weak var activityFeedYear: UILabel!
    @IBOutlet weak var activityFeedDaysCount: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        transparentCardWhite(activityFeedQuickView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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

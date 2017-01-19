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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        transparentCardWhite(activityDetailItineraryView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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

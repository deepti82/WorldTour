//
//  detailedItineraryMain.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 22/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class detailedItineraryMain: UIView {

    @IBOutlet weak var detailedCountryView: UIView!
    @IBOutlet weak var detailedDurationLabel: UILabel!
    @IBOutlet weak var detailedCostLabel: UILabel!
    @IBOutlet weak var detailedKindOfJourneyThree: UIImageView!
    @IBOutlet weak var detailedKindOfJourneyTwo: UIImageView!
    @IBOutlet weak var detailedKindOfJourneyOne: UIImageView!
    @IBOutlet weak var detailedTitleLabel: UILabel!
    @IBOutlet weak var detailedCoverImage: UIImageView!
    @IBOutlet weak var detailedCountryScroll: UIScrollView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "detailedItineraryMain", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
    }

}

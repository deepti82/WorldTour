//
//  TripSummaryProfile.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 29/04/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class TripSummaryProfile: UIView {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var mainSummaryView: UIView!
    @IBOutlet weak var profileName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "TripSummaryProfile", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        
        profileImage.image = UIImage(named: "add_circle")
        profileImage.layer.zPosition = 10
        profileImage.layer.cornerRadius = 40
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        profileImage.layer.borderWidth = 6
        
        profileName.text = "Harsh Thakkar"
        profileName.font = UIFont(name: "Avenir-Roman", size: 14)
        
        mainSummaryView.layer.shadowColor = UIColor.blackColor().CGColor
        mainSummaryView.layer.shadowRadius = 1
        mainSummaryView.layer.shadowOpacity = 0.3
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

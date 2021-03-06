//
//  MoreAboutTrip.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 11/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

var heightMoreABoutTrip: Int = 0

class MoreAboutTrip: UIView {

    @IBOutlet weak var dayDescription: UITextView!
    @IBOutlet weak var dayNumberLabel: UILabel!
    @IBOutlet weak var mainTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        heightMoreABoutTrip = 600
        
        dayNumberLabel.layer.cornerRadius = 5
        dayNumberLabel.clipsToBounds = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "MoreAboutTrip", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

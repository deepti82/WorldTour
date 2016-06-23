//
//  Itineraries.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 10/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class Itineraries: UIView {
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var profileName: UILabel!

    @IBOutlet weak var reviewStack: UIStackView!
    @IBOutlet weak var likeStack: UIStackView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var options: UIImageView!
    @IBOutlet weak var feedbackStack: UIStackView!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var daysBG: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var toTapView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let gradient = CAGradientLayer()
        
        let blackColour = UIColor.blackColor().colorWithAlphaComponent(0.8).CGColor as CGColorRef
        let transparent = UIColor.clearColor().CGColor as CGColorRef
        
        gradient.frame = gradientView.bounds
        gradient.frame.size.width = gradientView.frame.width + 100
        gradient.colors = [blackColour, transparent]
        gradient.locations = [0.0, 0.75]
        
        gradientView.layer.addSublayer(gradient)
        
        profileIcon.layer.zPosition = 10
        profileName.layer.zPosition = 10
        daysLabel.layer.zPosition = 10
        daysBG.layer.zPosition = 10
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "Itineraries", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

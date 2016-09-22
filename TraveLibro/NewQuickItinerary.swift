//
//  NewQuickItinerary.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 03/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class NewQuickItinerary: UIView {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var itineraryButton: UIButton!
    @IBOutlet weak var otgJourneyButton: UIButton!
    @IBOutlet var mainButtons: [UIButton]!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        for button in mainButtons {
            
            button.layer.cornerRadius = 5
            button.layer.borderColor = mainOrangeColor.CGColor
            button.layer.borderWidth = 1.0
            
        }
        
        let darkBlur = UIBlurEffect(style: .Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame.size.height = self.frame.height
        blurView.frame.size.width = self.frame.width
        blurView.layer.zPosition = -1
        blurView.userInteractionEnabled = false
        self.addSubview(blurView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "NewQuickItinerary", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }
}

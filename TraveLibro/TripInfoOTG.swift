//
//  TripInfoOTG.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 27/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class TripInfoOTG: UIView {

    @IBOutlet weak var nearMeButton: UIButton!
    @IBOutlet weak var itinerariesButton: UIButton!
    @IBOutlet weak var restaurantsButton: UIButton!
    @IBOutlet weak var hotelsButton: UIButton!
    @IBOutlet weak var mustDoButton: UIButton!
    @IBOutlet weak var reviewsButton: UIButton!
    @IBOutlet weak var photosButton: UIButton!
    @IBOutlet weak var videosButton: UIButton!
    @IBOutlet weak var summaryButton: UIButton!
//    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet var notifications: [UIButton]!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        for image in notifications {
            
            image.layer.cornerRadius = image.frame.height/2
            
        }
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame.size.height = self.frame.height
        blurView.frame.size.width = self.frame.width
        blurView.layer.zPosition = -1
        blurView.userInteractionEnabled = false
        self.addSubview(blurView)
        
//        closeButton.setTitle(String(format: "%C", faicon["close"]!), forState: .Normal)
        
        self.layer.opacity = 0.0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "TripInfoOTG", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

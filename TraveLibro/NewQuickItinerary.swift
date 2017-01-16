//
//  NewQuickItinerary.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 03/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Spring

class NewQuickItinerary: UIView {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var itineraryButton: UIButton!
    @IBOutlet weak var otgJourneyButton: SpringButton!
    @IBOutlet var mainButtons: [UIButton]!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        for button in mainButtons {
            
            button.layer.cornerRadius = 5
            button.layer.borderColor = mainOrangeColor.cgColor
            button.layer.borderWidth = 3
            
        }
        
        let darkBlur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame.size.height = self.frame.height
        blurView.frame.size.width = self.frame.width
        blurView.layer.zPosition = -1
        blurView.isUserInteractionEnabled = false
        blurView.alpha = 1
        self.addSubview(blurView)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: darkBlur)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        blurView.contentView.addSubview(vibrancyEffectView)
    
        
    }
    
      required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NewQuickItinerary", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
}

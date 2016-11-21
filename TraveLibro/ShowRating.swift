//
//  ShowRating.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 10/14/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ShowRating: UIView {
    
    let moodArr = ["Disappointed", "Sad", "Good", "Super", "In Love"]
    let imageArr = ["disapointed", "sad", "good", "superface", "love"]
    
    @IBOutlet weak var rating: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var line: drawLine!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        
        ratingLabel.shadowColor = UIColor.black
        ratingLabel.shadowOffset = CGSize(width: 2, height: 1)
        ratingLabel.layer.masksToBounds = true
        
//        <label opaque="NO" userInteractionEnabled="NO" contentMode="left" horizontalHuggingPriority="251" verticalHuggingPriority="251" text="Categorise your current location" textAlignment="natural" lineBreakMode="tailTruncation" baselineAdjustment="alignBaselines" adjustsFontSizeToFit="NO" translatesAutoresizingMaskIntoConstraints="NO" id="6l6-XA-HcG">
//        <rect key="frame" x="87.5" y="28" width="200.5" height="19.5"/>
//        <fontDescription key="fontDescription" name="Avenir-LightOblique" family="Avenir" pointSize="14"/>
//        <color key="textColor" red="1" green="1" blue="1" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>
//        <nil key="highlightedColor"/>
//        </label>
        
        
    }
    
    func showRating(ratingCount: Int) {
        
        print("ratingCount: \(ratingCount)")
        rating.setImage(UIImage(named: imageArr[ratingCount]), for: .normal)
        ratingLabel.text = "Reviewed " + moodArr[ratingCount]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ShowRating", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        line.backgroundColor = UIColor.clear
    }

}

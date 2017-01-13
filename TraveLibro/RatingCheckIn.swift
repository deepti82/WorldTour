//
//  RatingCheckIn.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 08/10/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class RatingCheckIn: UIView {
    
    @IBOutlet weak var line: drawLine!
    @IBOutlet weak var rateCheckInLabel: UILabel!
    @IBOutlet weak var rateCheckInButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        rateCheckInLabel.shadowColor = UIColor.black
        rateCheckInLabel.shadowOffset = CGSize(width: 0.5, height: 0.5)
//        rateCheckInLabel.layer.shadowOpacity = 0.8
        rateCheckInLabel.layer.masksToBounds = true
        line.backgroundColor = UIColor.clear
        
        rateCheckInButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        rateCheckInButton.setTitle("", for: .normal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RatingCheckIn", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
}

//
//  QuickItineraryFour.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 05/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickItineraryFour: UIView {

    @IBOutlet weak var italicButton: UIButton!
    @IBOutlet weak var boldButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var textView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        boldButton.setTitle(String(format: "%C", faicon["bold"]!), forState: .Normal)
        italicButton.setTitle(String(format: "%C", faicon["italics"]!), forState: .Normal)
        nextButton.layer.cornerRadius = 5
        textView.layer.borderColor = mainBlueColor.CGColor
        textView.layer.borderWidth = 1.5
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "QuickItineraryFour", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }
}

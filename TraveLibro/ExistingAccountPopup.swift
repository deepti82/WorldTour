//
//  ExistingAccountPopup.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 23/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ExistingAccountPopup: UIView {

    @IBOutlet weak var continueButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        continueButton.layer.borderWidth = 1.0
        continueButton.layer.cornerRadius = 5.0
        continueButton.layer.borderColor = UIColor.whiteColor().CGColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ExistingAccountPopup", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }
    

}

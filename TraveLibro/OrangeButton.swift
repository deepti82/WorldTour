//
//  OrangeButton.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 23/04/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class OrangeButton: UIView {
    
    @IBOutlet weak var orangeButtonTitle: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "OrangeButton", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        
        orangeButtonTitle.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 14)
    }
    
}
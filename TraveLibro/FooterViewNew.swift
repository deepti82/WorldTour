//
//  FooterViewNew.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 25/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class FooterViewNew: UIView {

    @IBOutlet var footerIconImages: [UIImageView]!
    @IBOutlet weak var feedView: UIView!
    @IBOutlet weak var notifyView: UIView!
    @IBOutlet weak var LLView: UIView!
    @IBOutlet weak var TLView: UIView!
    @IBOutlet weak var lowerMainView: UIView!
    @IBOutlet weak var upperMainView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        for icon in footerIconImages {
            
            icon.tintColor = UIColor.whiteColor()
            
        }
        
        upperMainView.layer.cornerRadius = 15
        upperMainView.layer.borderWidth = 2.0
        upperMainView.layer.borderColor = UIColor(red: 57/255, green: 66/255, blue: 106/255, alpha: 1).CGColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "footerNew", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

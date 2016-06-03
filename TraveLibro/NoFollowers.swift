//
//  NoFollowers.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class NoFollowers: UIView {

    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var whatsappButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        mailButton.setTitle(String(format: "%C", faicon["email"]!), forState: .Normal)
        whatsappButton.setTitle(String(format: "%C", faicon["whatsapp"]!), forState: .Normal)
        fbButton.setTitle(String(format: "%C", faicon["facebook"]!), forState: .Normal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "NoFollowers", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        
    }

}

//
//  MoreAboutMeScrollForProfile.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 15/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class MoreAboutMeScrollForProfile: UIView {

    @IBOutlet weak var MAMView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let myView = MoreAboutMe(frame: CGRect(x: 0, y: 0, width: MAMView.frame.width - 20, height: MAMView.frame.height))
        MAMView.addSubview(myView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "MoreAboutMeScrollForProfile", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

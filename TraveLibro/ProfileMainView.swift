//
//  ProfileMainView.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 21/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ProfileMainView: UIView {
    
    @IBOutlet weak var flagText: UILabel!
    @IBOutlet weak var flagView: UIImageView!
    @IBOutlet weak var ProfileImageView: UIView!
        override init(frame: CGRect) {
            super.init(frame: frame)
            loadViewFromNib ()
            
            let profile = ProfilePic(frame: CGRect(x: 0, y: 0, width: ProfileImageView.frame.width, height: ProfileImageView.frame.height))
            ProfileImageView.addSubview(profile)
            
            self.bringSubviewToFront(flagView)
            self.bringSubviewToFront(flagText)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        func loadViewFromNib() {
            let bundle = NSBundle(forClass: self.dynamicType)
            let nib = UINib(nibName: "ProfileMainView", bundle: bundle)
            let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
            view.frame = bounds
            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            self.addSubview(view);
        }

}

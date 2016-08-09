//
//  SignInToolbar.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SignInToolbar: UIView {

    @IBOutlet weak var fbButton: FBSDKLoginButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    
    
    @IBOutlet weak var tnc: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let fbImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        fbImage.center = CGPointMake(fbButton.frame.width/2 + 15, fbButton.frame.height/2)
        fbImage.image = UIImage(named: "facebook_icon")
        fbButton.addSubview(fbImage)
        
        let gplusImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        gplusImage.center = CGPointMake(googleButton.frame.width/2 + 15, googleButton.frame.height/2)
        gplusImage.image = UIImage(named: "google_plus_icon")
        googleButton.addSubview(gplusImage)
        
        let twitterImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        twitterImage.center = CGPointMake(twitterButton.frame.width/2 + 15, twitterButton.frame.height/2)
        twitterImage.image = UIImage(named: "twitter_icon")
        twitterButton.addSubview(twitterImage)
        
        tnc.layer.borderWidth = 1.0
        tnc.layer.borderColor = UIColor.whiteColor().CGColor
        tnc.layer.cornerRadius = 5.0
        
        signInButton.layer.borderWidth = 1.0
        signInButton.layer.borderColor = UIColor.whiteColor().CGColor
        signInButton.layer.cornerRadius = 5.0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "SignInToolbar", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

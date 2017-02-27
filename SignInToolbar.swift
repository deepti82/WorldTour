//
//  SignInToolbar.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SignInToolbar: UIView {

    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var igButton: UIButton!
    
    @IBOutlet var toolbarButtons: [UIButton]!
    @IBOutlet var lowerToolbarButtons: [UIButton]!
    
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let fbImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        fbImage.center = CGPoint(x: fbButton.frame.width/2 - 5, y: fbButton.frame.height/2)
        fbImage.image = UIImage(named: "facebook_icon")
        fbButton.addSubview(fbImage)
        
        let gplusImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        gplusImage.center = CGPoint(x: googleButton.frame.width/2, y: googleButton.frame.height/2)
        gplusImage.image = UIImage(named: "google_plus_icon")
        googleButton.addSubview(gplusImage)
        
//        let twitterImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        twitterImage.center = CGPoint(x: twitterButton.frame.width/2 - 3.5, y: twitterButton.frame.height/2)
//        twitterImage.image = UIImage(named: "twitter_icon")
//        twitterButton.addSubview(twitterImage)
        
//        let instagramImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        instagramImage.center = CGPoint(x: igButton.frame.width/2 - 3.5, y: igButton.frame.height/2)
//        instagramImage.image = UIImage(named: "instagram")
//        igButton.addSubview(instagramImage)
        
        for button in toolbarButtons {
            
            button.layer.cornerRadius = 5.0
            clipsToBounds = true
            
        }
        
        for button in lowerToolbarButtons {
            
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.cornerRadius = 5.0
            
        }
        
//        signUp.layer.borderWidth = 1.0
//        signUp.layer.borderColor = UIColor.whiteColor().CGColor
//        signUp.layer.cornerRadius = 5.0
//        
//        signInButton.layer.borderWidth = 1.0
//        signInButton.layer.borderColor = UIColor.whiteColor().CGColor
//        signInButton.layer.cornerRadius = 5.0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SignInToolbar", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }

}

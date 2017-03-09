//
//  SignInFullView.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SignInFullView: UIView {    
    @IBOutlet weak var googleLabel: LeftPaddedLabel!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var facebookLabel: LeftPaddedLabel!
    @IBOutlet weak var tncFooter: LeftPaddedLabel!
    @IBOutlet weak var loginButton: UIButton!    
    
    @IBOutlet weak var facebookStack: UIStackView!
    @IBOutlet weak var googleStack: UIStackView!
    @IBOutlet weak var loginStack: UIStackView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var requestLabel: UILabel!
    @IBOutlet weak var autoMigrateLabel: UILabel!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        loginStack.isHidden = true
        facebookButton.imageView?.contentMode = .scaleAspectFit
        facebookButton.clipsToBounds = true
        
        googleButton.imageView?.contentMode = .scaleAspectFit
        googleButton.clipsToBounds = true
        
        profileImage.layer.cornerRadius = (30/100) * profileImage.frame.width
        profileImage.layer.borderWidth = 2.0
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.clipsToBounds = true
        profileImage.contentMode = UIViewContentMode.scaleAspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SignUpFullView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
    
    

}

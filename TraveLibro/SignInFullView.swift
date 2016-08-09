//
//  SignInFullView.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SignInFullView: UIView {

    @IBOutlet weak var twitterLabel: LeftPaddedLabel!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var googleLabel: LeftPaddedLabel!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var facebookLabel: LeftPaddedLabel!
    @IBOutlet weak var tncFooter: LeftPaddedLabel!
    @IBOutlet weak var loginBigButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var facebookStack: UIStackView!
    @IBOutlet weak var twitterStack: UIStackView!
    @IBOutlet weak var googleStack: UIStackView!
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
//    @IBOutlet weak var textField3: UITextField!
//    @IBOutlet weak var textField4: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Avenir-Roman", size: 14)!
        ]
        
//        signUpButton.backgroundColor = mainOrangeColor
        loginBigButton.layer.cornerRadius = 5
        
        tncFooter.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        
//        facebookLabel.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 153/255, alpha: 0.6)
//        facebookButton.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 153/255, alpha: 1)
//        
//        googleLabel.backgroundColor = UIColor(red: 221/255, green: 75/255, blue: 57/255, alpha: 0.6)
//        googleButton.backgroundColor = UIColor(red: 221/255, green: 75/255, blue: 57/255, alpha: 1)
//        
//        
//        twitterLabel.backgroundColor = UIColor(red: 0/255, green: 172/255, blue: 237/255, alpha: 0.6)
//        twitterButton.backgroundColor = UIColor(red: 0/255, green: 172/255, blue: 237/255, alpha: 1)
        
//        textField1.borderStyle = .None
        textField1.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        textField1.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: attributes)
        textField1.leftView = UIView(frame: CGRectMake(0, 0, 15, self.textField1.frame.height))
        textField1.leftViewMode = .Always
        
//        textField2.borderStyle = .None
        textField2.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        textField2.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: attributes)
        textField2.leftView = UIView(frame: CGRectMake(0, 0, 15, self.textField2.frame.height))
        textField2.leftViewMode = .Always

        
////        textField3.borderStyle = .None
//        textField3.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
//        textField3.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributes)
//        textField3.leftView = UIView(frame: CGRectMake(0, 0, 15, self.textField3.frame.height))
//        textField3.leftViewMode = .Always
//
////        textField4.borderStyle = .None
//        textField4.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
//        textField4.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributes)
//        textField4.leftView = UIView(frame: CGRectMake(0, 0, 15, self.textField4.frame.height))
//        textField4.leftViewMode = .Always
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "SignUpFullView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }
    
    

}

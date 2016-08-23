//
//  LogInView.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class LogInView: UIView {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
   
    @IBOutlet var socialLoginButtons: [UIButton]!
    let attributes = [
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "Avenir-Roman", size: 12)!,
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
//        let paddingView = UIView(frame: CGRectMake(0, 0, 15, self.nameField.frame.height))
        
//        logInButton.backgroundColor = mainOrangeColor
        logInButton.layer.cornerRadius = 5
        
        nameField.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        nameField.borderStyle = .None
        nameField.textColor = UIColor.whiteColor()
        nameField.attributedPlaceholder = NSAttributedString(string: "  Email Id", attributes:attributes)
//        nameField.leftView = paddingView
//        nameField.leftViewMode = .Always
        
        passwordField.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        passwordField.borderStyle = .None
        passwordField.textColor = UIColor.whiteColor()
        passwordField.attributedPlaceholder = NSAttributedString(string: "  Password", attributes:attributes)
//        passwordField.leftView = paddingView
//        passwordField.leftViewMode = .Always
        
        for button in socialLoginButtons {
            
            button.layer.cornerRadius = 5.0
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "LogInView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }
}

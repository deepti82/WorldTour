//
//  LogInView.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class LogInView: UIView {

    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
   
    @IBOutlet var socialLoginButtons: [UIButton]!    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 60))
        emailTxt.leftView = paddingView
        emailTxt.leftViewMode = UITextFieldViewMode.always
        
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 60))
        passwordTxt.leftView = paddingView2
        passwordTxt.leftViewMode = UITextFieldViewMode.always

        logInButton.layer.cornerRadius = 5
        
        for button in socialLoginButtons {
            button.layer.cornerRadius = 5.0
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LogInView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        print("test")
    }
    
}

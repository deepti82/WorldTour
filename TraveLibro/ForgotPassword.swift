//
//  ForgotPassword.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 05/03/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class ForgotPassword: UIView {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var emailIDTxtField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 60))
        emailIDTxtField.leftView = paddingView
        emailIDTxtField.leftViewMode = UITextFieldViewMode.always
        emailIDTxtField.layer.borderColor = UIColor.white.cgColor
        emailIDTxtField.layer.borderWidth = 1.0
        emailIDTxtField.layer.cornerRadius = 5.0
        
        cancelButton.layer.borderWidth = 1.0        
        cancelButton.layer.cornerRadius = 5.0
        cancelButton.layer.borderColor = UIColor.white.cgColor
        
        confirmButton.layer.borderWidth = 1.0        
        confirmButton.layer.cornerRadius = 5.0
        confirmButton.layer.borderColor = UIColor.white.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "forgotPasswordView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
    
}

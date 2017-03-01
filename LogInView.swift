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
    
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
   
    @IBOutlet var socialLoginButtons: [UIButton]!
    let attributes = [
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName : UIFont(name: "Avenir-Roman", size: 12)!,
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.nameField.frame.height))
        
//        logInButton.backgroundColor = mainOrangeColor
        logInButton.layer.cornerRadius = 5
        
        nameField.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        nameField.borderStyle = .none
        nameField.textColor = UIColor.white
        nameField.attributedPlaceholder = NSAttributedString(string: "  Email Id", attributes:attributes)
        nameField.leftView = paddingView
        nameField.leftViewMode = .always
        
        passwordField.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        passwordField.borderStyle = .none
        passwordField.textColor = UIColor.white
        passwordField.attributedPlaceholder = NSAttributedString(string: "  Password", attributes:attributes)
        passwordField.leftView = paddingView
        passwordField.leftViewMode = .always
        
        for button in socialLoginButtons {
            button.layer.cornerRadius = 5.0
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func loginButtonTabbed(_ sender: Any) {
        
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LogInView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
}

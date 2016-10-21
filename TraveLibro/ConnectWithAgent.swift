//
//  ConnectWithAgent.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 17/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ConnectWithAgent: UIView {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var specializingTextField: UITextField!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.nameTextField.frame.height))
        
        nameTextField.leftView = paddingView
        nameTextField.leftViewMode = .always
        
        emailTextField.leftView = paddingView
        emailTextField.leftViewMode = .always
        
        contactTextField.leftView = paddingView
        contactTextField.leftViewMode = .always
        
        countryTextField.leftView = paddingView
        countryTextField.leftViewMode = .always
        
        cityTextField.leftView = paddingView
        cityTextField.leftViewMode = .always
        
        specializingTextField.leftView = paddingView
        specializingTextField.leftViewMode = .always
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ConnectWithAgent", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }

}


class PaddedTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

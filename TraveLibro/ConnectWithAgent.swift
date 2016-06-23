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
        
        let paddingView = UIView(frame: CGRectMake(0, 0, 15, self.nameTextField.frame.height))
        
        nameTextField.leftView = paddingView
        nameTextField.leftViewMode = .Always
        
        emailTextField.leftView = paddingView
        emailTextField.leftViewMode = .Always
        
        contactTextField.leftView = paddingView
        contactTextField.leftViewMode = .Always
        
        countryTextField.leftView = paddingView
        countryTextField.leftViewMode = .Always
        
        cityTextField.leftView = paddingView
        cityTextField.leftViewMode = .Always
        
        specializingTextField.leftView = paddingView
        specializingTextField.leftViewMode = .Always
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ConnectWithAgent", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}


class PaddedTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

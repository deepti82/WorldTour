//
//  ResetPassword.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ResetPassword: UIView {

    @IBOutlet weak var submitbutton: UIButton!
    @IBOutlet weak var confirmpswd: UITextField!
    @IBOutlet weak var newpswd: UITextField!
    @IBOutlet weak var oldpswd: UITextField!
    
    let attributes = [
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName : UIFont(name: "Avenir-Roman", size: 12)!
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        _ = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.confirmpswd.frame.height))
        
        submitbutton.layer.cornerRadius = 5
        
//        confirmpswd.attributedPlaceholder = NSAttributedString(string: "Old Password", attributes: attributes)
//        confirmpswd.leftView = paddingView
//        confirmpswd.leftViewMode = .Always
//        confirmpswd.borderStyle = .None
//        
//        newpswd.attributedPlaceholder = NSAttributedString(string: "Old Password", attributes: attributes)
//        newpswd.leftView = paddingView
//        newpswd.leftViewMode = .Always
//        newpswd.borderStyle = .None
//        
//        oldpswd.attributedPlaceholder = NSAttributedString(string: "Old Password", attributes: attributes)
//        oldpswd.leftView = paddingView
//        oldpswd.leftViewMode = .Always
//        oldpswd.borderStyle = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ResetPassword", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        
    }
    
}

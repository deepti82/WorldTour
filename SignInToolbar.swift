//
//  SignInToolbar.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SignInToolbar: UIView {
    
    @IBOutlet var lowerToolbarButtons: [UIButton]!
    
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        for button in lowerToolbarButtons {
            
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.cornerRadius = 5.0
            
        }
        
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

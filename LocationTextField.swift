//
//  LocationTextField.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 27/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class LocationTextField: UIView {

    @IBOutlet weak var mainTextField: UITextField!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName : UIFont(name: "Avenir-Roman", size: 16)!
        ]
        
        mainTextField.borderStyle = .none
        mainTextField.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        mainTextField.attributedPlaceholder = NSAttributedString(string: "Mumbai", attributes: attributes)
        
        let locationIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        locationIcon.center = CGPoint(x: mainTextField.frame.width - 30, y: mainTextField.frame.height/2)
        locationIcon.image = UIImage(named: "gps_icon")
        mainTextField.addSubview(locationIcon)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LocationTextField", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        
    }

}

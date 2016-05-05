//
//  TextField.swift
//  TraveLibro
//
//  Created by Chintan Shah on 05/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class TextField: UIView {

    @IBOutlet weak var field: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 1
        
        field.textColor = UIColor.blackColor()
        field.font = avenirFont
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "TextField", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

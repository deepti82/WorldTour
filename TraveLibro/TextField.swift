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
        
        self.layer.shadowOffset = CGSize(width: 2, height: 1)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 1
        
        field.textColor = UIColor.black
        field.font = avenirFont
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TextField", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }

}

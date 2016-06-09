//
//  EditDOB.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 07/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class EditDOB: UIView {

    @IBOutlet weak var datePicker: UIDatePicker!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "EditDOB", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

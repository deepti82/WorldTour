//
//  EachMustDo.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 10/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class EachMustDo: UIView {

    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "EachMustDo", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

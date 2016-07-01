//
//  NewThoughtsView.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 25/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class NewThoughtsView: UIView {

    @IBOutlet weak var OTGLabelView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        OTGLabelView.layer.cornerRadius = 5
        OTGLabelView.clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "NewThoughtsView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        
    }

}

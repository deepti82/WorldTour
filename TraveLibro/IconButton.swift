//
//  IconButton.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 13/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class IconButton: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        view.layer.cornerRadius = 14
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "IconButton", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

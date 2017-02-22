//
//  OnlyLine.swift
//  TraveLibro
//
//  Created by Jagruti  on 22/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class OnlyLine: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "OnlyLine", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
    }

}
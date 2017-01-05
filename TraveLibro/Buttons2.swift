//
//  Buttons2.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 05/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class Buttons2: UIView {

    @IBOutlet weak var options2: UIButton!
    @IBOutlet weak var nearMe2: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "Buttons2", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        options2.tintColor = UIColor.white
        nearMe2.tintColor = UIColor.white
        
    }

}

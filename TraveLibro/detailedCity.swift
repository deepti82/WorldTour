//
//  detailedCity.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 22/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class detailedCity: UIView {
    @IBOutlet weak var detailedDaysLabel: UILabel!
    @IBOutlet weak var detailedCityLabel: UILabel!
    @IBOutlet weak var plus: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        plus.tintColor = UIColor(hex: "2C3757")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "detailedCity", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
    }

}

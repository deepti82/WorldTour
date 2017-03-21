//
//  TripSummaryCell.swift
//  TraveLibro
//
//  Created by Jagruti  on 13/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class TripSummaryCell: UIButton {

    @IBOutlet weak var category: UIButton!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet var tintColorCard: UIView!
   
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        category.tintColor = UIColor(hex: "#2c3757")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TripSummaryCell", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.category.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
    }
}

//
//  LocalLifeRecommends.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 01/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class LocalLifeRecommends: UIView {

    @IBOutlet weak var bottomLabel2: UILabel!
    @IBOutlet weak var bottomIcon2: UIImageView!
    @IBOutlet weak var bottomLabel1: UILabel!
    @IBOutlet weak var bottomIcon1: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var topIcon: UIImageView!
    @IBOutlet weak var photoBottom2: UIImageView!
    @IBOutlet weak var photoBottom1: UIImageView!
    @IBOutlet weak var photoTop: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "LocalLifeRecommends", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        
    }

}

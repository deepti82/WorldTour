//
//  TypeOfJourney.swift
//  TraveLibro
//
//  Created by Chintan Shah on 06/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class TypeOfJourney: UIView {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        label.textColor = mainBlueColor
        image.tintColor = mainBlueColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "TypeOfJourney", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

//
//  GenderInfo.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 27/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class GenderInfo: UIView {

    @IBOutlet weak var sheButton: UIButton!
    @IBOutlet weak var heButton: UIButton!
    
    @IBAction func sheButtonTap(sender: UIButton) {
        
        heButton.tintColor = UIColor.lightGrayColor()
        sheButton.tintColor = mainOrangeColor
    }
    
    @IBAction func heButtonTap(sender: UIButton) {
        
        sheButton.tintColor = UIColor.lightGrayColor()
        heButton.tintColor = mainOrangeColor
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "GenderInfo", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        
    }

}

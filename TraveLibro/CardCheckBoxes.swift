//
//  CardCheckBoxes.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class CardCheckBoxes: UIView {

    @IBOutlet weak var labelRight: UILabel!
    @IBOutlet weak var labelLeft: UILabel!
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var buttonLeft: UIButton!
    
    @IBAction func checkBoxTap(sender: UIButton) {
        
        if sender.currentBackgroundImage == UIImage(named: "halfnhalfbgGray") {
            
            sender.setBackgroundImage(UIImage(named: "halfnhalfbgGreen"), forState: .Normal)
        }
        
        else {
            
            sender.setBackgroundImage(UIImage(named: "halfnhalfbgGray"), forState: .Normal)
        }
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
        let nib = UINib(nibName: "CardCheckBoxes", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

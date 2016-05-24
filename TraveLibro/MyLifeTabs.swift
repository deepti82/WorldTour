//
//  MyLifeTabs.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 24/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class MyLifeTabs: UIView {

    @IBOutlet weak var journeysButton: UIButton!
    @IBOutlet weak var momentsButton: UIButton!
    @IBOutlet weak var reviewsButton: UIButton!
    
    var originalHeight: CGFloat!
    
    @IBAction func JourneysTap(sender: AnyObject) {
        
        journeysButton.frame.size.height = originalHeight * 3
        momentsButton.frame.size.height = originalHeight * 2
        reviewsButton.frame.size.height = originalHeight
    }
    
    @IBAction func MomentsTap(sender: AnyObject) {
        
        momentsButton.frame.size.height = originalHeight * 3
        journeysButton.frame.size.height = originalHeight * 2
        reviewsButton.frame.size.height = originalHeight
    }
    
    @IBAction func ReviewsTap(sender: AnyObject) {
        
        momentsButton.frame.size.height = originalHeight * 2
        reviewsButton.frame.size.height = originalHeight * 3
        journeysButton.frame.size.height = originalHeight
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        originalHeight = journeysButton.frame.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "MyLifeTabs", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

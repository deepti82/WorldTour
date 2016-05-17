//
//  SpeechBubbleView.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 16/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SpeechBubbleView: UIView {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        title.textColor = mainBlueColor
        timestamp.textColor = UIColor.lightGrayColor()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "SpeechBubbleView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

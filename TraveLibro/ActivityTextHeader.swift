//
//  ActivityTextHeader.swift
//  TraveLibro
//
//  Created by Jagruti  on 19/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class ActivityTextHeader: UIView {

    @IBOutlet var kindOfJourneyMyLife: UIImageView!
    @IBOutlet var textView: UIView!
    @IBOutlet weak var headerText: UITextView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
//        transparentCardWhite(textView)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ActivityTextHeader", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
    }
    

}

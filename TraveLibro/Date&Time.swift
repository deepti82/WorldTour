//
//  Date&Time.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 12/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class DateAndTime: UIView {
    
    @IBOutlet weak var calendarIcon: UILabel!
    @IBOutlet weak var clockIcon: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        calendarIcon.font = FontAwesomeFont
        calendarIcon.text = String(format: "%C", faicon["calendar"]!)
        clockIcon.font = FontAwesomeFont
        clockIcon.text = String(format: "%C", faicon["clock"]!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "Date&Time", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }
    
}

//
//  TimestampTagViewOnScroll.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 18/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class TimestampTagViewOnScroll: UIView {

    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var timeText: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TimestampTagViewOnScroll", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
    func changeTime(feed:JSON) {
        switch(feed["type"].stringValue) {
            case "local-life":
                self.dateText.text = getDateFormat(feed["UTCModified"].stringValue,format:"d MMM, yyyy")
                self.timeText.text = getDateFormat(feed["UTCModified"].stringValue,format:"h:mm a")
        default:
            self.dateText.text = getDateFormat(feed["startTime"].stringValue,format:"d MMM, yyyy")
            self.timeText.text = getDateFormat(feed["startTime"].stringValue,format:"h:mm a")
        }
        
    }

}

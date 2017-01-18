//
//  ActivityFeedThoughts.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 18/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class ActivityFeedThoughts: UIView {

    @IBOutlet var activityFeedThoughtsView: UIView!
    
       @IBOutlet weak var activityLineView: UIView!
    @IBOutlet weak var activityFeedThougts: UILabel!
        override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
            transparentCardWhite(activityFeedThoughtsView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ActivityFeedThoughts", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }

    
}

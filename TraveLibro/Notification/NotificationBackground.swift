//
//  NotificationBackground.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 15/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class NotificationBackground: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "notificationBackgroundView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.layer.cornerRadius = 10
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
    
}

//
//  NotificationFollowPermission.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 15/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class NotificationFollowPermission: UIView {

    
    @IBOutlet weak var NFLeftButton: UIButton!
    @IBOutlet weak var NFRightButton: UIButton!
    @IBOutlet weak var NFViewButton: UIButton!
    @IBOutlet weak var NFStatusLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        NFLeftButton.layer.cornerRadius = 5.0
        NFRightButton.layer.cornerRadius = 5.0
        NFViewButton.layer.cornerRadius = 5.0
        NFStatusLabel.layer.cornerRadius = 5.0
        NFStatusLabel.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "notificationFollowPermissionView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }

}

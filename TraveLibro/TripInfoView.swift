//
//  TripInfoView.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 16/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class TripInfoView: UIView {

    @IBOutlet weak var icon3: UIImageView!
    @IBOutlet weak var icon2: UIImageView!
    @IBOutlet weak var icon1: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let timestamp = DateAndTime(frame: CGRect(x: 75, y: 30, width: 200, height: 25))
        timestamp.backgroundColor = UIColor.clearColor()
        timestamp.calendarIcon.textColor = mainBlueColor
        timestamp.clockIcon.textColor = mainBlueColor
        timestamp.calendarText.textColor = mainBlueColor
        timestamp.timeText.textColor = mainBlueColor
        headerView.addSubview(timestamp)
        
        headerView.backgroundColor = mainOrangeColor
        imageView.image = UIImage(named: "london_image")
        
        icon1.tintColor = mainOrangeColor
        icon2.tintColor = mainOrangeColor
        icon3.tintColor = mainOrangeColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "TripInfoView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

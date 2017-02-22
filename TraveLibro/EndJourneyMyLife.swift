//
//  EndJourneyMyLife.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 21/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class EndJourneyMyLife: UIView {

    @IBOutlet weak var endJourneyMyLifeView: UIView!
    @IBOutlet weak var calendarIcon: UILabel!
    @IBOutlet weak var clockIcon: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var blueFlag: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        calendarIcon.text = String(format: "%C", faicon["calendar"]!)
        clockIcon.text = String(format: "%C", faicon["clock"]!)
        endJourneyMyLifeView.layer.cornerRadius = 5
        blueFlag.clipsToBounds = true
        blueFlag.layer.cornerRadius = 22.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EndJourneyMyLife", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
    }

}

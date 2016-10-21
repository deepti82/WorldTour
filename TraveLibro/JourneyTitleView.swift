//
//  JourneyTitleView.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 23/04/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class JourneyTitleView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var calenderTitle: UILabel!
    @IBOutlet weak var calenderIcon: UILabel!
    @IBOutlet weak var clockIcon: UILabel!
    @IBOutlet weak var clockTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)        
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "JourneyTitleView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        titleLabel.font = UIFont(name: "Avenir-Roman", size: 20)
        //titleLabel.text = "Mumbai"
        calenderTitle.font = UIFont(name: "Avenir-Roman", size: 12)
        clockTitle.font = UIFont(name: "Avenir-Roman", size: 12)
        
        calenderIcon.font = FontAwesomeFont
        calenderIcon.text = String(format: "%C", faicon["calendar"]!)
        clockIcon.font = FontAwesomeFont
        clockIcon.text = String(format: "%C", faicon["clock"]!)
    }
    
}

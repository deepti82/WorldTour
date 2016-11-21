//
//  tripSummaryEach.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 28/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class tripSummaryEach: UIView {

    @IBOutlet weak var summaryTitle: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var clockText: UILabel!
    @IBOutlet weak var calendarText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        calendarLabel.text = String(format: "%C", faicon["calendar"]!)
        clockLabel.text = String(format: "%C", faicon["clock"]!)
        
//        let text = NSMutableAttributedString(string: "Evening by the beach! :) with Gayatri Sakalkar and Sarvesh Brahme at Girgaon", attributes: [NSForegroundColorAttributeName: UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1), NSFontAttributeName: avenirFont!])
    
//        summaryTitle.attributedText = text
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "tripSummaryEach", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
    

}

//
//  ChangeCity.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 08/10/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ChangeCity: UIView {
    
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var calendarIcon: UILabel!
    @IBOutlet weak var timeIcon: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var line: drawLine!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        line.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ChangeCity", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        cityButton.layer.cornerRadius = 10
        cityButton.clipsToBounds = true
        cityButton.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI / 90))
        
        //calendarIcon.font = FontAwesomeFont
        calendarIcon.text = String(format: "%C", faicon["calendar"]!)
        //timeIcon.font = FontAwesomeFont
        timeIcon.text = String(format: "%C", faicon["clock"]!)
        
        addShadow(dateLabel)
        addShadow(timeLabel)
        addShadow(calendarIcon)
        addShadow(timeIcon)
    }
    
    func addShadow(_ label: UILabel) {
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 1.0
        label.layer.shadowOffset = CGSize(width: 1, height: 2)
        label.layer.shadowOpacity = 1.0
    }
    
}

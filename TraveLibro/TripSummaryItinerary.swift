//
//  TripSummaryItinerary.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 14/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class TripSummaryItinerary: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taggedPeopleLabel: UILabel!
    @IBOutlet weak var checkedInLabel: UILabel!
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayNumberLabel: UILabel!
    @IBOutlet weak var checkInImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        dayView.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 255/255)
        dayLabel.textColor = UIColor(red: 255/255, green: 104/255, blue: 88/255, alpha: 255/255)
        dayNumberLabel.textColor = UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 255/255)
        titleLabel.textColor = mainBlueColor
        taggedPeopleLabel.textColor = mainBlueColor
        checkedInLabel.textColor = mainBlueColor
        checkInImage.image = UIImage(named: "palm_trees_icon")
        checkInImage.backgroundColor = UIColor(patternImage: UIImage(named: "halfnhalfbgGreen")!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TripSummaryItinerary", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        
        let timestamp = DateAndTime(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        timestamp.center = CGPoint(x: self.frame.size.width/3 + 60, y: self.frame.size.height/3 * 2 + 10)
        self.addSubview(timestamp)
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

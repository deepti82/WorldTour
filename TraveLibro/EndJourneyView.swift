//
//  EndJourneyView.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 04/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class EndJourneyView: UIView {

//    @IBOutlet weak var UserEndJourneyView: UIView!
//    @IBOutlet weak var endJourneyTitle: UILabel!
////    @IBOutlet weak var calendarIcon: UILabel!
////    @IBOutlet weak var clockIcon: UILabel!
//    @IBOutlet weak var userDp: UIImageView!
    @IBOutlet weak var journeyCoverPic: UIImageView!
    @IBOutlet weak var buddyStack: UIStackView!
    @IBOutlet weak var categoryStack: UIStackView!
    @IBOutlet weak var gradientView: UIView!
    
//    @IBOutlet weak var scrollEndJourneyView: UIScrollView!
    @IBOutlet weak var categoryOne: UIImageView!
    @IBOutlet weak var categoryTwo: UIImageView!
    @IBOutlet weak var categoryThree: UIImageView!
//    @IBOutlet weak var endDate: UILabel!
//    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var buddyCount: UILabel!
    @IBOutlet var categoryImages: [UIImageView]!
    @IBOutlet var buddiesImages: [UIImageView]!
    
    @IBOutlet weak var accesoriesVew: UIView!
    @IBOutlet weak var changePhotoText: UILabel!
    @IBOutlet weak var changePhotoButton: UIButton!
//    @IBOutlet weak var changePhotoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var accesoryHeight: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib ()
        
        let gradient = CAGradientLayer()
        
        let blackColour = UIColor.black.withAlphaComponent(0.8).cgColor as CGColor
        let transparent = UIColor.clear.cgColor as CGColor
        
        gradient.frame = self.bounds
        gradient.frame.size.width = gradientView.frame.width + 15
        gradient.colors = [transparent, blackColour]
        gradient.locations = [0.0, 0.90]
        self.gradientView.layer.addSublayer(gradient)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func changeConstraint(height: Int) {
        let conts = NSLayoutConstraint(item: accesoriesVew, attribute:
            .height, relatedBy: .equal, toItem: nil,
                     attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0,
                     constant: CGFloat(height))
        
        
        self.translatesAutoresizingMaskIntoConstraints = true
        NSLayoutConstraint.activate([conts])
    }
    
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EndJourneyView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
    }
    
    
}

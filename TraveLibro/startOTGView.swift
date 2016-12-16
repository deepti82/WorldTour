//
//  startOTGView.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 25/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class startOTGView: UIView {

    
    @IBOutlet weak var lineOne: drawLine!
    @IBOutlet weak var lineTwo: drawLine!
    @IBOutlet weak var lineThree: drawLine!
    @IBOutlet weak var journeyBuddiesCount: UILabel!
    @IBOutlet var journeyBuddiesDetail: [UIImageView]!
    @IBOutlet var journeyCategoryDetails: [UIImageView]!
    @IBOutlet weak var journeyDetails: UIView!
    @IBOutlet weak var addBuddiesButton: UIButton!
    @IBOutlet weak var selectCategoryButton: UIButton!
    @IBOutlet weak var cityDetails: UIView!
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var detectLocationView: UIView!
    @IBOutlet weak var journeyName: UILabel!
    @IBOutlet weak var nameJourneyView: UIView!
    @IBOutlet weak var startJourneyButton: UIButton!
    @IBOutlet weak var nameJourneyTF: UITextField!
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var detectLocationButton: UIButton!
    @IBOutlet weak var buddyStack: UIStackView!
    @IBOutlet weak var placeLabel: UILabel!
//    @IBOutlet weak var calendarIcon: UILabel!
//    @IBOutlet weak var clockIcon: UILabel!
    @IBOutlet weak var bonVoyageLabel: UILabel!
    @IBOutlet weak var timestampDate: UILabel!
//    @IBOutlet weak var timestampTime: UILabel!
    @IBOutlet weak var journeyCategoryOne: UIImageView!
    @IBOutlet weak var journeyCategoryTwo: UIImageView!
    @IBOutlet weak var journeyCategoryThree: UIImageView!
    
    @IBOutlet weak var dpFriendOne: UIImageView!
    @IBOutlet weak var dpFriendTwo: UIImageView!
    @IBOutlet weak var dpFriendThree: UIImageView!
    
    @IBOutlet var buddyStackPictures: [UIImageView]!
    @IBOutlet weak var optionsButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        if nameJourneyTF == viewWithTag(1) as? UITextField {
            print("taggedItIs")
            print("GOOGLE LIT");
        }
        startJourneyButton.layer.cornerRadius = 5
        
        let rocketLabel = UILabel(frame: CGRect(x: -22, y: -5, width: 22, height: 30))
        rocketLabel.font = UIFont(name: "FontAwesome", size: 15)
        rocketLabel.text = String(format: "%C", faicon["rocket"]!)
        rocketLabel.textColor = UIColor.white
        startJourneyButton.titleLabel?.addSubview(rocketLabel)
        
        nameJourneyTF.attributedPlaceholder = NSAttributedString(string: "Name Your Journey", attributes: [NSForegroundColorAttributeName: UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)])
        
        nameJourneyView.layer.cornerRadius = 5
        nameJourneyView.layer.shadowColor = UIColor.lightGray.cgColor
        nameJourneyView.layer.shadowOffset = CGSize(width: 2, height: 1)
        nameJourneyView.layer.shadowOpacity = 0.5
        nameJourneyView.layer.shadowRadius = 1.0
        
        optionsButton.tintColor = UIColor.white
//        calendarIcon.text = String(format: "%C", faicon["calendar"]!)
//        clockIcon.text = String(format: "%C", faicon["clock"]!)
        
        locationLabel.attributedPlaceholder = NSAttributedString(string: "Detect Location", attributes: [NSForegroundColorAttributeName: mainBlueColor])
        
        detectLocationView.layer.cornerRadius = 5
        detectLocationView.layer.shadowColor = UIColor.lightGray.cgColor
        detectLocationView.layer.shadowOffset = CGSize(width: 2, height: 1)
        detectLocationView.layer.shadowOpacity = 0.5
        detectLocationView.layer.shadowRadius = 1.0
        
        cityDetails.layer.cornerRadius = 5
        cityImage.layer.cornerRadius = 5
        cityImage.layer.borderColor = UIColor.white.cgColor
        cityImage.layer.borderWidth = 3.0
        cityImage.clipsToBounds = true
        
        selectCategoryButton.layer.cornerRadius = 5
        selectCategoryButton.layer.borderColor = UIColor.white.cgColor
        selectCategoryButton.layer.borderWidth = 1.0
        
        for icon in journeyCategoryDetails {
            
            icon.tintColor = UIColor(red: 252/255, green: 80/255, blue: 71/255, alpha: 1)
            
        }
        
        addBuddiesButton.layer.cornerRadius = 5
        addBuddiesButton.layer.borderColor = UIColor.white.cgColor
        addBuddiesButton.layer.borderWidth = 1.0
        
        lineOne.backgroundColor = UIColor.clear
        lineTwo.backgroundColor = UIColor.clear
        lineThree.backgroundColor = UIColor.clear
        
        journeyName.shadowColor = UIColor.black
        journeyName.shadowOffset = CGSize(width: 2, height: 1)
        journeyName.layer.masksToBounds = true
        
        placeLabel.shadowOffset = CGSize(width: 2, height: 1)
        placeLabel.layer.masksToBounds = true
        
        
        timestampDate.shadowOffset = CGSize(width: 2, height: 1)
        timestampDate.layer.masksToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "startOTGView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
    
  
}

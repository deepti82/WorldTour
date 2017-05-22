//
//  Itineraries.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 10/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class Itineraries: UIView {
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var coverImage: UIImageView!

    @IBOutlet weak var reviewStack: UIStackView!
    @IBOutlet weak var likeStack: UIStackView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var options: UIImageView!
    @IBOutlet weak var feedbackStack: UIStackView!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var daysBG: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var toTapView: UIView!
    
    @IBOutlet weak var stackViewDetailOne: UIImageView!
    @IBOutlet weak var stackViewDetailTwo: UIImageView!
    @IBOutlet weak var stackViewDetailThree: UIImageView!
    
    @IBOutlet weak var itineraryName: UILabel!
    @IBOutlet weak var itineraryDates: UILabel!
    @IBOutlet weak var itineraryCost: UILabel!
    @IBOutlet weak var itineraryCompleteCount: UILabel!    
    @IBOutlet weak var itineraryTypeStack: UIStackView!
    @IBOutlet weak var itineraryTypeOne: UIImageView!
    @IBOutlet weak var itineraryTypeTwo: UIImageView!    
    @IBOutlet weak var itineraryTypeThree: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let gradient = CAGradientLayer()
        
        let blackColour = UIColor.black.withAlphaComponent(0.8).cgColor as CGColor
        let transparent = UIColor.clear.cgColor as CGColor
        
        gradient.frame = gradientView.bounds
        gradient.frame.size.width = gradientView.frame.width + 100
        gradient.colors = [blackColour, transparent]
        gradient.locations = [0.0, 0.75]
        
        gradientView.layer.addSublayer(gradient)
        profileIcon.layer.cornerRadius = 5
        profileIcon.layer.zPosition = 10
        profileName.layer.zPosition = 10
        daysLabel.layer.zPosition = 10
        daysBG.layer.zPosition = 10
        
        stackViewDetailOne.tintColor = UIColor.white
        stackViewDetailTwo.tintColor = UIColor.white
        stackViewDetailThree.tintColor = UIColor.white
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        coverImage.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "Itineraries", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
    
    
    //MARK: - SetData
    
    func setItineraryData(editJson : JSON) {
        profileIcon.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(editJson["creator"]["profilePicture"].stringValue)", width: SMALL_PHOTO_WIDTH))
        makeBuddiesTLProfilePicture1(profileIcon)
        
        profileName.text = "By " + editJson["creator"]["name"].stringValue
        coverImage.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(editJson["coverPhoto"].stringValue)", width: BIG_PHOTO_WIDTH))
        if editJson["duration"].stringValue == "" {
            daysBG.isHidden = true
            daysLabel.isHidden = true
        }else {
             daysLabel.text = editJson["duration"].stringValue + "\nDays"
            daysBG.isHidden = false
            daysLabel.isHidden = false
            
        }
       
                
        itineraryName.text = getFirstLetterCapitalizedString(nameOfString: editJson["name"].stringValue)
        if editJson["cost"].intValue > 0 {
            itineraryCost.text = editJson["currency"].stringValue + " " + getDigitWithCommaStandards(originalDigitStr: editJson["cost"].stringValue)            
        }
        else {
            itineraryCost.text = ""
        }
        
        itineraryDates.text = getDateFormat(editJson["startTime"].stringValue, format: "dd MMM, yyyy") + " to " + getDateFormat(editJson["endTime"].stringValue, format: "dd MMM, yyyy") 
        
        itineraryTypeStack.isHidden = false
        
        if editJson["itineraryType"][0] != nil {
            itineraryTypeOne.isHidden = false
            itineraryTypeOne.image = UIImage(named: categoryImage(editJson["itineraryType"][0].stringValue.lowercased()))
        }
        if editJson["itineraryType"][1] != nil {
             itineraryTypeTwo.isHidden = false
             itineraryTypeTwo.image = UIImage(named: categoryImage(editJson["itineraryType"][1].stringValue.lowercased()))
        }
        if editJson["itineraryType"][2] != nil {
            itineraryTypeThree.isHidden = false
            itineraryTypeThree.image = UIImage(named: categoryImage(editJson["itineraryType"][2].stringValue.lowercased()))
        }
        
        
//        if editJson["itineraryType"].array!.count >= 3 {
//            
//            itineraryTypeOne.image = UIImage(named: categoryImage(categories[0].stringValue) )
//            itineraryTypeTwo.image = UIImage(named: categoryImage(categories[1].stringValue))
//            itineraryTypeThree.image = UIImage(named: categoryImage(categories[2].stringValue))
//            
//        }
//        else if editJson["itineraryType"].array!.count == 2 {
//            
//            itineraryTypeOne.image = UIImage(named: categoryImage(categories[0].stringValue) )
//            itineraryTypeTwo.image = UIImage(named: categoryImage(categories[1].stringValue))
//            itineraryTypeThree.isHidden = true
//            
//        }
//        else if editJson["itineraryType"].array!.count == 1 {
//            
//            itineraryTypeOne.image = UIImage(named: categoryImage(categories[0].stringValue) )
//            itineraryTypeTwo.isHidden = true
//            itineraryTypeThree.isHidden = true
//            
//        }
//        else {
//            
//            itineraryTypeStack.isHidden = true
//            
//        }
    }

}

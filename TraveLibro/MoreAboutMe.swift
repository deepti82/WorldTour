//
//  MoreAboutMe.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class MoreAboutMe: UIView {

    @IBOutlet weak var mainTextView: UITextView!
    
    var forUser: JSON?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MoreAboutMe", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        mainTextView.text = ""
    }
    
    func reloadTravelPrefeces() {
        
        if forUser != nil {
            
            let color = shouldShowTransperentNavBar ? UIColor.white : mainBlueColor
            let fontSize = shouldShowTransperentNavBar ? 14 : 14
            
            if (forUser?["travelConfig"].isEmpty)! {
                mainTextView.attributedText = getRegularStringWithColor(string: "-", size: fontSize, color: color)
                //getRegularString(string: "-", size: 14)
                mainTextView.textAlignment = .center
            }
            else{
                let name = (forUser?["name"].stringValue)!
                let kindOfHoliday = (forUser?["travelConfig"]["kindOfHoliday"][0].stringValue)!
                
                var kindOfHolidayFinal = ""
                let gender = (forUser?["gender"].stringValue)!
                var pronoun = "She"
                if(gender == "male") {
                    pronoun = "He"
                }
                var pronoun2 = "her"
                if(gender == "male") {
                    pronoun2 = "him"
                }
                var usuallyGo = ""
                switch((forUser?["travelConfig"]["usuallyGo"][0].stringValue)!) {
                case "A little bit of both":
                    usuallyGo = "by the map or where the road takes \(pronoun2)"
                    
                case "By the map":
                    usuallyGo = "by the map"
                    
                case "Where the road takes you":
                    usuallyGo = "where the road takes \(pronoun2)"
                    
                default:
                    break
                    //            usuallyGo = "by the map"
                }
                switch(kindOfHoliday) {
                case "Islands & Beaches":
                    kindOfHolidayFinal = "islands and beaches"
                case "Cities":
                    kindOfHolidayFinal = "cities"
                case "Safaris":
                    kindOfHolidayFinal = "safaries"
                case "Mountains":
                    kindOfHolidayFinal = "mountains"
                case "Cruise":
                    kindOfHolidayFinal = "cruises"
                case "Countrysides":
                    kindOfHolidayFinal = "countrysides"
                default:
                    break
                    //            kindOfHolidayFinal = "islands and beaches"
                }
                
                var preferStatement = ""
                switch((forUser?["travelConfig"]["preferToTravel"][0].stringValue)!) {
                case "Friends":
                    preferStatement  = "\(pronoun) prefers to travel with friends"
                case "Family":
                    preferStatement  = "\(pronoun) prefers to travel with family"
                case "Solo":
                    preferStatement  = "\(pronoun) prefers to travel solo"
                case "Partner/ Spouse":
                    preferStatement  = "\(pronoun) prefers to travel with their partner"
                case "Business":
                    preferStatement  = "\(pronoun) prefers to travel on business"
                case "Blogger":
                    preferStatement  = "\(pronoun) is a Blogger"
                case "Group Tour":
                    preferStatement  = "\(pronoun) prefers to travel on a group tour"
                case "Photographer":
                    preferStatement  = "\(pronoun) is a Photographer"
                case "Adventure":
                    preferStatement  = "\(pronoun) prefers adventures"
                default:
                    //            preferStatement  = "\(pronoun) prefers to travel with friends"
                    break
                }
                let holidayType = (forUser?["travelConfig"]["holidayType"][0].stringValue)!
                
                let MessageString = NSMutableAttributedString()
                
                if kindOfHolidayFinal != "" {
                    
                    MessageString.append(getBoldStringWithColor(string: name, size: fontSize, color: color))
                    
                    MessageString.append(getRegularStringWithColor(string: " loves to travel and explore ", size: fontSize, color: color))
                    
                    MessageString.append(getBoldStringWithColor(string: "\(kindOfHolidayFinal). ", size: fontSize, color: color))
                }
                
                if usuallyGo != "" {
                    if MessageString.string == "" {
                        MessageString.append(getBoldStringWithColor(string: name, size: fontSize, color: color))
                    }
                    else {
                        MessageString.append(getBoldStringWithColor(string: pronoun, size: fontSize, color: color))
                    }
                    MessageString.append(getRegularStringWithColor(string: " usually goes ", size: fontSize, color: color))
                    
                    MessageString.append(getBoldStringWithColor(string: "\(usuallyGo). ", size: fontSize, color: color))
                }
                
                if preferStatement != "" {
                    MessageString.append(getBoldStringWithColor(string: (preferStatement + ". "), size: fontSize, color: color))
                }
                
                if holidayType != "" {
                    
                    MessageString.append(getBoldStringWithColor(string: "\(name)'s", size: fontSize, color: color))
                    
                    MessageString.append(getRegularStringWithColor(string: " ideal holiday type is ", size: fontSize, color: color))
                    
                    MessageString.append(getBoldStringWithColor(string: "\(holidayType).", size: fontSize, color: color))
                }
                
                if MessageString.string != "" {
                    mainTextView.attributedText = MessageString
                }
                else{
                    mainTextView.attributedText = getRegularStringWithColor(string: "-", size: fontSize, color: color)
                }
                
                mainTextView.textAlignment = .center
                
            }
        }
        
    }

}

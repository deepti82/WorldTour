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
        
        if currentUser != nil {
            reloadTravelPrefeces()            
        }
    }
    
    func reloadTravelPrefeces() {
        
        if currentUser["travelConfig"].isEmpty {
            mainTextView.attributedText = getRegularString(string: "-", size: 14)
            mainTextView.textAlignment = .center
        }
        else{
            let name = currentUser["firstName"].stringValue
            let kindOfHoliday = currentUser["travelConfig"]["kindOfHoliday"][0].stringValue
            
            var kindOfHolidayFinal = ""
            let gender = currentUser["gender"].stringValue
            var pronoun = "She"
            if(gender == "male") {
                pronoun = "He"
            }
            var pronoun2 = "her"
            if(gender == "male") {
                pronoun2 = "him"
            }
            var usuallyGo = ""
            switch(currentUser["travelConfig"]["usuallyGo"][0].stringValue) {
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
            switch(currentUser["travelConfig"]["preferToTravel"][0].stringValue) {
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
            let holidayType = currentUser["travelConfig"]["holidayType"][0].stringValue
            
            let MessageString = NSMutableAttributedString()
            
            if kindOfHolidayFinal != "" {
            
                MessageString.append(getBoldString(string: name, size: 14))
                
                MessageString.append(getRegularString(string: " loves to travel and explore ", size: 14))
                
                MessageString.append(getBoldString(string: "\(kindOfHolidayFinal). ", size: 14))
            }
            
            if usuallyGo != "" {
                if MessageString.string == "" {
                    MessageString.append(getBoldString(string: name, size: 14))
                }
                else {
                    MessageString.append(getBoldString(string: pronoun, size: 14))
                }
                MessageString.append(getRegularString(string: " usually goes ", size: 14))
                
                MessageString.append(getBoldString(string: "\(usuallyGo). ", size: 14))
            }
            
            if preferStatement != "" {
                MessageString.append(getBoldString(string: (preferStatement + ". "), size: 14))
            }
            
            if holidayType != "" {
                MessageString.append(getBoldString(string: "\(name)'s", size: 14))
                
                MessageString.append(getRegularString(string: " ideal holiday type is ", size: 14))
                
                MessageString.append(getBoldString(string: "\(holidayType).", size: 14))
            }
            
            if MessageString.string != "" {
                mainTextView.attributedText = MessageString
            }
            else{
                mainTextView.attributedText = getRegularString(string: "-", size: 14)
            }
            
            mainTextView.textAlignment = .left
        
        }
       
        
    }

}

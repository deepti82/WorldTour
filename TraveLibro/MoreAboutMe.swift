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
        print(currentUser);
        
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
        switch(currentUser["travelConfig"]["usuallyGo"].stringValue) {
            case "A little bit of both":
            usuallyGo = "by the map or where the road takes \(pronoun2)"
            
            case "By the map":
            usuallyGo = "by the map"
            
            case "By the road":
            usuallyGo = "where the road takes \(pronoun2)"
            
            default:
            usuallyGo = "by the map"
        }
        switch(kindOfHoliday) {
            case "Island&Beach":
            kindOfHolidayFinal = "islands and beaches"
            case "City":
            kindOfHolidayFinal = "cities"
            case "Safari":
            kindOfHolidayFinal = "safaries"
            case "Mountains":
            kindOfHolidayFinal = "mountains"
            case "Cruise":
            kindOfHolidayFinal = "cruises"
            case "Countryside":
            kindOfHolidayFinal = "countrysides"
            default:
            kindOfHolidayFinal = "islands and beaches"
        }
        
        var preferStatement = ""
        switch(currentUser["travelConfig"]["preferToTravel"][0].stringValue) {
        case "Friends":
            preferStatement  = "\(pronoun) prefers to travel with friends"
        case "Family":
            preferStatement  = "\(pronoun) prefers to travel with family"
        case "Solo":
            preferStatement  = "\(pronoun) prefers to travel solo"
        case "Partner":
            preferStatement  = "\(pronoun) prefers to travel with their partner"
        case "Business":
            preferStatement  = "\(pronoun) prefers to travel on business"
        case "Blogger":
            preferStatement  = "\(pronoun) is a Blogger"
        case "Group Tour":
            preferStatement  = "\(pronoun) prefers to travel on a Group Tour"
        default:
            preferStatement  = "\(pronoun) prefers to travel with friends"
        }
        let holidayType = currentUser["travelConfig"]["holidayType"][0].stringValue
        
        mainTextView.text = "\(name) loves to travel and explore \(kindOfHolidayFinal). \(pronoun) usually goes \(usuallyGo). \(preferStatement). \(name)'s ideal holiday type is \(holidayType)."
        
    }

}

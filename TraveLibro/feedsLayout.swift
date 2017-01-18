//
//  feedsLayout.swift
//  TraveLibro
//
//  Created by Jagruti  on 18/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class feedsLayout: VerticalLayout  {

//    var feed: JSON!
    var profileHeader: ActivityProfileHeader!
    var activityFeed: ActivityFeedsController!
    let imageArr: [String] = ["restaurantsandbars", "leaftrans", "sightstrans", "museumstrans", "zootrans", "shopping", "religious", "cinematrans", "hotels", "planetrans", "health_beauty", "rentals", "entertainment", "essential", "emergency", "othersdottrans"]
    
    func createProfileHeader(feed:JSON) {
        profileHeader = ActivityProfileHeader(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 85))
        profileHeader.userName.text = feed["user"]["name"].stringValue
        profileHeader.profilePic.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["user"]["profilePicture"])", width: 100))
        profileHeader.localDate.text = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd-MM-yyyy", date: feed["createdAt"].stringValue, isDate: true)
        profileHeader.localTime.text = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["createdAt"].stringValue, isDate: false)
        
        profileHeader.category.setImage(UIImage(named:getCategoryImage(name: feed["checkIn"]["category"].stringValue)), for: .normal)

        self.addSubview(profileHeader)
        self.layoutSubviews()
    }
    
    func changeDateFormat(_ givenFormat: String, getFormat: String, date: String, isDate: Bool) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = givenFormat
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = getFormat
        
        if isDate {
            
            dateFormatter.dateStyle = .medium
            
        }
        
        let goodDate = dateFormatter.string(from: date!)
        return goodDate
        
    }
    
    func getCategoryImage(name: String) -> String {
        var str:String!
        for img in imageArr {
            print(img)
            print(String(name.characters.suffix(4)))
            if img.contains(String(name.characters.suffix(4))) {
                str = img
            }
        }
        return str
        
    }

}

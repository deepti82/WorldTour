//
//  ActivityProfileHeader.swift
//  TraveLibro
//
//  Created by Jagruti  on 17/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class ActivityProfileHeader: UIView {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var category: UIButton!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var localDate: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var localTime: UILabel!
    let imageArr: [String] = ["restaurantsandbars", "leaftrans", "sightstrans", "museumstrans", "zootrans", "shopping", "religious", "cinematrans", "hotels", "planetrans", "health_beauty", "rentals", "entertainment", "essential", "emergency", "othersdottrans"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        makeTLProfilePicture(profilePic)
        
        clockLabel.text = String(format: "%C", faicon["clock"]!)
        calendarLabel.text = String(format: "%C", faicon["calendar"]!)
        
                
    }
        required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fillProfileHeader(feed:JSON) {
        
        switch feed["type"].stringValue {
        case "local-life":
            category.setBackgroundImage(UIImage(named:"box8"), for: .normal)
        case "travel-life":
            category.setBackgroundImage(UIImage(named:"box7"), for: .normal)
        default:
            category.isHidden = true
        }
        
        userName.text = feed["user"]["name"].stringValue
        profilePic.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["user"]["profilePicture"])", width: 100))
        localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd-MM-yyyy", date: feed["createdAt"].stringValue, isDate: true)
        localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["createdAt"].stringValue, isDate: false)
        
        if getCategoryImage(name: feed["checkIn"]["category"].stringValue) != "" {
            
            category.setImage(UIImage(named:getCategoryImage(name: feed["checkIn"]["category"].stringValue)), for: .normal)
            
        }
        
    }
    
    func getCategoryImage(name: String) -> String {
        var str:String! = ""
        for img in imageArr {
            print(img)
            print(String(name.characters.suffix(4)))
            if img.contains(String(name.characters.suffix(4))) {
                str = img
            }
        }
        return str
        
    }
    
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ActivityProfileHeader", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
    }
    



}

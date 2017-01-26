//
//  ActivityProfileHeader.swift
//  TraveLibro
//
//  Created by Jagruti  on 17/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class ActivityProfileHeader: UIView {

    @IBOutlet var activityProView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var category: UIButton!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var localDate: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var localTime: UILabel!
    var currentFeed:JSON = []
    let imageArr: [String] = ["restaurantsandbars", "leaftrans", "sightstrans", "museumstrans", "zootrans", "shopping", "religious", "cinematrans", "hotels", "planetrans", "health_beauty", "rentals", "entertainment", "essential", "emergency", "othersdottrans"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        transparentCardWhite(activityProView)
        makeTLProfilePicture(profilePic)
        
        clockLabel.text = String(format: "%C", faicon["clock"]!)
        calendarLabel.text = String(format: "%C", faicon["calendar"]!)
        
        
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:[.topLeft, .topRight],
                                cornerRadii: CGSize(width: 5, height:  5))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
                
    }
        required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fillProfileHeader(feed:JSON) {
        currentFeed = feed
        
        switch feed["type"].stringValue {
        case "local-life":
            category.setBackgroundImage(UIImage(named:"box8"), for: .normal)
        case "travel-life":
            category.setBackgroundImage(UIImage(named:"box7"), for: .normal)
        default:
            category.isHidden = true
        }
        
        if feed["following"].boolValue {
            followButton.setTitle("Following", for: .normal)
        }else{
            followButton.setTitle("Follow", for: .normal)
        }
        
        self.category.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        userName.text = feed["user"]["name"].stringValue
        profilePic.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["user"]["profilePicture"])", width: 100))
        localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd-MM-yyyy", date: feed["createdAt"].stringValue, isDate: true)
        localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["createdAt"].stringValue, isDate: false)
        
        if getCategoryImage(name: feed["checkIn"]["category"].stringValue) != "" {
            
            category.setImage(UIImage(named:getCategoryImage(name: feed["checkIn"]["category"].stringValue)), for: .normal)
            
        }else{
            category.isHidden = true
        }
        
    }
    
    @IBAction func followClick(_ sender: UIButton) {
        
        if followButton.titleLabel?.text == "Follow" {
            request.followUser(currentUser["_id"].string!, followUserId: currentFeed["postCreator"]["_id"].stringValue, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    print("response arrived!")
                    self.followButton.setTitle("Following", for: .normal)
                    
                    
                }
                else {
                    
                    print("error: \(response["error"])")
                    
                }
                })
            })
        }else{
            request.unfollow(currentUser["_id"].string!, unFollowId: currentFeed["postCreator"]["_id"].stringValue, completion: {(response) in
                DispatchQueue.main.async(execute: {
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    print("response arrived!")
                    self.followButton.setTitle("Follow", for: .normal)
                    
                }
                else {
                    
                    print("error: \(response["error"])")
                    
                }
                })
            })
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

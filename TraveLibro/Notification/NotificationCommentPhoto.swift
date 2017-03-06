//
//  NotificationCommentPhoto.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 15/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class NotificationCommentPhoto: UIView {

    @IBOutlet weak var NFPhotoImage: UIImageView!
    @IBOutlet weak var NFPlayImage: UIImageView!
    @IBOutlet weak var NFLastPhotoImage: UIImageView!
    @IBOutlet weak var NFMoreItemLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "notificationCommentPhotoView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        NFPhotoImage.layer.cornerRadius = 8.0
        self.addSubview(view);
    }
    
    func setPhoto(data: JSON) {
        
        var imageURL = "" 
        NFPlayImage.isHidden = true        
        
        if (data["type"].string == "photo") {
            imageURL = data["name"].stringValue
        }
        else if (data["type"].string == "video") {
            imageURL = data["thumbnail"].stringValue
        }
        else if ((data["videos"].array?.count)! > 0) {
            //Showing img for video
            imageURL = (data["videos"].arrayValue.first()?.stringValue)!
            NFPlayImage.isHidden = false
        }
        else if ((data["photos"].array?.count)! > 0) {
            //Showing img for photo
            imageURL = (data["photos"].arrayValue.first()?.stringValue)!
        }        
        else if data["showMap"].boolValue && data["showMap"] != nil {
            // CHECKIN MAP IMAGE
            if ( data["checkIn"]["lat"].string != nil && data["checkIn"]["lat"] != "" ) && data["checkIn"]["long"].string != nil {
                
                let getKey = data["imageUrl"].string?.components(separatedBy: "=")
                mapKey = getKey!.last!
                
                let imageString = "https://maps.googleapis.com/maps/api/staticmap?zoom=12&size=800x600&maptype=roadmap&markers=color:red|\(data["checkIn"]["lat"].string!),\(data["checkIn"]["long"].string!)&key=\(mapKey)"
                var mapurl = URL(string: imageString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                if mapurl == nil {
                    mapurl = URL(string: "")
                }
                NFPhotoImage.hnk_setImageFromURL(mapurl!)
                return
            }
        }
        else if (data["thoughts"].stringValue != "") {
            //Showing img for thought
            imageURL = data["thoughts"].stringValue
        }
        
        NFPhotoImage.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(imageURL)", width: 100))
    }

}

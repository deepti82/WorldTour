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
        self.addSubview(view);
    }
    
    func setPhoto(data: JSON) {
        
        var imageURL = "" 
        NFPlayImage.isHidden = true
        
        if (data["type"].string == "photo") {
            imageURL = data["name"].stringValue
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
        else if (data["imageUrl"].stringValue != "") {
            //Showing img for map
            imageURL = data["imageUrl"].stringValue
        }
        else if (data["thoughts"].stringValue != "") {
            //Showing img for thought
            imageURL = data["thoughts"].stringValue
        }
        
        NFPhotoImage.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(imageURL)", width: 100))
    }

}

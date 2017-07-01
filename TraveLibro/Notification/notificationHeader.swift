//
//  notificationHeader.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 15/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

protocol TLNotificationHeaderDelegate {
    func notificationSenderProfilePictureTabbed(tag: Int)
}

class notificationHeader: UIView {

    
    @IBOutlet weak var NFProfilePicture: UIImageView!
    
    var notificationHeaderDelegate: TLNotificationHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "notificationHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]        
        self.addSubview(view);
    }
    
    func setHeaderData(data: JSON, parentVC: NotificationSubViewController?) {
        if parentVC != nil {
            self.notificationHeaderDelegate = parentVC
        }
        
        if data["type"].stringValue == "userBadge" {
            NFProfilePicture.sd_setImage(with: getImageURL(currentUser["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH),
                                         placeholderImage: getPlaceholderImage())
        }
        else {
            NFProfilePicture.sd_setImage(with: getImageURL(data["userFrom"]["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH),
                                         placeholderImage: getPlaceholderImage())
        }
          
        makeBuddiesTLProfilePicture(NFProfilePicture)
    }
    
    @IBAction func profilePictureTabbed(_ sender: UITapGestureRecognizer) {
        notificationHeaderDelegate?.notificationSenderProfilePictureTabbed(tag: self.tag)
    }

}

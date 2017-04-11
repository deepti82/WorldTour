//
//  notificationHeader.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 15/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class notificationHeader: UIView {

    
    @IBOutlet weak var NFProfilePicture: UIImageView!    
    
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
    
    func setHeaderData(data: JSON) {
        
        if data["type"].stringValue == "userBadge" {
            NFProfilePicture.hnk_setImageFromURL(getImageURL(currentUser["profilePicture"].stringValue, width: 100))
        }
        else {
            NFProfilePicture.hnk_setImageFromURL(getImageURL(data["userFrom"]["profilePicture"].stringValue, width: 100))
        }
          
        makeBuddiesTLProfilePicture(NFProfilePicture)
    }

}

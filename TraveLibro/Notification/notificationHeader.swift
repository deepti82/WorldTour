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
    @IBOutlet weak var NFDateLabel: UILabel!    
    @IBOutlet weak var NFTimeLabel: UILabel!
    @IBOutlet weak var NFCloseButton: UIButton!
    
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
        NFProfilePicture.layer.cornerRadius = 10
        NFProfilePicture.layer.borderWidth = 1
        NFProfilePicture.layer.borderColor = UIColor.white.cgColor
        self.addSubview(view);
    }
    
    func setHeaderData(data: JSON) {
        NFProfilePicture.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(data["userFrom"]["profilePicture"])", width: 100))
        makeTLProfilePicture(NFProfilePicture)
        
        NFDateLabel.text = getDateFormat(data["updatedAt"].stringValue, format: "dd MMM, yyyy")
        NFTimeLabel.text = getDateFormat(data["updatedAt"].stringValue, format: "hh.mm a")
    }

}

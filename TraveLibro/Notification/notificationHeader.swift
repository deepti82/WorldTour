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
    @IBOutlet weak var calendarLabel: UILabel!    
    @IBOutlet weak var clockLabel: UILabel!
    
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
        
       
        clockLabel.text = String(format: "%C", faicon["clock"]!)
        calendarLabel.text = String(format: "%C", faicon["calendar"]!)
        
        self.addSubview(view);
    }
    
    func setHeaderData(data: JSON) {
        
        NFProfilePicture.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(data["userFrom"]["profilePicture"])", width: 100))        
                
        NFProfilePicture.layer.cornerRadius = NFProfilePicture.frame.size.width * 0.30
        NFProfilePicture.layer.borderWidth = 2
        NFProfilePicture.layer.borderColor = UIColor.white.cgColor
        NFProfilePicture.clipsToBounds = true
        NFProfilePicture.contentMode = UIViewContentMode.scaleAspectFill
        
        NFDateLabel.text = getDateFormat(data["updatedAt"].stringValue, format: "dd MMM, yyyy")
        NFTimeLabel.text = getDateFormat(data["updatedAt"].stringValue, format: "hh.mm a")
    }

}

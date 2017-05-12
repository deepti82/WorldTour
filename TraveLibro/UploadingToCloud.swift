//
//  UploadingToCloud.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 04/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class UploadingToCloud: UIView {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var uploadText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "UploadingToCloud", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    func fillUploadingStrip(feed: JSON) {
        
        self.uploadText.text = "Uploading To Cloud..."
        
        if feed["type"].stringValue == "travel-life" {
            self.backgroundView.backgroundColor = mainOrangeColor            
            self.uploadText.textColor = UIColor.white
        }
        else if feed["type"].stringValue == "local-life" {
            self.backgroundView.backgroundColor = endJourneyColor
            self.uploadText.textColor = mainBlueColor
        }
        else if feed["type"].stringValue == "quick-itinerary" && (isLocalFeed(feed: feed) && quickItinery["status"].boolValue == false) {
            self.backgroundView.backgroundColor = mainOrangeColor
            self.uploadText.textColor = UIColor.white
            self.uploadText.text = "Uploading To My Life..."
        } 
    }
}

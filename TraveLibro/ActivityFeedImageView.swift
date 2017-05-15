//
//  ActivityFeedImageView.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 18/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class ActivityFeedImageView: UIView {
      
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var headerTagTextLabel: UILabel!
   
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var cameraCountLabel: UILabel!
    @IBOutlet weak var videoCountLabel: UILabel!
    @IBOutlet weak var locationCountLabel: UILabel!
    
    @IBOutlet weak var cameraImage: UIImageView!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var locationImage: UIImageView!
   
    @IBOutlet var circleViews: [UIView]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        cameraImage.tintColor = UIColor.white
        videoImage.tintColor = UIColor.white
        locationImage.tintColor = UIColor.white
        
        headerTagTextLabel.layer.cornerRadius = 5.0
        
        for view in circleViews {
            view.layer.cornerRadius = view.frame.size.height/2
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fillData(feed:JSON) {
        
        mainImageView.image = UIImage(named: "logo-default")
        
        if feed["coverPhoto"] != nil && feed["coverPhoto"] != "" {
            mainImageView.hnk_setImageFromURL(getImageURL(feed["coverPhoto"].stringValue, width: 0))
        }else if feed["startLocationPic"] != nil && feed["startLocationPic"] != "" {
            mainImageView.hnk_setImageFromURL(getImageURL(feed["startLocationPic"].stringValue, width: 0))
        }
        
        cameraCountLabel.text = feed["photoCount"].stringValue        
        videoCountLabel.text = feed["videoCount"].stringValue
        locationCountLabel.text = feed["checkInCount"].stringValue
        
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ActivityFeedImageView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.addSubview(view)
    }    

}

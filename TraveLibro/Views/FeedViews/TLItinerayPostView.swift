//
//  TLItinerayPostView.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 04/05/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class TLItinerayPostView: UIView {

   
    @IBOutlet weak var itineraryCoverImageView: UIImageView!
    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var creatorNameLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        makeTLProfilePictureBorder(creatorImageView, borderColor: UIColor(hex: "#868686"))
        
        let gradient = CAGradientLayer()
        
        let blackColour = UIColor.black.withAlphaComponent(0.8).cgColor as CGColor
        let transparent = UIColor.clear.cgColor as CGColor
        gradient.frame = gradientView.bounds
        gradient.frame.size.width = screenWidth
        gradient.colors = [blackColour, transparent]
        gradient.locations = [0.0, 0.75]
        self.gradientView.layer.addSublayer(gradient)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TLItinerayPostView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
    }
    
    
    func fillData(feed:JSON, pageType: viewType) {
        
        itineraryCoverImageView.image = UIImage(named: "logo-default")
        
        if feed["coverPhoto"] != nil && feed["coverPhoto"] != "" {
            self.itineraryCoverImageView.hnk_setImageFromURL(getImageURL(feed["coverPhoto"].stringValue, width: BIG_PHOTO_WIDTH))
        }
        else {
            if feed["photos"] != nil && feed["photos"] != "" {
                self.itineraryCoverImageView.hnk_setImageFromURL(getImageURL(feed["photos"][0]["name"].stringValue, width: BIG_PHOTO_WIDTH))
            }
            else {
                if feed["startLocationPic"] != nil && feed["startLocationPic"] != "" {
                    self.itineraryCoverImageView.hnk_setImageFromURL(getImageURL(feed["startLocationPic"].stringValue, width: BIG_PHOTO_WIDTH))
                }
            }
        }
        
        if pageType == viewType.VIEW_TYPE_ACTIVITY {
            self.creatorImageView.isHidden = true
            self.creatorNameLabel.isHidden = true
            self.gradientView.isHidden = true
        }
        else {
            self.creatorImageView.isHidden = false
            self.creatorNameLabel.isHidden = false
            self.gradientView.isHidden = false
            
            self.creatorImageView.hnk_setImageFromURL(getImageURL(feed["creator"]["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH))            
            self.creatorNameLabel.text = feed["creator"]["name"].stringValue
        }
        
    }
    
    

}

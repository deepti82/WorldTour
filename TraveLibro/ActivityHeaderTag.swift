//
//  ActivityHeaderTag.swift
//  TraveLibro
//
//  Created by Jagruti  on 19/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class ActivityHeaderTag: UIView {

    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var tagText: UILabel!
    @IBOutlet var tagParent: UIView!
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        loadViewFromNib ()
        tagView.clipsToBounds = true
        tagView.layer.cornerRadius = 5
        transparentBack()
        
    }

    func resetActivityHeaderTag() {
        self.tagText.text = ""
        self.tagText.textColor = UIColor.clear
        self.tagView.backgroundColor = UIColor.clear
    }
    
    func colorTag(feed:JSON) {
        
        if feed["type"].stringValue == "travel-life" {
            self.tagText.text = "Travel Life"
            self.tagText.textColor = UIColor.white
            self.tagView.backgroundColor = mainOrangeColor            
        }
        else if feed["type"].stringValue == "quick-itinerary" {
            self.tagText.text = "Unpublished"
            self.tagText.textColor = UIColor.white
            self.tagView.backgroundColor = mainOrangeColor
        }
        else{
            self.tagText.text = "  Local Life"
            self.tagText.textColor = UIColor(hex: "#303557")
            self.tagView.backgroundColor = endJourneyColor
        }
    }
    
    func transparentBack() {
        transparentCardWhite(tagParent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ActivityHeaderTag", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
    }

}

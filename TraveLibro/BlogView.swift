//
//  BlogView.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 24/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class BlogView: UIView {

    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var extraFlagsLabel: UILabel!
    @IBOutlet weak var flag3: UIImageView!
    @IBOutlet weak var flag2: UIImageView!
    @IBOutlet weak var flag1: UIImageView!
    @IBOutlet weak var blogDetailView: UIView!
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var clockIcon: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        flag3.layer.cornerRadius = self.flag3.frame.size.height/2
        flag3.clipsToBounds = true
        flag3.layer.borderColor = UIColor.whiteColor().CGColor
        flag3.layer.borderWidth = CGFloat(1.5)
        
        flag2.layer.cornerRadius = self.flag2.frame.size.height/2
        flag2.clipsToBounds = true
        flag2.layer.borderColor = UIColor.whiteColor().CGColor
        flag2.layer.borderWidth = CGFloat(1.5)
        
        flag1.layer.cornerRadius = self.flag1.frame.size.height/2
        flag1.clipsToBounds = true
        flag1.layer.borderColor = UIColor.whiteColor().CGColor
        flag1.layer.borderWidth = CGFloat(1.5)
        
        
        likesLabel.text = String(format: "%C", faicon["likes"]!)
        reviewsLabel.text = String(format: "%C", faicon["reviews"]!)
        clockIcon.text = String(format: "%C", faicon["clock"]!)
        
        tagView.backgroundColor = mainBlueColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "BlogView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

//
//  InProfileOTGPost.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 30/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class InProfileOTGPost: UIView {

    @IBOutlet weak var iconButtonView: UIView!
    @IBOutlet weak var OTGTitleLabel: LeftPaddedLabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var flag1: UIImageView!
    @IBOutlet weak var flag3: UIImageView!
    @IBOutlet weak var flag2: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var journeyIcon1: UIImageView!
    @IBOutlet weak var journeyIcon2: UIImageView!
    @IBOutlet weak var journeyIcon3: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let iconButton = IconButton(frame: CGRect(x: 0, y: 0, width: iconButtonView.frame.size.width, height: iconButtonView.frame.size.width))
        iconButton.button.backgroundColor = mainOrangeColor
        iconButton.button.setImage(UIImage(named: "add_friend_icon"), forState: .Normal)
        iconButton.button.layer.cornerRadius = 15
        iconButtonView.addSubview(iconButton)
        
        likesLabel.text = String(format: "%C", faicon["likes"]!)
        
        OTGTitleLabel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        
        styleFlags(flag1)
        styleFlags(flag2)
        styleFlags(flag3)
        
        journeyIcon1.tintColor = UIColor.whiteColor()
        journeyIcon2.tintColor = UIColor.whiteColor()
        journeyIcon3.tintColor = UIColor.whiteColor()
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "InProfileOTGPost", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }
    
    func styleFlags(flag: UIImageView) -> Void {
        
        flag.layer.cornerRadius = flag.frame.height/2
        flag.layer.borderWidth = 1.0
        flag.layer.borderColor = UIColor.whiteColor().CGColor
        flag.clipsToBounds = true
    }

}

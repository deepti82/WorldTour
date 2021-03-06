//
//  AddPostsOTGView.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 28/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class AddPostsOTGView: UIView {

    @IBOutlet weak var addBuddiesButton: UIButton!
    @IBOutlet weak var endJourneyButton: UIButton!
    @IBOutlet weak var addPhotosButton: UIButton!
    @IBOutlet weak var addCheckInButton: UIButton!
    @IBOutlet weak var addThoughtsButton: UIButton!
    @IBOutlet weak var addVideosButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        closeButton.setTitle(String(format: "%C", faicon["close"]!), forState: .Normal)
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame.size.height = self.frame.height
        blurView.frame.size.width = self.frame.width
        blurView.layer.zPosition = -1
        blurView.userInteractionEnabled = false
        self.addSubview(blurView)
        
        self.layer.opacity = 0.0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "AddPostsOTG", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

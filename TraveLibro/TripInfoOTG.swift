//
//  TripInfoOTG.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 27/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class TripInfoOTG: UIView {
    
    @IBOutlet weak var reviewsButton: UIButton!
    @IBOutlet weak var photosButton: UIButton!
    @IBOutlet weak var videosButton: UIButton!
    @IBOutlet weak var summaryButton: UIButton!
    
    @IBOutlet weak var crollInoView: UIScrollView!
    @IBOutlet weak var videosCount: UIButton!
    @IBOutlet weak var photosCount: UIButton!
    @IBOutlet weak var ratingCount: UIButton!    
    @IBOutlet weak var aboutLocationText: UILabel!    

    @IBOutlet var notifications: [UIButton]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        for image in notifications {
            
            image.layer.cornerRadius = image.frame.height/2
            
        }
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame.size.height = self.frame.height
        blurView.frame.size.width = self.frame.width
        blurView.layer.zPosition = -1
        blurView.isUserInteractionEnabled = false
        self.addSubview(blurView)
        
        self.layer.opacity = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TripInfoOTG", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        self.crollInoView.contentSize = CGSize(width: 2000, height: 2000)
    }

}

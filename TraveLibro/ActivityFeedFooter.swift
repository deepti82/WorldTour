//
//  ActivityFeedFooter.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 18/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
import Spring

class ActivityFeedFooter: UIView {

   
    @IBOutlet weak var ActivityFeedFooterView: UIView!
    @IBOutlet weak var travelLifeSymbol: UIImageView!
    @IBOutlet weak var reviewsCount: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var likeIcon: UILabel!
    @IBOutlet weak var commentsIcon: UILabel!
    @IBOutlet weak var options: UIButton!
    @IBOutlet weak var ratingsLabel: UIStackView!
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var reviews: UIButton!
    @IBOutlet weak var comments: SpringButton!
    @IBOutlet weak var LikeButton: SpringButton!
    @IBOutlet weak var lineView1: UIView!
    @IBOutlet weak var lineView2: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        transparentCardWhite(ActivityFeedFooterView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ActivityFeedImageView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
    }
    @IBAction func commentsButton(_ sender: Any) {
    }
    @IBAction func likeButtonTap(_ sender: Any) {
    }

    @IBAction func reviewsButton(_ sender: Any) {
    }
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
}

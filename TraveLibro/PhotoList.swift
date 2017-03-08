//
//  PhotoList.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 03/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Spring

class PhotoList: UIView {

    @IBOutlet weak var likesIcon: UILabel!
    @IBOutlet weak var clockIcon: UILabel!
    @IBOutlet weak var videoIcon: UIImageView!
    @IBOutlet weak var likeButton: SpringButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentIcon: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var mi: JSON = []
    let border = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        likesIcon.text = String(format: "%C", faicon["likes"]!)
        clockIcon.text = String(format: "%C", faicon["clock"]!)
        commentIcon.text = String(format: "%C", faicon["comments"]!)
        likeButton.tintColor = mainBlueColor
        commentButton.tintColor = mainBlueColor
        shareButton.tintColor = mainBlueColor
        
//        border.isHidden = false
//        let width = CGFloat(2)
//        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
//        border.borderColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 0.5).cgColor
//        border.borderWidth = width
//        self.layer.addSublayer(border)
//        self.layer.masksToBounds = true
        
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:[.topLeft, .topRight],
                                cornerRadii: CGSize(width: 10, height:  10))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @IBAction func likeClicked(_ sender: SpringButton) {
    }
    
    @IBAction func commentClicked(_ sender: UIButton) {
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PhotoList", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
}

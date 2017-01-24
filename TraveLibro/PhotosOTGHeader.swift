//
//  PhotosOTGHeader.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 28/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class PhotosOTGHeader: UIView {

    @IBOutlet var headerTransparent: UIView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var headerTransparent1: UIView!
    
    @IBOutlet weak var drawLine2: UIView!
    @IBOutlet weak var drawL: drawLine!
    @IBOutlet weak var postDp: UIImageView!
    @IBOutlet weak var whatPostIcon: UIButton!
    @IBOutlet weak var photosTitle: ActiveLabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var footer: UIView!
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowColor = UIColor.black.cgColor

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
                self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 1)
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PhotosOTGHeader", bundle: bundle)

       
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        clockLabel.text = String(format: "%C", faicon["clock"]!)
        calendarLabel.text = String(format: "%C", faicon["calendar"]!)
//        lineUp.backgroundColor = UIColor.clear
        
        postDp.layer.cornerRadius = 10
////        postDp.layer.borderWidth = 0.5
//        postDp.layer.borderColor = UIColor(hex: "#FF6858").cgColor
        
        drawL.backgroundColor = UIColor.clear
        
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:[.topLeft, .topRight],
                                cornerRadii: CGSize(width: 5, height:  5))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        footer.layer.mask = maskLayer
    }
    
    func makeTLProfilePicture(_ image: UIImageView) {
        
        image.layer.cornerRadius = (37/100) * image.frame.width
//        image.layer.borderWidth = 1.0
//        image.layer.borderColor = mainOrangeColor.cgColor
        image.clipsToBounds = true
        
    }
    func makeTLProfilePicture(button: UIButton) {
        
        button.layer.cornerRadius = (37/100) * button.frame.width
        button.layer.borderWidth = 1.0
        button.layer.borderColor = mainOrangeColor.cgColor
        button.clipsToBounds = true
        
    }


    
}


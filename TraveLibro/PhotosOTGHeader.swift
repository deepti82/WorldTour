//
//  PhotosOTGHeader.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 28/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class PhotosOTGHeader: UIView {

    @IBOutlet weak var PhotoOTGHeaderView: UIView!
    @IBOutlet weak var postDp: UIImageView!
    @IBOutlet weak var whatPostIcon: UIButton!
    @IBOutlet weak var photosTitle: ActiveLabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
  

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PhotosOTGHeader", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        clockLabel.text = String(format: "%C", faicon["clock"]!)
        calendarLabel.text = String(format: "%C", faicon["calendar"]!)
//        lineUp.backgroundColor = UIColor.clear
        
        
        
        postDp.hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])&width=100")!)
        makeTLProfilePicture(postDp)

        
        
        
        postDp.layer.cornerRadius = 10
        postDp.layer.borderWidth = 2
        postDp.layer.borderColor = UIColor.orange.cgColor
        
    }
    
    func makeTLProfilePicture(_ image: UIImageView) {
        
        image.layer.cornerRadius = (37/100) * image.frame.width
        image.layer.borderWidth = 3.0
        image.layer.borderColor = UIColor.white.cgColor
        image.clipsToBounds = true
        
    }
    func makeTLProfilePicture(button: UIButton) {
        
        button.layer.cornerRadius = (37/100) * button.frame.width
        button.layer.borderWidth = 3.0
        button.layer.borderColor = UIColor.white.cgColor
        button.clipsToBounds = true
        
    }


    
}


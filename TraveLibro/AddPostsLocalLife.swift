//
//  AddPostsLocalLife.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 01/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class AddPostsLocalLife: UIView {

    @IBOutlet weak var thoughtsButton: UIButton!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let photo = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        photo.center = CGPointMake((photoButton.titleLabel?.frame.width)!/2 + 5, (photoButton.titleLabel?.frame.height)!/2 + 7.5)
        photo.image = UIImage(named: "camera_icon")
        photo.contentMode = .ScaleAspectFit
        photoButton.titleLabel?.addSubview(photo)
        
        let video = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        video.center = CGPointMake((videoButton.titleLabel?.frame.width)!/2 + 5, (videoButton.titleLabel?.frame.height)!/2 + 7.5)
        video.image = UIImage(named: "video_icon")
        video.contentMode = .ScaleAspectFit
        videoButton.titleLabel?.addSubview(video)
        
        let checkIn = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        checkIn.center = CGPointMake((checkInButton.titleLabel?.frame.width)!/2 + 5, (checkInButton.titleLabel?.frame.height)!/2 + 7.5)
        checkIn.image = UIImage(named: "location_icon")
        checkIn.contentMode = .ScaleAspectFit
        checkInButton.titleLabel?.addSubview(checkIn)
        
        let thoughts = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        thoughts.center = CGPointMake((thoughtsButton.titleLabel?.frame.width)!/2 + 5, (thoughtsButton.titleLabel?.frame.height)!/2 + 7.5)
        thoughts.image = UIImage(named: "pen_icon")
        thoughts.contentMode = .ScaleAspectFit
        thoughtsButton.titleLabel?.addSubview(thoughts)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "AddPostsLocalLife", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        
    }
}

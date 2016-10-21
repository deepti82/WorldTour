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
        photo.center = CGPoint(x: (photoButton.titleLabel?.frame.width)!/2 + 5, y: (photoButton.titleLabel?.frame.height)!/2 + 7.5)
        photo.image = UIImage(named: "camera_icon")
        photo.contentMode = .scaleAspectFit
        photoButton.titleLabel?.addSubview(photo)
        
        let video = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        video.center = CGPoint(x: (videoButton.titleLabel?.frame.width)!/2 + 5, y: (videoButton.titleLabel?.frame.height)!/2 + 7.5)
        video.image = UIImage(named: "video_icon")
        video.contentMode = .scaleAspectFit
        videoButton.titleLabel?.addSubview(video)
        
        let checkIn = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        checkIn.center = CGPoint(x: (checkInButton.titleLabel?.frame.width)!/2 + 5, y: (checkInButton.titleLabel?.frame.height)!/2 + 7.5)
        checkIn.image = UIImage(named: "location_icon")
        checkIn.contentMode = .scaleAspectFit
        checkInButton.titleLabel?.addSubview(checkIn)
        
        let thoughts = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        thoughts.center = CGPoint(x: (thoughtsButton.titleLabel?.frame.width)!/2 + 5, y: (thoughtsButton.titleLabel?.frame.height)!/2 + 7.5)
        thoughts.image = UIImage(named: "pen_icon")
        thoughts.contentMode = .scaleAspectFit
        thoughtsButton.titleLabel?.addSubview(thoughts)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AddPostsLocalLife", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        
    }
}

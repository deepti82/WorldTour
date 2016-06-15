//
//  ProfileMainView.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 21/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ProfileMainView: UIView {
    internal var flag = 0
    dynamic var myDate = NSDate()
    
    @IBOutlet weak var MAMView: UIView!
    @IBOutlet weak var flagText: UILabel!
    @IBOutlet weak var flagView: UIImageView!
    @IBOutlet weak var ProfileImageView: UIView!
        override init(frame: CGRect) {
            super.init(frame: frame)
            loadViewFromNib ()
            
            let profile = ProfilePic(frame: CGRect(x: 0, y: 0, width: ProfileImageView.frame.width, height: ProfileImageView.frame.height))
            ProfileImageView.addSubview(profile)
            
//            self.addObserver(self, forKeyPath: "hasChanged", options: .New, context: nil)
            
            self.bringSubviewToFront(flagView)
            self.bringSubviewToFront(flagText)
            
            let myView = MoreAboutMe(frame: CGRect(x: 0, y: 0, width: MAMView.frame.width, height: MAMView.frame.height))
            MAMView.addSubview(myView)
            
        }
    
        override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
            
            print("this function is getting called!!")
            print("y position: \(profileViewY)")
//            let storyboard = UIStoryboard.init()
            let vc = ProfileViewController()
            print("view controller view: \(vc.view)")
//            vc.profileCollectionView.setNeedsDisplay()
            
        }
    
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        func loadViewFromNib() {
            let bundle = NSBundle(forClass: self.dynamicType)
            let nib = UINib(nibName: "ProfileMainView", bundle: bundle)
            let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
            view.frame = bounds
            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            self.addSubview(view);
        }
    
        deinit {
        
            self.removeObserver(self, forKeyPath: "myDate")
            
        }
}

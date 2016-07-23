//
//  EndLocalLife.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 01/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class EndLocalLife: UIView {
    
    var flag = false
    var isTravelLife = false
    var hasButtonRotated = false
    
    @IBOutlet weak var addPostButtonsView: UIView!
    @IBOutlet weak var addPostsView: UIView!
    @IBOutlet weak var speechView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    //@IBOutlet weak var closeButtonUp: UIButton!
    @IBOutlet weak var closeButtonUp: UIButton!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var camera: UIStackView!
    @IBOutlet weak var video: UIStackView!
    @IBOutlet weak var thoughts: UIStackView!
    @IBOutlet weak var checkIn: UIStackView!
    
    @IBAction func closeButtonTap(sender: AnyObject) {
        
        closeButton.transform = CGAffineTransformRotate(closeButton.transform, CGFloat(M_PI_4))
//        print("inside close button tap")
        if !hasButtonRotated {
            
            closeButtonUp.transform = CGAffineTransformRotate(closeButtonUp.transform, CGFloat(M_PI_4))
            hasButtonRotated = true
            
        }
        
        if !flag {
            
//            addPostsView.layer.opacity = 0.0
            addPostsView.animation.makeBounds(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)).easeIn.makeOpacity(1.0).animate(0.3)
            camera.animation.makeScale(1.1).thenAfter(0.1).makeScale(0.9).animate(0.2)
            video.animation.makeScale(1.1).thenAfter(0.1).makeScale(0.9).animate(0.2)
            thoughts.animation.makeScale(1.1).thenAfter(0.1).makeScale(0.9).animate(0.2)
            checkIn.animation.makeScale(1.1).thenAfter(0.1).makeScale(0.9).animate(0.2)
            flag = true
            
        }
        
        else if flag {
            
//            speechView.hidden = true
            addPostsView.animation.makeOpacity(0.0).animate(0.3)
            flag = false
        }
        
        if isTravelLife {
            
            speechView.hidden = false
            
        }
        
        else {
            
            
        }
        
    }
    
    @IBAction func photosTap(sender: AnyObject) {
        
        print("Tapped photos")
        
    }
    
//    @IBAction func closeButtonUpTap(sender: AnyObject) {
//        
//        print("in close button Tap")
//        addPostsView.hidden = true
//        
//    }
    
    @IBAction func closeButtonUpTap(sender: AnyObject) {
        
        print("in close button Tap")
        addPostsView.animation.makeOpacity(0.0).animate(0.3)
        closeButton.transform = CGAffineTransformRotate(closeButton.transform, CGFloat(M_PI_4))
        flag = false
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        speechView.hidden = true
        addPostsView.layer.opacity = 0.0
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame.size.height = 1000
        blurView.frame.size.width = 1000
        blurView.layer.zPosition = -1
        blurView.userInteractionEnabled = false
        addPostsView.addSubview(blurView)
        
        let closeButtonString = String(format: "%C", faicon["close"]!)
        closeButtonUp.setTitle(closeButtonString, forState: .Normal)
        closeButtonUp.layer.zPosition = 100
        
        closeButton.layer.zPosition = 10
        
//        self.bringSubviewToFront(addPostsView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "EndLocalLife", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        
    }
    
}

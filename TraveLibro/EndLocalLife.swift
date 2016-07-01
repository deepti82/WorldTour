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
    
    @IBOutlet weak var addPostButtonsView: UIView!
    @IBOutlet weak var addPostsView: UIView!
    @IBOutlet weak var speechView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    //@IBOutlet weak var closeButtonUp: UIButton!
    @IBOutlet weak var closeButtonUp: UIButton!
    @IBOutlet weak var checkInButton: UIButton!
    
    @IBAction func closeButtonTap(sender: AnyObject) {
        
        closeButton.transform = CGAffineTransformRotate(closeButton.transform, CGFloat(M_PI_4))
//        print("inside close button tap")
        
        if !flag {
            
//            speechView.hidden = false
            addPostsView.hidden = false
            flag = true
            
        }
        
        else {
            
//            speechView.hidden = true
            addPostsView.hidden = true
            flag = false
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
        addPostsView.hidden = true
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        speechView.hidden = true
        addPostsView.hidden = true
        
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

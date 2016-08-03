//
//  AddCheckIn.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 28/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class AddCheckIn: UIView, UITextViewDelegate {

    @IBOutlet weak var locationImageView: UIView!
    @IBOutlet weak var checkInDescription: UITextView!
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        checkInDescription.text = "Fill me in..."
        checkInDescription.textColor = UIColor.lightGrayColor()
        
        checkInDescription.delegate = self
        
//        locationImageView.backgroundColor = UIColor(patternImage: UIImage(named: "green_bg_new_small")!)
        
        let bgImage = UIImageView(frame: CGRect(x: 0, y: 0, width: locationImageView.frame.width, height: locationImageView.frame.height))
        bgImage.image = UIImage(named: "green_bg_new_small")
        bgImage.layer.zPosition = -1
        locationImageView.addSubview(bgImage)
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if textView.textColor == UIColor.lightGrayColor() {
            
            print("in the if statement1")
            textView.text = nil
            textView.textColor = UIColor.blackColor()
            
        }
        
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        if textView.text.isEmpty {
            
            print("in the if statement2")
            textView.text = "Fill me in..."
            textView.textColor = UIColor.lightGrayColor()
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "AddCheckIn", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

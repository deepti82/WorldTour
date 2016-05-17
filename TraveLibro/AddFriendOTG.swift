//
//  AddFriendOTG.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 16/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class AddFriendOTG: UIView {

    @IBOutlet weak var hiImage: UIImageView!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        addFriendButton.setImage(UIImage(named: "add_friend_icon"), forState: .Normal)
        addFriendButton.tintColor = UIColor.whiteColor()
        addFriendButton.backgroundColor = UIColor(red: 17/255, green: 211/255, blue: 204/255, alpha: 1)
        addFriendButton.layer.cornerRadius = 15
        addFriendButton.layer.zPosition = 11
        
        profileImage.layer.zPosition = 10
        hiImage.layer.zPosition = 12
        
        textView.backgroundColor = mainOrangeColor
        textView.layer.cornerRadius = 5
        timestamp.textColor = mainBlueColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "AddFriendOTG", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

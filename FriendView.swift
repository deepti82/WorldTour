//
//  FriendView.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 11/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class FriendView: UIView {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        profileName.backgroundColor = UIColor.clearColor()
        profileImage.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "FriendView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

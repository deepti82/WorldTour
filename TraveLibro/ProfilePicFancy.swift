//
//  ProfilePicFancy.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 9/3/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ProfilePicFancy: UIView {

    @IBOutlet weak var waves: UIImageView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var country: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        makeTLProfilePicture(image)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ProfilePicFancy", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
    
}

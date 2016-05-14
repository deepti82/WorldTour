//
//  AddRating.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 14/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class AddRating: UIView {

    @IBOutlet weak var smileyIconView: UIView!
    @IBOutlet weak var smileyIcon: UIImageView!
    @IBOutlet weak var addReviewLink: UILabel!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        smileyIconView.layer.cornerRadius = 40
        smileyIconView.backgroundColor = UIColor(red: 17/255, green: 211/255, blue: 204/255, alpha: 255/255)
        addReviewLink.textColor = UIColor(red: 17/255, green: 211/255, blue: 204/255, alpha: 255/255)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "AddRating", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }
    

}

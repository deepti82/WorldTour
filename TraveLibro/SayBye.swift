//
//  SayBye.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 17/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SayBye: UIView {

    @IBOutlet weak var byeImage: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var textView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        textView.backgroundColor = mainBlueColor
        textView.layer.cornerRadius = 5
        timestamp.textColor = UIColor(red: 105/255, green: 147/255, blue: 171/255, alpha: 1)
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.zPosition = 2
        byeImage.layer.zPosition = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "SayBye", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

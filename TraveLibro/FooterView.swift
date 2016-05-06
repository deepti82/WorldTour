//
//  FooterView.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 23/04/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class FooterView: UIView {
    
    @IBOutlet weak var footerImage: UIImageView!
    @IBOutlet weak var footerText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        footerText.font = UIFont(name: "Avenir-Roman", size: 12)
        footerImage.tintColor = UIColor(red: 123/255, green: 128/255, blue: 148/255, alpha: 1)
        footerText.textColor = UIColor(red: 123/255, green: 128/255, blue: 148/255, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "FooterView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }
    
}

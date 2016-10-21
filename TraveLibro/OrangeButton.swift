//
//  OrangeButton.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 23/04/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class OrangeButton: UIView {
    
    @IBOutlet weak var orangeButtonTitle: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        orangeButtonTitle.layer.cornerRadius = 5
        orangeButtonTitle.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 14)
//        let fontAwesomeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: self.frame.size.height))
//        fontAwesomeLabel.center = CGPointMake(0, self.frame.size.height/4)
//        fontAwesomeLabel.font = FontAwesomeFont
//        fontAwesomeLabel.text = String(format: "%C", faicon["rocket"]!)
//        fontAwesomeLabel.textColor = UIColor.whiteColor()
//        orangeButtonTitle.titleLabel?.addSubview(fontAwesomeLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "OrangeButton", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
    
}

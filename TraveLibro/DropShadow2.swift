//
//  DropShadow2.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 28/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class DropShadow2: UIView {

    @IBOutlet var dropShadow: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        dropShadow.layer.cornerRadius = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DropShadow2", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        dropShadow.layer.cornerRadius = 1
        dropShadow.alpha = 0.7
        
        let path = UIBezierPath(roundedRect:dropShadow.bounds,
                                byRoundingCorners:[.bottomRight, .bottomLeft],
                                cornerRadii: CGSize(width: 10, height:  10))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer

    }

}

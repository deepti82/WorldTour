//
//  ImageMask.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 17/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class TagViewFrame: UIView {
    
    override func draw(_ rect: CGRect) {
        
        let mask = CAShapeLayer()
        mask.frame = self.layer.bounds
        
        let width = self.layer.bounds.width
        let height = self.layer.bounds.height
        
        let path = CGMutablePath()
        
//        CGPathMoveToPoint(path, nil, 0, 0)
//        CGPathAddCurveToPoint(path, nil, 15, 0, 15, 30, 0, 30)
//        CGPathAddArc(path, nil, 20, height/2 - 5, height/2, 0, 90, false)
//        CGPathAddLineToPoint(path, nil, width, 0)
//        CGPathAddLineToPoint(path, nil, width, height)
//        CGPathAddLineToPoint(path, nil, 30, height)
//        CGPathAddLineToPoint(path, nil, 30, 0)
        
        mask.path = path
        self.layer.mask = mask
    }
}

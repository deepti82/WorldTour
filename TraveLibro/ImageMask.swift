//
//  ImageMask.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 17/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class CircleImageMask: UIView {
    
    override func drawRect(rect: CGRect) {
        
        var mask = CAShapeLayer()
        mask.frame = rect
        
        let width = rect.width
        let height = rect.height
        
        var path = CGPathCreateMutable()
        
        CGPathMoveToPoint(path, nil, 30, 0)
        CGPathAddLineToPoint(path, nil, width, 0)
        CGPathAddLineToPoint(path, nil, width, height)
        CGPathAddLineToPoint(path, nil, 0, height)
        CGPathAddLineToPoint(path, nil, 30, 0)
        
        mask.path = path
        
    }
}

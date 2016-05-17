//
//  ImageMask.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 17/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class CircleImageMask: UIImageView {
    
    override func drawRect(rect: CGRect) {
        
    }
    
    override func setNeedsLayout() {
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: self.frame.size.width/3, y: self.frame.size.height))
//        path.addLineToPoint(CGPoint(x: self.frame.size.width, y: self.frame.size.height/2))
//        path.addLineToPoint(CGPoint(x: self.frame.size.width/2, y: 0))
        path.addArcWithCenter(CGPoint(x: self.frame.size.width/3, y: self.frame.size.height/2), radius: self.frame.size.height/2, startAngle:-CGFloat(M_PI_2), endAngle: -CGFloat(M_PI_2), clockwise: false)
        
//        path.moveToPoint(CGPoint(x: self.frame.size.width/2, y: self.frame.size.height))
        path.closePath()
        UIColor.redColor().setFill()
        path.stroke()
        path.bezierPathByReversingPath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = path.CGPath
        shapeLayer.fillColor = UIColor.redColor().CGColor
        self.layer.mask = shapeLayer;
        self.layer.masksToBounds = true;
        
        
    }
}

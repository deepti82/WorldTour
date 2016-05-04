//
//  drawLine.swift
//  TraveLibro
//
//  Created by Chintan Shah on 02/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class drawLine: UIView {

    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 5.0)
        CGContextSetStrokeColorWithColor(context, UIColor.orangeColor().CGColor)
        CGContextSetLineDash(context, 0, [7.5], 1)
        //CGContextSetLineCap(context, kCGLineCapRound)
        
        CGContextMoveToPoint(context, 0, 0)
        CGContextAddLineToPoint(context, 0, 1000)
        
        CGContextStrokePath(context)
        
    }

}


class drawFooterLine: UIView {
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        CGContextSetStrokeColorWithColor(context, UIColor(red: 57/255, green: 66/255, blue: 106/255, alpha: 255/255).CGColor)
        //CGContextSetLineDash(context, 0, [7.5], 1)
        //CGContextSetLineCap(context, kCGLineCapRound)
        
        CGContextMoveToPoint(context, 0, 0)
        CGContextAddLineToPoint(context, 0, 45)
        
        CGContextStrokePath(context)
        
    }
    
}
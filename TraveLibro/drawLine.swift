//
//  drawLine.swift
//  TraveLibro
//
//  Created by Chintan Shah on 02/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class drawLine: UIView {

    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(10.0)
        context!.setStrokeColor(lightOrangeColor.cgColor)
        context!.setLineDash(phase: 0, lengths: [7.5, 2])
        context!.setLineCap(CGLineCap(rawValue: 500)!)
        
        context!.move(to: CGPoint(x: 0, y: 0))
        context!.addLine(to: CGPoint(x: 0, y: 200))
        
        context!.strokePath()
    }

}


class drawFooterLine: UIView {
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(10.0)
        context?.setStrokeColor(UIColor(red: 57/255, green: 66/255, blue: 106/255, alpha: 255/255).cgColor)
        //CGContextSetLineCap(context, kCGLineCapRound)
        
        context?.move(to: CGPoint(x: 0, y: 20))
        context?.addLine(to: CGPoint(x: 0, y: 45))
        
        context?.strokePath()
        
    }
    
}

class drawSeperatorLine: UIView {
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(10.0)
        context?.setStrokeColor(UIColor.white.cgColor)
        //CGContextSetLineDash(context, 0, [7.5], 1)
        //CGContextSetLineCap(context, kCGLineCapRound)
        
        context?.move(to: CGPoint(x: 0, y: 20))
        context?.addLine(to: CGPoint(x: 5000, y: 0))
        
        context?.strokePath()
        
    }
    
}

class drawSeperatorLineTwo: UIView {
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(10.0)
        context?.setStrokeColor(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1).cgColor)
        //CGContextSetLineDash(context, 0, [7.5], 1)
        //CGContextSetLineCap(context, kCGLineCapRound)
        
        context?.move(to: CGPoint(x: 0, y: 0))
        context?.addLine(to: CGPoint(x: 5000, y: 20))
        
        context?.strokePath()
        
    }
    
}

class drawSearchLine: UIView {
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(5.0)
        context?.setStrokeColor(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1).cgColor)
        
        context?.move(to: CGPoint(x: 0, y: 0))
        context?.addLine(to: CGPoint(x: 5000, y: 20))
        
        context?.strokePath()
        
    }
    
}


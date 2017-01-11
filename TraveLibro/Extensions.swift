//
//  Extensions.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 01/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func index(of string: String, options: String.CompareOptions = .literal) -> String.Index? {
        return range(of: string, options: options, range: nil, locale: nil)?.lowerBound
    }
    
    func indexes(of string: String, options: String.CompareOptions = .literal) -> [String.Index] {
        var result: [String.Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex, locale: nil) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    
    func ranges(of string: String, options: String.CompareOptions = .literal) -> [Range<String.Index>] {
        var result: [Range<String.Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex, locale: nil) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
}

extension UIImageView {
    
    func imageFrame() -> CGRect {
        
        let imageViewSize = self.frame.size
        guard let imageSize = self.image?.size else {return CGRect.zero}
        let imageRatio = imageSize.width / imageSize.height
        let imageViewRatio = imageViewSize.width / imageViewSize.height
        
        if imageRatio < imageViewRatio {
        
            let scaleFactor = imageViewSize.height / imageSize.height
            let width = imageSize.width * scaleFactor
            let topLeftX = (imageViewSize.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageViewSize.height)
        }
        else {
            
            let scalFactor = imageViewSize.width / imageSize.width
            let height = imageSize.height * scalFactor
            let topLeftY = (imageViewSize.height - height) * 0.5
            return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
        }
    }
}

extension UIView {
    func underlined(){
        let borderBottom = CALayer()
        let borderLeft = CALayer()
        let borderRight = CALayer()
        let width = CGFloat(1.0)
        let some = CGFloat(20.0)
        
        borderBottom.borderColor = mainBlueColor.cgColor
        borderLeft.borderColor = mainBlueColor.cgColor
        borderRight.borderColor = mainBlueColor.cgColor
        
        borderBottom.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        borderLeft.frame = CGRect(x: 0, y: some, width: width, height: self.frame.size.height - some)
        borderRight.frame = CGRect(x: self.frame.size.width - width , y: some, width: width , height: self.frame.size.height - some)
        
        
        borderBottom.borderWidth = width
        borderLeft.borderWidth = width
        borderRight.borderWidth = width
        
        self.layer.addSublayer(borderBottom)
        self.layer.addSublayer(borderLeft)
        self.layer.addSublayer(borderRight)
        self.layer.masksToBounds = true
        
    }
    
    
}


extension UITextField {
    func cursorPlace(_ textField: UITextField, position: Int){
         textField.position(from: textField.beginningOfDocument, offset: position)
        
    }

}



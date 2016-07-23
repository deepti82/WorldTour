//
//  MoreAboutMe.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class MoreAboutMe: UIView {

    @IBOutlet weak var mainTextView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let heavyFont = [NSFontAttributeName:  "Avenir-Heavy"]
        let normalFont = [NSFontAttributeName: "Avenir-Roman"]
        
        let exploreIcon = NSTextAttachment()
        let attributedString = NSMutableAttributedString(string: "Yash loves to travel and explore the ", attributes: normalFont)
        exploreIcon.bounds = CGRect(origin: CGPointMake(5, -5) , size: CGSize(width: 25, height: 25))
        exploreIcon.image = UIImage(named: "palm_trees_icon")
        let attributedStringwithImage = NSAttributedString(attachment: exploreIcon)
        attributedString.appendAttributedString(attributedStringwithImage)
        attributedString.addAttribute(NSFontAttributeName, value: avenirFont!, range: NSRange(location:0,length: attributedString.length))
        let string = NSMutableAttributedString(string: "Island & Beach.", attributes: heavyFont)
        attributedString.appendAttributedString(string)
        let myText = attributedString
        
        let exploreIconTwo = NSTextAttachment()
        let attributedStringTwo = NSMutableAttributedString(string: "He usually goes ", attributes: normalFont)
        exploreIconTwo.bounds = CGRect(origin: CGPointMake(5, -5) , size: CGSize(width: 25, height: 25))
        exploreIconTwo.image = UIImage(named: "road")
        let attributedStringwithImageTwo = NSAttributedString(attachment: exploreIconTwo)
        attributedStringTwo.appendAttributedString(attributedStringwithImageTwo)
        attributedStringTwo.addAttribute(NSFontAttributeName, value: avenirFont!, range: NSRange(location:0,length: attributedStringTwo.length))
        let stringTwo = NSMutableAttributedString(string: " Where the road takes him, ", attributes: heavyFont)
        attributedStringTwo.appendAttributedString(stringTwo)
        myText.appendAttributedString(attributedStringTwo)
        
        let exploreIconThree = NSTextAttachment()
        let attributedStringThree = NSMutableAttributedString(string: " tagging his ", attributes: normalFont)
        exploreIconThree.bounds = CGRect(origin: CGPointMake(5, -5) , size: CGSize(width: 25, height: 25))
        exploreIconThree.image = UIImage(named: "family")
        let attributedStringwithImageThree = NSAttributedString(attachment: exploreIconThree)
        attributedStringThree.appendAttributedString(attributedStringwithImageThree)
        attributedStringThree.addAttribute(NSFontAttributeName, value: avenirFont!, range: NSRange(location:0,length: attributedStringThree.length))
        let stringThree = NSMutableAttributedString(string: " Family ", attributes: heavyFont)
        attributedStringThree.appendAttributedString(stringThree)
        myText.appendAttributedString(attributedStringThree)
        
        let exploreIconFour = NSTextAttachment()
        let attributedStringFour = NSMutableAttributedString(string: " along. His idea of a holiday is to go out of his way to see his favourite artist perform at a ", attributes: normalFont)
        exploreIconFour.bounds = CGRect(origin: CGPointMake(5, -5), size: CGSize(width: 25, height: 25))
        exploreIconFour.image = UIImage(named: "festival")
        let attributedStringwithImageFour = NSAttributedString(attachment: exploreIconFour)
        attributedStringFour.appendAttributedString(attributedStringwithImageFour)
        attributedStringFour.addAttribute(NSFontAttributeName, value: avenirFont!, range: NSRange(location:0,length: attributedStringFour.length))
        let stringFour = NSMutableAttributedString(string: " Music Festival.", attributes: heavyFont)
        attributedStringFour.appendAttributedString(stringFour)
        myText.appendAttributedString(attributedStringFour)
        
        myText.addAttribute(NSForegroundColorAttributeName, value: mainBlueColor, range: NSRange(location:0, length: myText.length))
        myText.addAttribute(NSFontAttributeName, value: avenirFont!, range: NSRange(location:0,length: myText.length))
        
        mainTextView.attributedText = myText
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "MoreAboutMe", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        
    }

}

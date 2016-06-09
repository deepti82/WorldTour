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
        
        let exploreIcon = NSTextAttachment()
        let attributedString = NSMutableAttributedString(string: "Yash loves to travel and explore the ")
        exploreIcon.bounds = CGRect(origin: CGPointMake(0, -5) , size: CGSize(width: 20, height: 20))
        exploreIcon.image = UIImage(named: "palm_trees_icon")
        let attributedStringwithImage = NSAttributedString(attachment: exploreIcon)
        attributedString.appendAttributedString(attributedStringwithImage)
        let myText = attributedString
        
        let exploreIconTwo = NSTextAttachment()
        let attributedStringTwo = NSMutableAttributedString(string: " Island & Beach. He usually goes ")
        exploreIconTwo.bounds = CGRect(origin: CGPointMake(0, -5) , size: CGSize(width: 20, height: 20))
        exploreIconTwo.image = UIImage(named: "road")
        let attributedStringwithImageTwo = NSAttributedString(attachment: exploreIconTwo)
        attributedStringTwo.appendAttributedString(attributedStringwithImageTwo)
        myText.appendAttributedString(attributedStringTwo)
        
        let exploreIconThree = NSTextAttachment()
        let attributedStringThree = NSMutableAttributedString(string: " Where the road takes him, tagging his ")
        exploreIconThree.bounds = CGRect(origin: CGPointMake(0, -5) , size: CGSize(width: 20, height: 20))
        exploreIconThree.image = UIImage(named: "family")
        let attributedStringwithImageThree = NSAttributedString(attachment: exploreIconThree)
        attributedStringThree.appendAttributedString(attributedStringwithImageThree)
        myText.appendAttributedString(attributedStringThree)
        
        let exploreIconFour = NSTextAttachment()
        let attributedStringFour = NSMutableAttributedString(string: " Family along. His idea of a holiday is to go out of his way to see his favourite artist perform at a ")
        exploreIconFour.bounds = CGRect(origin: CGPointMake(0, -5), size: CGSize(width: 20, height: 20))
        exploreIconFour.image = UIImage(named: "festival")
        let attributedStringwithImageFour = NSAttributedString(attachment: exploreIconFour)
        attributedStringFour.appendAttributedString(attributedStringwithImageFour)
        myText.appendAttributedString(attributedStringFour)
        
        let attributedStringFive = NSMutableAttributedString(string: " Music Festival")
        myText.appendAttributedString(attributedStringFive)
        
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

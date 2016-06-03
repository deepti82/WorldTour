//
//  TutorialCards.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class TutorialCards: UIView {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardDescription: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let CBButtons = ["palm_trees_icon", "city_icon", "safari_icon", "mountains_icon", "cruise_icon", "countryside_icon"]
        let CBLabels = ["Island & Beach", "City", "Safari", "Mountains", "Cruise", "Countryside"]
        
        let checkboxGroupTwo = CardCheckBoxes(frame: CGRect(x: 0, y: 125, width: self.frame.width, height: 120))
        checkboxGroupTwo.buttonLeft.setImage(UIImage(named: CBButtons[0]), forState: .Normal)
        checkboxGroupTwo.buttonRight.setImage(UIImage(named: CBButtons[1]), forState: .Normal)
        checkboxGroupTwo.labelLeft.text = CBLabels[0]
        checkboxGroupTwo.labelRight.text = CBLabels[1]
        self.addSubview(checkboxGroupTwo)
        
        let checkboxGroupThree = CardCheckBoxes(frame: CGRect(x: 0, y: 250, width: self.frame.width, height: 120))
        checkboxGroupThree.buttonLeft.setImage(UIImage(named: CBButtons[2]), forState: .Normal)
        checkboxGroupThree.buttonRight.setImage(UIImage(named: CBButtons[3]), forState: .Normal)
        checkboxGroupThree.labelLeft.text = CBLabels[2]
        checkboxGroupThree.labelRight.text = CBLabels[3]
        self.addSubview(checkboxGroupThree)
        
        let checkboxGroupFour = CardCheckBoxes(frame: CGRect(x: 0, y: 375, width: self.frame.width, height: 120))
        checkboxGroupFour.buttonLeft.setImage(UIImage(named: CBButtons[4]), forState: .Normal)
        checkboxGroupFour.buttonRight.setImage(UIImage(named: CBButtons[5]), forState: .Normal)
        checkboxGroupFour.labelLeft.text = CBLabels[4]
        checkboxGroupFour.labelRight.text = CBLabels[5]
        self.addSubview(checkboxGroupFour)
        
//        let checkboxGroupFive = CardCheckBoxes(frame: CGRect(x: 0, y: 555, width: self.frame.width, height: 120))
//        checkboxGroupFive.buttonLeft.setImage(UIImage(named: CBButtons[6]), forState: .Normal)
//        checkboxGroupFive.buttonRight.setImage(UIImage(named: CBButtons[7]), forState: .Normal)
//        checkboxGroupFive.labelLeft.text = CBLabels[6]
//        checkboxGroupFive.labelRight.text = CBLabels[7]
//        self.addSubview(checkboxGroupFive)
        
//        let checkboxGroupSix = CardCheckBoxes(frame: CGRect(x: 0, y: 680, width: self.frame.width, height: 120))
//        self.addSubview(checkboxGroupSix)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "TutorialCards", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}

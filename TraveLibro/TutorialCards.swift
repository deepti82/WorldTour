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
    @IBOutlet weak var checkBoxView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let CBButtons = [["palm_trees_icon", "city_icon", "safari_icon", "mountains_icon", "cruise_icon", "countryside_icon"], ["by_the_map", "by_the_road", "by_both"], ["family", "friends", "partner", "solo", "business", "blogger", "group", "photographer"], ["luxury", "backpacking", "green_travelling", "pocket_friendly", "romance", "sports_adventure", "history", "spirituality", "shopping", "food_wine", "music_festivals"]]
        let CBLabels = [["Island & Beach", "City", "Safari", "Mountains", "Cruise", "Countryside"], ["By the map", "By the road", "A little bit of both"], ["Family", "Friends", "Partner/Spouse", "Solo", "Business", "Blogger", "Group Tour", "Photographer"], ["Luxury", "Backpacking", "Green Travelling", "Pocket Friendly", "Romance", "Sports & Adventure", "History & Culture", "Spirituality & Wellness", "Shopping", "Food & Wine", "Festivals"]]
        print("cardTitle: \(cardTitle.text)")
        
        print("checkbox: \(checkBoxNumber)")
        
        switch checkBoxNumber {
        case 6:
            let checkboxGroupOne = CardCheckBoxes(frame: CGRect(x: 0, y: 0, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupOne.buttonLeft.setImage(UIImage(named: CBButtons[0][1]), forState: .Normal)
            checkboxGroupOne.buttonRight.setImage(UIImage(named: CBButtons[0][0]), forState: .Normal)
            checkboxGroupOne.labelLeft.text = CBLabels[0][1]
            checkboxGroupOne.labelRight.text = CBLabels[0][0]
            checkBoxView.addSubview(checkboxGroupOne)
            
            let checkboxGroupTwo = CardCheckBoxes(frame: CGRect(x: 0, y: 125, width: checkBoxView.frame.width  - 125, height: 120))
            checkboxGroupTwo.buttonLeft.setImage(UIImage(named: CBButtons[0][3]), forState: .Normal)
            checkboxGroupTwo.buttonRight.setImage(UIImage(named: CBButtons[0][2]), forState: .Normal)
            checkboxGroupTwo.labelLeft.text = CBLabels[0][3]
            checkboxGroupTwo.labelRight.text = CBLabels[0][2]
            checkBoxView.addSubview(checkboxGroupTwo)
            
            let checkboxGroupThree = CardCheckBoxes(frame: CGRect(x: 0, y: 250, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupThree.buttonLeft.setImage(UIImage(named: CBButtons[0][5]), forState: .Normal)
            checkboxGroupThree.buttonRight.setImage(UIImage(named: CBButtons[0][4]), forState: .Normal)
            checkboxGroupThree.labelLeft.text = CBLabels[0][5]
            checkboxGroupThree.labelRight.text = CBLabels[0][4]
            checkBoxView.addSubview(checkboxGroupThree)
            
            break
            
        case 4:
            let checkboxGroupOne = CardCheckBoxes(frame: CGRect(x: 0, y: 0, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupOne.buttonLeft.setImage(UIImage(named: CBButtons[1][1]), forState: .Normal)
            checkboxGroupOne.buttonRight.setImage(UIImage(named: CBButtons[1][0]), forState: .Normal)
            checkboxGroupOne.labelLeft.text = CBLabels[1][1]
            checkboxGroupOne.labelRight.text = CBLabels[1][0]
            checkBoxView.addSubview(checkboxGroupOne)
            
            let checkboxGroupTwo = CardCheckBoxes(frame: CGRect(x: 0, y: 125, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupTwo.buttonLeft.removeFromSuperview()
            checkboxGroupTwo.buttonRight.setImage(UIImage(named: CBButtons[1][2]), forState: .Normal)
            checkboxGroupTwo.labelLeft.removeFromSuperview()
            checkboxGroupTwo.labelRight.text = CBLabels[1][2]
            checkBoxView.addSubview(checkboxGroupTwo)
            
            break
            
        case 8:
            let checkboxGroupOne = CardCheckBoxes(frame: CGRect(x: 0, y: 0, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupOne.buttonLeft.setImage(UIImage(named: CBButtons[2][1]), forState: .Normal)
            checkboxGroupOne.buttonRight.setImage(UIImage(named: CBButtons[2][0]), forState: .Normal)
            checkboxGroupOne.labelLeft.text = CBLabels[2][1]
            checkboxGroupOne.labelRight.text = CBLabels[2][0]
            checkBoxView.addSubview(checkboxGroupOne)
            
            let checkboxGroupTwo = CardCheckBoxes(frame: CGRect(x: 0, y: 125, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupTwo.buttonLeft.setImage(UIImage(named: CBButtons[2][3]), forState: .Normal)
            checkboxGroupTwo.buttonRight.setImage(UIImage(named: CBButtons[2][2]), forState: .Normal)
            checkboxGroupTwo.labelLeft.text = CBLabels[2][3]
            checkboxGroupTwo.labelRight.text = CBLabels[2][2]
            checkBoxView.addSubview(checkboxGroupTwo)
            
            let checkboxGroupThree = CardCheckBoxes(frame: CGRect(x: 0, y: 250, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupThree.buttonLeft.setImage(UIImage(named: CBButtons[2][5]), forState: .Normal)
            checkboxGroupThree.buttonRight.setImage(UIImage(named: CBButtons[2][4]), forState: .Normal)
            checkboxGroupThree.labelLeft.text = CBLabels[2][5]
            checkboxGroupThree.labelRight.text = CBLabels[2][4]
            checkBoxView.addSubview(checkboxGroupThree)
            
            let checkboxGroupFour = CardCheckBoxes(frame: CGRect(x: 0, y: 375, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupFour.buttonLeft.setImage(UIImage(named: CBButtons[2][7]), forState: .Normal)
            checkboxGroupFour.buttonRight.setImage(UIImage(named: CBButtons[2][6]), forState: .Normal)
            checkboxGroupFour.labelLeft.text = CBLabels[2][7]
            checkboxGroupFour.labelRight.text = CBLabels[2][6]
            checkBoxView.addSubview(checkboxGroupFour)
            
            break
            
        case 12:
            let checkboxGroupOne = CardCheckBoxes(frame: CGRect(x: 0, y: 0, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupOne.buttonLeft.setImage(UIImage(named: CBButtons[3][1]), forState: .Normal)
            checkboxGroupOne.buttonRight.setImage(UIImage(named: CBButtons[3][0]), forState: .Normal)
            checkboxGroupOne.labelLeft.text = CBLabels[3][1]
            checkboxGroupOne.labelRight.text = CBLabels[3][0]
            checkBoxView.addSubview(checkboxGroupOne)
            
            let checkboxGroupTwo = CardCheckBoxes(frame: CGRect(x: 0, y: 125, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupTwo.buttonLeft.setImage(UIImage(named: CBButtons[3][3]), forState: .Normal)
            checkboxGroupTwo.buttonRight.setImage(UIImage(named: CBButtons[3][2]), forState: .Normal)
            checkboxGroupTwo.labelLeft.text = CBLabels[3][3]
            checkboxGroupTwo.labelRight.text = CBLabels[3][2]
            checkBoxView.addSubview(checkboxGroupTwo)
            
            let checkboxGroupThree = CardCheckBoxes(frame: CGRect(x: 0, y: 250, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupThree.buttonLeft.setImage(UIImage(named: CBButtons[3][5]), forState: .Normal)
            checkboxGroupThree.buttonRight.setImage(UIImage(named: CBButtons[3][4]), forState: .Normal)
            checkboxGroupThree.labelLeft.text = CBLabels[3][5]
            checkboxGroupThree.labelRight.text = CBLabels[3][4]
            checkBoxView.addSubview(checkboxGroupThree)
            
            let checkboxGroupFour = CardCheckBoxes(frame: CGRect(x: 0, y: 375, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupFour.buttonLeft.setImage(UIImage(named: CBButtons[3][7]), forState: .Normal)
            checkboxGroupFour.buttonRight.setImage(UIImage(named: CBButtons[3][6]), forState: .Normal)
            checkboxGroupFour.labelLeft.text = CBLabels[3][7]
            checkboxGroupFour.labelRight.text = CBLabels[3][6]
            checkBoxView.addSubview(checkboxGroupFour)
            
            let checkboxGroupFive = CardCheckBoxes(frame: CGRect(x: 0, y: 500, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupFive.buttonLeft.setImage(UIImage(named: CBButtons[3][9]), forState: .Normal)
            checkboxGroupFive.buttonRight.setImage(UIImage(named: CBButtons[3][8]), forState: .Normal)
            checkboxGroupFive.labelLeft.text = CBLabels[3][9]
            checkboxGroupFive.labelRight.text = CBLabels[3][8]
            checkBoxView.addSubview(checkboxGroupFive)
            
            let checkboxGroupSix = CardCheckBoxes(frame: CGRect(x: 0, y: 625, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupSix.buttonLeft.removeFromSuperview()
            checkboxGroupSix.buttonRight.setImage(UIImage(named: CBButtons[3][10]), forState: .Normal)
            checkboxGroupSix.labelLeft.removeFromSuperview()
            checkboxGroupSix.labelRight.text = CBLabels[3][10]
            checkBoxView.addSubview(checkboxGroupSix)
            
            break
        
        default:
            break
            
        }
        
        
        
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

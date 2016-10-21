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
        
        var options: [String] = []
        
        if currentUser["travelConfig"]["usuallyGo"] != nil {
            
            for item in currentUser["travelConfig"]["usuallyGo"].array! {
                
                options.append(item.string!)
            }
            
        }
        
        if currentUser["travelConfig"]["kindOfHoliday"] != nil {
            
            for item in currentUser["travelConfig"]["kindOfHoliday"].array! {
                
                options.append(item.string!)
            }
            
        }
        
        if currentUser["travelConfig"]["holidayType"] != nil {
            
            for item in currentUser["travelConfig"]["holidayType"].array! {
                
                options.append(item.string!)
            }
        }
        
        if currentUser["travelConfig"]["usuallyGo"] != nil {
            
            for item in currentUser["travelConfig"]["usuallyGo"].array! {
                
                options.append(item.string!)
            }
            
        }
        
        //        if options.contains(buttonRight.titleLabel!.text!) {
        //
        //            checkBoxTap(buttonRight)
        //        }
        //
        //        if options.contains(buttonLeft.titleLabel!.text!) {
        //
        //            checkBoxTap(buttonLeft)
        //        }
        
        switch checkBoxNumber {
        case 6:
            let checkboxGroupOne = CardCheckBoxes(frame: CGRect(x: 20, y: 0, width: checkBoxView.frame.width - 125, height: 120))
//            checkboxGroupOne.center.x = 366/2
            checkboxGroupOne.buttonLeft.setImage(UIImage(named: CBButtons[0][1]), for: UIControlState())
            checkboxGroupOne.buttonLeft.setTitle(CBButtons[0][1], for: UIControlState())
            checkboxGroupOne.buttonRight.setImage(UIImage(named: CBButtons[0][0]), for: UIControlState())
            checkboxGroupOne.buttonRight.setTitle(CBButtons[0][0], for: UIControlState())
            checkboxGroupOne.labelLeft.text = CBLabels[0][1]
            checkboxGroupOne.labelRight.text = CBLabels[0][0]
//            if options.contains(checkboxGroupOne.buttonRight.titleLabel!.text!) {
//    
//                checkboxGroupOne.checkBoxTap(checkboxGroupOne.buttonRight)
//            }
//    
//            if options.contains(checkboxGroupOne.buttonLeft.titleLabel!.text!) {
//    
//                checkboxGroupOne.checkBoxTap(checkboxGroupOne.buttonLeft)
//            }
            checkBoxView.addSubview(checkboxGroupOne)
            
            let checkboxGroupTwo = CardCheckBoxes(frame: CGRect(x: 20, y: 115, width: checkBoxView.frame.width  - 125, height: 120))
            checkboxGroupTwo.buttonLeft.setImage(UIImage(named: CBButtons[0][3]), for: UIControlState())
            checkboxGroupTwo.buttonLeft.setTitle(CBButtons[0][3], for: UIControlState())
            checkboxGroupTwo.buttonRight.setImage(UIImage(named: CBButtons[0][2]), for: UIControlState())
            checkboxGroupTwo.buttonRight.setTitle(CBButtons[0][2], for: UIControlState())
            checkboxGroupTwo.labelLeft.text = CBLabels[0][3]
            checkboxGroupTwo.labelRight.text = CBLabels[0][2]
//            if options.contains(checkboxGroupTwo.buttonRight.titleLabel!.text!) {
//                
//                checkboxGroupTwo.checkBoxTap(checkboxGroupTwo.buttonRight)
//            }
//            
//            if options.contains(checkboxGroupTwo.buttonLeft.titleLabel!.text!) {
//                
//                checkboxGroupTwo.checkBoxTap(checkboxGroupTwo.buttonLeft)
//            }
            checkBoxView.addSubview(checkboxGroupTwo)
            
            let checkboxGroupThree = CardCheckBoxes(frame: CGRect(x: 20, y: 235, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupThree.buttonLeft.setImage(UIImage(named: CBButtons[0][5]), for: UIControlState())
            checkboxGroupThree.buttonLeft.setTitle(CBButtons[0][5], for: UIControlState())
            checkboxGroupThree.buttonRight.setImage(UIImage(named: CBButtons[0][4]), for: UIControlState())
            checkboxGroupThree.buttonRight.setTitle(CBButtons[0][4], for: UIControlState())
            checkboxGroupThree.labelLeft.text = CBLabels[0][5]
            checkboxGroupThree.labelRight.text = CBLabels[0][4]
//            if options.contains(checkboxGroupThree.buttonRight.titleLabel!.text!) {
//                
//                checkboxGroupThree.checkBoxTap(checkboxGroupThree.buttonRight)
//            }
//            
//            if options.contains(checkboxGroupThree.buttonLeft.titleLabel!.text!) {
//                
//                checkboxGroupThree.checkBoxTap(checkboxGroupThree.buttonLeft)
//            }
            checkBoxView.addSubview(checkboxGroupThree)
            
            break
            
        case 3:
            let checkboxGroupOne = CardCheckBoxes(frame: CGRect(x: 20, y: 0, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupOne.buttonLeft.tag = 1
            checkboxGroupOne.buttonRight.tag = 1
            checkboxGroupOne.buttonLeft.setImage(UIImage(named: CBButtons[1][1]), for: UIControlState())
            checkboxGroupOne.buttonLeft.setTitle(CBButtons[0][1], for: UIControlState())
            checkboxGroupOne.buttonRight.setImage(UIImage(named: CBButtons[1][0]), for: UIControlState())
            checkboxGroupOne.buttonRight.setTitle(CBButtons[1][0], for: UIControlState())
            checkboxGroupOne.labelLeft.text = CBLabels[1][1]
            checkboxGroupOne.labelRight.text = CBLabels[1][0]
//            if options.contains(checkboxGroupOne.buttonRight.titleLabel!.text!) {
//                
//                checkboxGroupOne.checkBoxTap(checkboxGroupOne.buttonRight)
//            }
//            
//            if options.contains(checkboxGroupOne.buttonLeft.titleLabel!.text!) {
//                
//                checkboxGroupOne.checkBoxTap(checkboxGroupOne.buttonLeft)
//            }
            checkBoxView.addSubview(checkboxGroupOne)
            
            let checkboxGroupTwo = CardCheckBoxes(frame: CGRect(x: 0, y: 125, width: checkBoxView.frame.width - 250, height: 120))
            checkboxGroupTwo.buttonRight.tag = 1
            checkboxGroupTwo.center.x = (checkBoxView.frame.width + 25)/2
            checkboxGroupTwo.buttonLeft.removeFromSuperview()
            checkboxGroupTwo.buttonRight.setImage(UIImage(named: CBButtons[1][2]), for: UIControlState())
            checkboxGroupTwo.buttonRight.setTitle(CBButtons[1][2], for: UIControlState())
            checkboxGroupTwo.labelLeft.removeFromSuperview()
            checkboxGroupTwo.labelRight.text = CBLabels[1][2]
//            if options.contains(checkboxGroupTwo.buttonRight.titleLabel!.text!) {
//                
//                checkboxGroupTwo.checkBoxTap(checkboxGroupTwo.buttonRight)
//            }
//            
//            if options.contains(checkboxGroupTwo.buttonLeft.titleLabel!.text!) {
//                
//                checkboxGroupTwo.checkBoxTap(checkboxGroupTwo.buttonLeft)
//            }
            checkBoxView.addSubview(checkboxGroupTwo)
            
            break
            
        case 8:
            let checkboxGroupOne = CardCheckBoxes(frame: CGRect(x: 20, y: 0, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupOne.buttonLeft.setImage(UIImage(named: CBButtons[2][1]), for: UIControlState())
            checkboxGroupOne.buttonLeft.setTitle(CBButtons[2][1], for: UIControlState())
            checkboxGroupOne.buttonRight.setImage(UIImage(named: CBButtons[2][0]), for: UIControlState())
            checkboxGroupOne.buttonRight.setTitle(CBButtons[2][0], for: UIControlState())
            checkboxGroupOne.labelLeft.text = CBLabels[2][1]
            checkboxGroupOne.labelRight.text = CBLabels[2][0]
//            if options.contains(checkboxGroupOne.buttonRight.titleLabel!.text!) {
//                
//                checkboxGroupOne.checkBoxTap(checkboxGroupOne.buttonRight)
//            }
//            
//            if options.contains(checkboxGroupOne.buttonLeft.titleLabel!.text!) {
//                
//                checkboxGroupOne.checkBoxTap(checkboxGroupOne.buttonLeft)
//            }
            checkBoxView.addSubview(checkboxGroupOne)
            
            let checkboxGroupTwo = CardCheckBoxes(frame: CGRect(x: 20, y: 125, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupTwo.buttonLeft.setImage(UIImage(named: CBButtons[2][3]), for: UIControlState())
            checkboxGroupTwo.buttonLeft.setTitle(CBButtons[2][3], for: UIControlState())
            checkboxGroupTwo.buttonRight.setImage(UIImage(named: CBButtons[2][2]), for: UIControlState())
            checkboxGroupTwo.buttonRight.setTitle(CBButtons[2][2], for: UIControlState())
            checkboxGroupTwo.labelLeft.text = CBLabels[2][3]
            checkboxGroupTwo.labelRight.text = CBLabels[2][2]
//            if options.contains(checkboxGroupTwo.buttonRight.titleLabel!.text!) {
//                
//                checkboxGroupTwo.checkBoxTap(checkboxGroupTwo.buttonRight)
//            }
//            
//            if options.contains(checkboxGroupTwo.buttonLeft.titleLabel!.text!) {
//                
//                checkboxGroupTwo.checkBoxTap(checkboxGroupTwo.buttonLeft)
//            }
            checkBoxView.addSubview(checkboxGroupTwo)
            
            let checkboxGroupThree = CardCheckBoxes(frame: CGRect(x: 20, y: 250, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupThree.buttonLeft.setImage(UIImage(named: CBButtons[2][5]), for: UIControlState())
            checkboxGroupThree.buttonLeft.setTitle(CBButtons[2][5], for: UIControlState())
            checkboxGroupThree.buttonRight.setImage(UIImage(named: CBButtons[2][4]), for: UIControlState())
            checkboxGroupThree.buttonRight.setTitle(CBButtons[2][4], for: UIControlState())
            checkboxGroupThree.labelLeft.text = CBLabels[2][5]
            checkboxGroupThree.labelRight.text = CBLabels[2][4]
//            if options.contains(checkboxGroupThree.buttonRight.titleLabel!.text!) {
//                
//                checkboxGroupThree.checkBoxTap(checkboxGroupThree.buttonRight)
//            }
//            
//            if options.contains(checkboxGroupThree.buttonLeft.titleLabel!.text!) {
//                
//                checkboxGroupThree.checkBoxTap(checkboxGroupThree.buttonLeft)
//            }
            checkBoxView.addSubview(checkboxGroupThree)
            
            let checkboxGroupFour = CardCheckBoxes(frame: CGRect(x: 20, y: 375, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupFour.buttonLeft.setImage(UIImage(named: CBButtons[2][7]), for: UIControlState())
            checkboxGroupFour.buttonLeft.setTitle(CBButtons[2][7], for: UIControlState())
            checkboxGroupFour.buttonRight.setImage(UIImage(named: CBButtons[2][6]), for: UIControlState())
            checkboxGroupFour.buttonRight.setTitle(CBButtons[2][6], for: UIControlState())
            checkboxGroupFour.labelLeft.text = CBLabels[2][7]
            checkboxGroupFour.labelRight.text = CBLabels[2][6]
//            if options.contains(checkboxGroupFour.buttonRight.titleLabel!.text!) {
//                
//                checkboxGroupFour.checkBoxTap(checkboxGroupFour.buttonRight)
//            }
//            
//            if options.contains(checkboxGroupFour.buttonLeft.titleLabel!.text!) {
//                
//                checkboxGroupFour.checkBoxTap(checkboxGroupFour.buttonLeft)
//            }
            checkBoxView.addSubview(checkboxGroupFour)
            
            break
            
        case 11:
//            rightButton.hidden = false
            let checkboxGroupOne = CardCheckBoxes(frame: CGRect(x: 20, y: 0, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupOne.buttonLeft.setImage(UIImage(named: CBButtons[3][1]), for: UIControlState())
            checkboxGroupOne.buttonLeft.setTitle(CBButtons[3][1], for: UIControlState())
            checkboxGroupOne.buttonRight.setImage(UIImage(named: CBButtons[3][0]), for: UIControlState())
            checkboxGroupOne.buttonRight.setTitle(CBButtons[3][0], for: UIControlState())
            checkboxGroupOne.labelLeft.text = CBLabels[3][1]
            checkboxGroupOne.labelRight.text = CBLabels[3][0]
//            if options.contains(checkboxGroupOne.buttonRight.titleLabel!.text!) {
//                
//                checkboxGroupOne.checkBoxTap(checkboxGroupOne.buttonRight)
//            }
//            
//            if options.contains(checkboxGroupOne.buttonLeft.titleLabel!.text!) {
//                
//                checkboxGroupOne.checkBoxTap(checkboxGroupOne.buttonLeft)
//            }
            checkBoxView.addSubview(checkboxGroupOne)
            
            let checkboxGroupTwo = CardCheckBoxes(frame: CGRect(x: 20, y: 125, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupTwo.buttonLeft.setImage(UIImage(named: CBButtons[3][3]), for: UIControlState())
            checkboxGroupTwo.buttonLeft.setTitle(CBButtons[3][3], for: UIControlState())
            checkboxGroupTwo.buttonRight.setImage(UIImage(named: CBButtons[3][2]), for: UIControlState())
            checkboxGroupTwo.buttonRight.setTitle(CBButtons[3][2], for: UIControlState())
            checkboxGroupTwo.labelLeft.text = CBLabels[3][3]
            checkboxGroupTwo.labelRight.text = CBLabels[3][2]
//            if options.contains(checkboxGroupTwo.buttonRight.titleLabel!.text!) {
//                
//                checkboxGroupTwo.checkBoxTap(checkboxGroupTwo.buttonRight)
//            }
//            
//            if options.contains(checkboxGroupTwo.buttonLeft.titleLabel!.text!) {
//                
//                checkboxGroupTwo.checkBoxTap(checkboxGroupTwo.buttonLeft)
//            }
            checkBoxView.addSubview(checkboxGroupTwo)
            
            let checkboxGroupThree = CardCheckBoxes(frame: CGRect(x: 20, y: 250, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupThree.buttonLeft.setImage(UIImage(named: CBButtons[3][5]), for: UIControlState())
            checkboxGroupThree.buttonLeft.setTitle(CBButtons[3][5], for: UIControlState())
            checkboxGroupThree.buttonRight.setImage(UIImage(named: CBButtons[3][4]), for: UIControlState())
            checkboxGroupThree.buttonRight.setTitle(CBButtons[3][4], for: UIControlState())
            checkboxGroupThree.labelLeft.text = CBLabels[3][5]
            checkboxGroupThree.labelRight.text = CBLabels[3][4]
//            if options.contains(checkboxGroupThree.buttonRight.titleLabel!.text!) {
//                
//                checkboxGroupThree.checkBoxTap(checkboxGroupThree.buttonRight)
//            }
//            
//            if options.contains(checkboxGroupThree.buttonLeft.titleLabel!.text!) {
//                
//                checkboxGroupThree.checkBoxTap(checkboxGroupThree.buttonLeft)
//            }
            checkBoxView.addSubview(checkboxGroupThree)
            
            let checkboxGroupFour = CardCheckBoxes(frame: CGRect(x: 20, y: 375, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupFour.buttonLeft.setImage(UIImage(named: CBButtons[3][7]), for: UIControlState())
            checkboxGroupFour.buttonLeft.setTitle(CBButtons[3][7], for: UIControlState())
            checkboxGroupFour.buttonRight.setImage(UIImage(named: CBButtons[3][6]), for: UIControlState())
            checkboxGroupFour.buttonRight.setTitle(CBButtons[3][6], for: UIControlState())
            checkboxGroupFour.labelLeft.text = CBLabels[3][7]
            checkboxGroupFour.labelRight.text = CBLabels[3][6]
//            if options.contains(checkboxGroupFour.buttonRight.titleLabel!.text!) {
//                
//                checkboxGroupFour.checkBoxTap(checkboxGroupFour.buttonRight)
//            }
//            
//            if options.contains(checkboxGroupFour.buttonLeft.titleLabel!.text!) {
//                
//                checkboxGroupFour.checkBoxTap(checkboxGroupFour.buttonLeft)
//            }
            checkBoxView.addSubview(checkboxGroupFour)
            
            let checkboxGroupFive = CardCheckBoxes(frame: CGRect(x: 20, y: 500, width: checkBoxView.frame.width - 125, height: 120))
            checkboxGroupFive.buttonLeft.setImage(UIImage(named: CBButtons[3][9]), for: UIControlState())
            checkboxGroupFive.buttonLeft.setTitle(CBButtons[3][9], for: UIControlState())
            checkboxGroupFive.buttonRight.setImage(UIImage(named: CBButtons[3][8]), for: UIControlState())
            checkboxGroupFive.buttonRight.setTitle(CBButtons[3][8], for: UIControlState())
            checkboxGroupFive.labelLeft.text = CBLabels[3][9]
            checkboxGroupFive.labelRight.text = CBLabels[3][8]
//            if options.contains(checkboxGroupFive.buttonRight.titleLabel!.text!) {
//                
//                checkboxGroupFive.checkBoxTap(checkboxGroupFive.buttonRight)
//            }
//            
//            if options.contains(checkboxGroupFive.buttonLeft.titleLabel!.text!) {
//                
//                checkboxGroupFive.checkBoxTap(checkboxGroupFive.buttonLeft)
//            }
            checkBoxView.addSubview(checkboxGroupFive)
            
            let checkboxGroupSix = CardCheckBoxes(frame: CGRect(x: 0, y: 625, width: checkBoxView.frame.width - 250, height: 120))
            checkboxGroupSix.center.x = (checkBoxView.frame.width + 25)/2
            checkboxGroupSix.buttonLeft.removeFromSuperview()
            checkboxGroupSix.buttonRight.setImage(UIImage(named: CBButtons[3][10]), for: UIControlState())
            checkboxGroupSix.buttonRight.setTitle(CBButtons[3][10], for: UIControlState())
            checkboxGroupSix.labelLeft.removeFromSuperview()
            checkboxGroupSix.labelRight.text = CBLabels[3][10]
//            if options.contains(checkboxGroupSix.buttonRight.titleLabel!.text!) {
//                
//                checkboxGroupSix.checkBoxTap(checkboxGroupSix.buttonRight)
//            }
//            
//            if options.contains(checkboxGroupSix.buttonLeft.titleLabel!.text!) {
//                
//                checkboxGroupSix.checkBoxTap(checkboxGroupSix.buttonLeft)
//            }
            checkBoxView.addSubview(checkboxGroupSix)
            
            break
        
        default:
            break
            
        }
        
        let isUrl = verifyUrl(currentUser["profilePicture"].string!)
        
        if isUrl {
            
            let data = try? Data(contentsOf: URL(string: currentUser["profilePicture"].string!)!)
            
            if data != nil {
                
//                uploadView.addButton.setImage(, forState: .Normal)
                profileImage.image = UIImage(data:data!)
                makeTLProfilePicture(profileImage)
            }
        }
            
        else {
            
            var imageName = ""
            
            if currentUser["profilePicture"] != nil {
                
                imageName = currentUser["profilePicture"].string!
                
            }
            
            let getImageUrl = adminUrl + "upload/readFile?file=" + imageName + "&width=100"
            
            let data = try? Data(contentsOf: URL(string: getImageUrl)!)
            
            if data != nil {
                
//                uploadView.addButton.setImage(UIImage(data:data!), forState: .Normal)
                profileImage.image = UIImage(data:data!)
                makeTLProfilePicture(profileImage)
            }
            
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
    
//    func verifyUrl (urlString: String?) -> Bool {
//        
//        if let urlString = urlString {
//            
//            if let url = NSURL(string: urlString) {
//                
//                return UIApplication.sharedApplication().canOpenURL(url)
//            }
//        }
//        return false
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TutorialCards", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }

}

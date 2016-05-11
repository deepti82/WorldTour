//
//  ViewController.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 23/04/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class OTGAddNewViewController: UIViewController {
    
    let button: UIButton = UIButton()

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Adding background Image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        
        //Adding the scroll view
        self.scrollView.contentSize.height = 1000
        
        // adding status bar view
//        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
//        view.backgroundColor = mainBlueColor
//        self.view.addSubview(view)
//        
//        navigationBar.layer.zPosition = 10000
        
        // appling avenir font to label and button
        //UILabel.appearance().font = avenirFont
//        button.titleLabel!.font = avenirFont
//        
//        let journey = JourneyTitleView(frame: CGRectMake(0, 0, self.view.frame.size.width, 65))
//        journey.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 - 75)
//        journey.layer.cornerRadius = 5
//        self.view.addSubview(journey)
//        
//        let journeyImage = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, 180))
//        journeyImage.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 + 125 - 80)
//        journeyImage.image = UIImage(named: "london_image")
//        self.view.addSubview(journeyImage)
//        addShadow(journeyImage, offset: CGSize(width: 2, height: 2), opacity: 0.2, shadowRadius: 1, cornerRadius: 3)
//        
//        let bottomTabforTypeOfJourney = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
//        bottomTabforTypeOfJourney.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 3 * 2.2)
//        bottomTabforTypeOfJourney.backgroundColor = UIColor.whiteColor()
//        addShadow(bottomTabforTypeOfJourney, offset: CGSize(width: 2, height: 2), opacity: 0.2, shadowRadius: 1, cornerRadius: 2)
//        self.view.addSubview(bottomTabforTypeOfJourney)
//        
//        let TypeOfJourneyIcons = UIView(frame: CGRect(x: 0, y: 0, width: bottomTabforTypeOfJourney.frame.size.width/4, height: bottomTabforTypeOfJourney.frame.size.height))
//        TypeOfJourneyIcons.center = CGPointMake(bottomTabforTypeOfJourney.frame.size.width/8, bottomTabforTypeOfJourney.frame.size.height/2)
//        bottomTabforTypeOfJourney.addSubview(TypeOfJourneyIcons)
//        
//        let icon1 = UIImageView(frame: CGRect(x: 0, y: 0, width: TypeOfJourneyIcons.frame.size.width/3, height: TypeOfJourneyIcons.frame.size.height/2))
//        icon1.center = CGPointMake(TypeOfJourneyIcons.frame.size.width/6 + 10, TypeOfJourneyIcons.frame.size.height/2)
//        icon1.image = UIImage(named: "hearts_icon")
//        icon1.tintColor = mainOrangeColor
//        TypeOfJourneyIcons.addSubview(icon1)
//        
//        let icon2 = UIImageView(frame: CGRect(x: 0, y: 0, width: TypeOfJourneyIcons.frame.size.width/3, height: TypeOfJourneyIcons.frame.size.height/2))
//        icon2.center = CGPointMake(TypeOfJourneyIcons.frame.size.width/2 + 15, TypeOfJourneyIcons.frame.size.height/2)
//        icon2.image = UIImage(named: "hearts_icon")
//        icon2.tintColor = mainOrangeColor
//        TypeOfJourneyIcons.addSubview(icon2)
//        
//        let icon3 = UIImageView(frame: CGRect(x: 0, y: 0, width: TypeOfJourneyIcons.frame.size.width/3, height: TypeOfJourneyIcons.frame.size.height/2))
//        icon3.center = CGPointMake(TypeOfJourneyIcons.frame.size.width/6 * 5 + 20, TypeOfJourneyIcons.frame.size.height/2)
//        icon3.image = UIImage(named: "hearts_icon")
//        icon3.tintColor = mainOrangeColor
//        TypeOfJourneyIcons.addSubview(icon3)
//        
//        let addBuddiesButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 40, height: 50))
//        makeButtonGreyTranslucent(addBuddiesButton, textData: "Add Buddies")
//        addBuddiesButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height / 3 * 2.43)
//        self.view.addSubview(addBuddiesButton)
        
//        let addNewFriends = AddFriends(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height * 0.75))
//        addNewFriends.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/3 * 2)
//        self.view.addSubview(addNewFriends)
        
        
        
//        let addcircle = AddCircle(frame: CGRectMake(0, 0, 50, 50))
//        addcircle.center = CGPointMake(self.view.frame.size.width - 40, self.view.frame.size.height - 100)
//        self.view.addSubview(addcircle)
//        
//        let infocircle = InfoCircle(frame: CGRectMake(0, 0, 40, 40))
//        infocircle.center = CGPointMake(40, self.view.frame.size.height - 95)
//        self.view.addSubview(infocircle)
//        
//        let orangeButton = OrangeButton(frame: CGRectMake(0, 0, self.view.frame.size.width - 200, 50))
//        orangeButton.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
//        orangeButton.orangeButtonTitle.layer.cornerRadius = 3
//        let buttonIcon = UILabel(frame: CGRectMake(0, 0, 20, 20))
//        buttonIcon.font = FontAwesomeFont
//        buttonIcon.text = String(format: "%C", faicon["clock"]!)
//        let buttonIconText: String = String(format: "%C", faicon["clock"]!)
//        print(buttonIconText)
//        orangeButton.orangeButtonTitle.setTitle(buttonIconText + " Happy Journey", forState: UIControlState.Normal)
//        self.view.addSubview(orangeButton)
//
        let footer = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 45))
        footer.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height)
        
        let footerDown = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 45))
        footerDown.center = CGPointMake(footer.frame.size.width / 2, 0)
        footerDown.backgroundColor = mainBlueColor
        footer.addSubview(footerDown)
        
        let footerFeed = FooterView(frame: CGRectMake(0, 0, footer.frame.size.width/3, 30))
        footerFeed.footerText.text = "Feed"
        footerFeed.footerText.textColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        footerFeed.footerImage.image = UIImage(named: "feed_icon")
        footerFeed.footerImage.tintColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        footerFeed.center = CGPointMake(footer.frame.size.width/8, footer.frame.size.height/4+5)
        footerDown.addSubview(footerFeed)
        
        let footerNotification = FooterView(frame: CGRectMake(0, 0, footer.frame.size.width/3, 50))
        footerNotification.footerText.text = "Notifications"
        footerNotification.footerText.textColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        footerNotification.footerImage.image = UIImage(named: "notification_icon")
        footerNotification.footerImage.tintColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        footerNotification.center = CGPointMake((footer.frame.size.width/8) * 7, footer.frame.size.height/4+5)
        footerDown.addSubview(footerNotification)
        
        let footerUp = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width/2, 45))
        footerUp.center = CGPointMake(self.view.frame.size.width/2, -10)
        footerUp.backgroundColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 255/255) // #232d4a
        footerUp.layer.borderWidth = 1
        footerUp.layer.borderColor = UIColor(red: 57/255, green: 66/255, blue: 106/255, alpha: 255/255).CGColor // #39426a
        footerUp.layer.cornerRadius = footerUp.frame.self.width / 10
        footer.addSubview(footerUp)
        
        let drawPartition = drawFooterLine(frame: CGRect(x: self.view.frame.size.width/4, y: 0, width: 20, height: 45))
        drawPartition.backgroundColor = UIColor.clearColor()
        footerUp.addSubview(drawPartition)
        
        let footerTravel = FooterView(frame: CGRectMake(0, 0, footer.frame.size.width/2, 50))
        footerTravel.footerText.text = "Travel Life"
        footerTravel.footerImage.image = UIImage(named: "travel_life_icon")
        footerTravel.footerImage.frame.size.width = 50.0
        footerTravel.center = CGPointMake(footerUp.frame.size.width/4, footerUp.frame.size.height/4+5)
        footerUp.addSubview(footerTravel)
        
        let footerLocal = FooterView(frame: CGRectMake(0, 0, footer.frame.size.width/2, 50))
        footerLocal.footerText.text = "Local Life"
        footerLocal.footerImage.image = UIImage(named: "local_life_icon")
        //footerLocal.footerImage.sizeThatFits(CGSize(width: 10, height: 10))
        //footerLocal.clipsToBounds = true
        footerLocal.autoresizesSubviews = true
        footerLocal.center = CGPointMake((footerUp.frame.size.width/4) * 3, footerUp.frame.size.height/4+5)
        footerUp.addSubview(footerLocal)
        
        self.view.addSubview(footer)
//
//        // video post
////        let videoPost = VideoPost(frame: CGRectMake(0, 0, self.view.frame.size.width, 350))
////        videoPost.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
////        self.view.addSubview(videoPost)
//        
//        let tripSummaryProfile = TripSummaryProfile(frame: CGRectMake(0, 0, self.view.frame.size.width, 350))
//        tripSummaryProfile.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
//        //self.view.addSubview(tripSummaryProfile)
//        
//        let enterJourneyNameView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width - 25, 60))
//        enterJourneyNameView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
//        enterJourneyNameView.layer.cornerRadius = 5
//        enterJourneyNameView.backgroundColor = UIColor.whiteColor()
//        enterJourneyNameView.layer.shadowRadius = 1
//        enterJourneyNameView.layer.shadowOffset = CGSizeZero
//        enterJourneyNameView.layer.shadowColor = UIColor.blackColor().CGColor
//        enterJourneyNameView.layer.shadowOpacity = 0.2
//        //enterJourneyNameView.bounds = CGRectInset(view.frame, 10, 20)
//        let enterJourneyNameText = UITextField(frame: CGRectMake(0, 0, enterJourneyNameView.frame.size.width - 20, enterJourneyNameView.frame.size.height))
//        enterJourneyNameText.center = CGPointMake(enterJourneyNameView.frame.size.width / 2 + 5, enterJourneyNameView.frame.size.height / 2)
//        enterJourneyNameText.attributedPlaceholder = NSAttributedString(string:"Name Your Journey", attributes:[NSForegroundColorAttributeName: UIColor.blackColor()])
//        enterJourneyNameText.textAlignment = .Center
//        enterJourneyNameView.addSubview(enterJourneyNameText)
//        self.view.addSubview(enterJourneyNameView)
        
//        let drawView = drawLine(frame: CGRect(x: self.view.frame.size.width/2, y: 550, width: 10, height: 1000))
//        drawView.backgroundColor = UIColor.clearColor()
//        self.scrollView.addSubview(drawView)
//        
//        let shoesStartJourney = UIImageView(frame: CGRect(x: self.view.frame.size.width/2 - 25, y: 500, width: 50, height: 59.5))
//        shoesStartJourney.image = UIImage(named: "journey_shoes")
//        self.scrollView.addSubview(shoesStartJourney)
        
//        self.addColorPattern.animation.makeY((self.view.frame.height)).easeInOut.animateWithCompletion(5000, {
//            self.addColorPattern.removeFromSuperview()
//        })
//        UIView.animateWithDuration(0.7, delay: 1.0, options: .CurveEaseOut, animations: {
//            shoesStartJourney.frame.size.height = 800
//                }, completion: { finished in
//            })
        
        //Button for: Start Journey
//        let orangeButton = OrangeButton(frame: CGRectMake(0, 0, self.view.frame.size.width - 200, 50))
//        orangeButton.center = CGPointMake(self.view.frame.size.width/2, 650)
//        orangeButton.orangeButtonTitle.layer.cornerRadius = 3
//        let buttonIcon = Character(UnicodeScalar(UInt32(0xf10d)))
//        //let buttonIconText = String(buttonIcon.text)
//        print(buttonIcon)
//        orangeButton.orangeButtonTitle.setTitle("\u{f170} Start Journey", forState: .Normal)
//        self.scrollView.addSubview(orangeButton)
        
        //Text field for: entering journey name
//        let enterJourneyNameView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width - 25, 60))
//        enterJourneyNameView.center = CGPointMake(self.view.frame.size.width/2, 650)
//        enterJourneyNameView.layer.cornerRadius = 5
//        enterJourneyNameView.backgroundColor = UIColor.whiteColor()
//        enterJourneyNameView.layer.shadowRadius = 1
//        enterJourneyNameView.layer.shadowOffset = CGSizeZero
//        enterJourneyNameView.layer.shadowColor = UIColor.blackColor().CGColor
//        enterJourneyNameView.layer.shadowOpacity = 0.2
//        //enterJourneyNameView.bounds = CGRectInset(view.frame, 10, 20)
//        let enterJourneyNameText = UITextField(frame: CGRectMake(0, 0, enterJourneyNameView.frame.size.width - 20, enterJourneyNameView.frame.size.height))
//        enterJourneyNameText.font = avenirFont
//        enterJourneyNameText.center = CGPointMake(enterJourneyNameView.frame.size.width / 2 + 5, enterJourneyNameView.frame.size.height / 2)
//        enterJourneyNameText.attributedPlaceholder = NSAttributedString(string:"Name Your Journey", attributes:[NSForegroundColorAttributeName: UIColor.blackColor()])
//        enterJourneyNameText.textAlignment = .Center
//        enterJourneyNameView.addSubview(enterJourneyNameText)
//        self.scrollView.addSubview(enterJourneyNameView)
        
//        let journeyLabel = TextLabelView(frame: CGRectMake(0, 0, self.view.frame.size.width - 40, 50))
//        journeyLabel.center = CGPointMake(self.view.frame.size.width/2, 650)
//        journeyLabel.label.text = "Exploring United Kingdom"
//        self.scrollView.addSubview(journeyLabel)
        
        let locationTextField = TextField(frame: CGRectMake(0, 0, self.view.frame.size.width - 25, 60))
        locationTextField.center = CGPointMake(self.view.frame.size.width/2, 800)
        locationTextField.field.text = "London"
        self.scrollView.addSubview(locationTextField)

//        let checkBoxGroup1 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/4))
//        checkBoxGroup1.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height/3) - 50)
//        self.view.addSubview(checkBoxGroup1)
//        
//        let adventureCheckBox = TypeOfJourney(frame: CGRect(x: 0, y: 0, width: 85, height: 65))
//        adventureCheckBox.center = CGPointMake(checkBoxGroup1.frame.size.width/4 - 35, checkBoxGroup1.frame.size.height/3 - 9)
//        adventureCheckBox.label.text = "Adventure"
//        checkBoxGroup1.addSubview(adventureCheckBox)
//        
//        let backpackingCheckBox = TypeOfJourney(frame: CGRect(x: 0, y: 0, width: 85, height: 65))
//        backpackingCheckBox.center = CGPointMake(checkBoxGroup1.frame.size.width/2, checkBoxGroup1.frame.size.height/3 - 9)
//        backpackingCheckBox.label.text = "Backpacking"
//        checkBoxGroup1.addSubview(backpackingCheckBox)
//        
//        let businessCheckBox = TypeOfJourney(frame: CGRect(x: 0, y: 0, width: 85, height: 65))
//        businessCheckBox.center = CGPointMake((checkBoxGroup1.frame.size.width/4 * 3) + 35, checkBoxGroup1.frame.size.height/3 - 9)
//        businessCheckBox.label.text = "Business"
//        checkBoxGroup1.addSubview(businessCheckBox)
//        
//        let religiousCheckBox = TypeOfJourney(frame: CGRect(x: 0, y: 0, width: 85, height: 65))
//        religiousCheckBox.center = CGPointMake(checkBoxGroup1.frame.size.width/3, checkBoxGroup1.frame.size.height/4 * 3 + 9)
//        religiousCheckBox.label.text = "Religious"
//        checkBoxGroup1.addSubview(religiousCheckBox)
//        
//        let romanticGetawayCheckBox = TypeOfJourney(frame: CGRect(x: 0, y: 0, width: 85, height: 65))
//        romanticGetawayCheckBox.center = CGPointMake(checkBoxGroup1.frame.size.width/3 * 2, checkBoxGroup1.frame.size.height/4 * 3 + 9)
//        romanticGetawayCheckBox.label.text = "Romantic Getaway"
//        checkBoxGroup1.addSubview(romanticGetawayCheckBox)
//        
//        let drawSeperator1 = drawSeperatorLine(frame: CGRect(x: self.view.frame.size.width/6, y: self.view.frame.size.height/3 * 1.2, width: self.view.frame.size.width/1.5, height: 10))
//        drawSeperator1.backgroundColor = UIColor.clearColor()
//        self.view.addSubview(drawSeperator1)
//        
//        
//        let checkBoxGroup2 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/8))
//        checkBoxGroup2.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height/2) - 15)
//        self.view.addSubview(checkBoxGroup2)
//        
//        let budgetCheckBox = TypeOfJourney(frame: CGRect(x: 0, y: 0, width: 85, height: 65))
//        budgetCheckBox.center = CGPointMake(checkBoxGroup2.frame.size.width/3, checkBoxGroup2.frame.size.height/2)
//        budgetCheckBox.label.text = "Budget"
//        checkBoxGroup2.addSubview(budgetCheckBox)
//        
//        let luxuryCheckBox = TypeOfJourney(frame: CGRect(x: 0, y: 0, width: 85, height: 65))
//        luxuryCheckBox.center = CGPointMake(checkBoxGroup2.frame.size.width/3 * 2, checkBoxGroup2.frame.size.height/2)
//        luxuryCheckBox.label.text = "Luxury"
//        checkBoxGroup2.addSubview(luxuryCheckBox)
//        
//        let drawSeperator2 = drawSeperatorLine(frame: CGRect(x: self.view.frame.size.width/6, y: self.view.frame.size.height/3 * 1.65, width: self.view.frame.size.width/1.5, height: 10))
//        drawSeperator2.backgroundColor = UIColor.clearColor()
//        self.view.addSubview(drawSeperator2)
//        
//        
//        let checkBoxGroup3 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/4))
//        checkBoxGroup3.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height/3 * 2) + 20)
//        self.view.addSubview(checkBoxGroup3)
//        
//        let familyCheckBox = TypeOfJourney(frame: CGRect(x: 0, y: 0, width: 85, height: 65))
//        familyCheckBox.center = CGPointMake(checkBoxGroup3.frame.size.width/4 - 35, checkBoxGroup3.frame.size.height/3 - 15)
//        familyCheckBox.label.text = "Family"
//        checkBoxGroup3.addSubview(familyCheckBox)
//        
//        let friendsCheckBox = TypeOfJourney(frame: CGRect(x: 0, y: 0, width: 85, height: 65))
//        friendsCheckBox.center = CGPointMake(checkBoxGroup3.frame.size.width/2, checkBoxGroup3.frame.size.height/3 - 15)
//        friendsCheckBox.label.text = "Friends"
//        checkBoxGroup3.addSubview(friendsCheckBox)
//        
//        let soleCheckBox = TypeOfJourney(frame: CGRect(x: 0, y: 0, width: 85, height: 65))
//        soleCheckBox.center = CGPointMake((checkBoxGroup3.frame.size.width/4 * 3) + 35, checkBoxGroup3.frame.size.height/3 - 15)
//        soleCheckBox.label.text = "Sole"
//        checkBoxGroup3.addSubview(soleCheckBox)
//        
//        let betterHalfCheckBox = TypeOfJourney(frame: CGRect(x: 0, y: 0, width: 85, height: 65))
//        betterHalfCheckBox.center = CGPointMake(checkBoxGroup3.frame.size.width/3, checkBoxGroup3.frame.size.height/4 * 3)
//        betterHalfCheckBox.label.text = "Better Half"
//        checkBoxGroup3.addSubview(betterHalfCheckBox)
//        
//        let colleaguesCheckBox = TypeOfJourney(frame: CGRect(x: 0, y: 0, width: 85, height: 65))
//        colleaguesCheckBox.center = CGPointMake(checkBoxGroup3.frame.size.width/3 * 2, checkBoxGroup3.frame.size.height/4 * 3)
//        colleaguesCheckBox.label.text = "Colleagues"
//        checkBoxGroup3.addSubview(colleaguesCheckBox)
//        
//        let doneButton = OrangeButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width * 0.75, height: 40))
//        doneButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/3 * 2.6)
//        self.view.addSubview(doneButton)

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
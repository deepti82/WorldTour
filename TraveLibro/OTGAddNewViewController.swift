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
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        view.backgroundColor = mainBlueColor
        self.view.addSubview(view)
        
        navigationBar.layer.zPosition = 10000
        
        // appling avenir font to label and button
        //UILabel.appearance().font = avenirFont
//        button.titleLabel!.font = avenirFont
//        
//        let journey = JourneyTitleView(frame: CGRectMake(0, 0, self.view.frame.size.width, 65))
//        journey.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 - 75)
//        self.view.addSubview(journey)
//        
//        let journeyImageView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 180))
//        journeyImageView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 + 125 - 80)
//        let image = UIImage(named: "london_image")
//        let journeyImage = UIImageView(frame: CGRectMake(0, 0, journeyImageView.frame.size.width, journeyImageView.frame.size.height))
//        journeyImage.image = image!
//        //journeyImage.center = CGPointMake(journeyImageView.frame.size.width, 100)
//        journeyImageView.addSubview(journeyImage)
//        journeyImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
//        journeyImageView.layer.shadowOpacity = 0.2
//        journeyImageView.layer.shadowRadius = 1
//        self.view.addSubview(journeyImageView)
        
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
        footerFeed.footerImage.image = UIImage(named: "feed_icon")
        footerFeed.center = CGPointMake(footer.frame.size.width/8, footer.frame.size.height/4+5)
        footerDown.addSubview(footerFeed)
        
        let footerNotification = FooterView(frame: CGRectMake(0, 0, footer.frame.size.width/3, 50))
        footerNotification.footerText.text = "Notifications"
        footerNotification.footerImage.image = UIImage(named: "notification_icon")
        footerNotification.center = CGPointMake((footer.frame.size.width/8) * 7, footer.frame.size.height/4+5)
        footerDown.addSubview(footerNotification)
        
        let footerUp = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width/2, 45))
        footerUp.center = CGPointMake(self.view.frame.size.width/2, -10)
        footerUp.backgroundColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 255/255) // #232d4a
        footerUp.layer.borderWidth = 1
        footerUp.layer.borderColor = UIColor(red: 57/255, green: 66/255, blue: 106/255, alpha: 255/255).CGColor // #39426a
        footerUp.layer.cornerRadius = footerUp.frame.self.width / 10
        footer.addSubview(footerUp)
        
        let drawPartition = drawFooterLine(frame: CGRect(x: self.view.frame.size.width/4 + 3, y: 0, width: 20, height: 45))
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
        
        let drawView = drawLine(frame: CGRect(x: 190, y: 550, width: 10, height: 1000))
        drawView.backgroundColor = UIColor.clearColor()
        self.scrollView.addSubview(drawView)
        
        let shoesStartJourney = UIImageView(frame: CGRect(x: 170, y: 500, width: 50, height: 59.5))
        shoesStartJourney.image = UIImage(named: "journey_shoes")
        self.scrollView.addSubview(shoesStartJourney)
        
//        self.addColorPattern.animation.makeY((self.view.frame.height)).easeInOut.animateWithCompletion(5000, {
//            self.addColorPattern.removeFromSuperview()
//        })
//        UIView.animateWithDuration(0.7, delay: 1.0, options: .CurveEaseOut, animations: {
//            shoesStartJourney.frame.size.height = 800
//                }, completion: { finished in
//            })
        
        let orangeButton = OrangeButton(frame: CGRectMake(0, 0, self.view.frame.size.width - 200, 50))
        orangeButton.center = CGPointMake(190, 650)
        orangeButton.orangeButtonTitle.layer.cornerRadius = 3
        let buttonIcon = Character(UnicodeScalar(UInt32(0xf10d)))
        //let buttonIconText = String(buttonIcon.text)
        print(buttonIcon)
        orangeButton.orangeButtonTitle.setTitle("\u{f170} Start Journey", forState: .Normal)
        self.scrollView.addSubview(orangeButton)
        
        let enterJourneyNameView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width - 25, 60))
        enterJourneyNameView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
        enterJourneyNameView.layer.cornerRadius = 5
        enterJourneyNameView.backgroundColor = UIColor.whiteColor()
        enterJourneyNameView.layer.shadowRadius = 1
        enterJourneyNameView.layer.shadowOffset = CGSizeZero
        enterJourneyNameView.layer.shadowColor = UIColor.blackColor().CGColor
        enterJourneyNameView.layer.shadowOpacity = 0.2
        //enterJourneyNameView.bounds = CGRectInset(view.frame, 10, 20)
        let enterJourneyNameText = UITextField(frame: CGRectMake(0, 0, enterJourneyNameView.frame.size.width - 20, enterJourneyNameView.frame.size.height))
        enterJourneyNameText.center = CGPointMake(enterJourneyNameView.frame.size.width / 2 + 5, enterJourneyNameView.frame.size.height / 2)
        enterJourneyNameText.attributedPlaceholder = NSAttributedString(string:"Name Your Journey", attributes:[NSForegroundColorAttributeName: UIColor.blackColor()])
        enterJourneyNameText.textAlignment = .Center
        enterJourneyNameView.addSubview(enterJourneyNameText)
        self.view.addSubview(enterJourneyNameView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
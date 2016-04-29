//
//  ViewController.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 23/04/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let button: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // adding status bar view
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        view.backgroundColor = mainBlueColor
        self.view.addSubview(view)
        
        // appling avenir font to label and button
        //UILabel.appearance().font = avenirFont
        button.titleLabel!.font = avenirFont
        
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
//        
//        let addcircle = AddCircle(frame: CGRectMake(0, 0, 50, 50))
//        addcircle.center = CGPointMake(self.view.frame.size.width - 40, self.view.frame.size.height - 100)
//        self.view.addSubview(addcircle)
//        
//        let infocircle = InfoCircle(frame: CGRectMake(0, 0, 40, 40))
//        infocircle.center = CGPointMake(40, self.view.frame.size.height - 95)
//        self.view.addSubview(infocircle)
        
        let orangeButton = OrangeButton(frame: CGRectMake(0, 0, self.view.frame.size.width - 200, 50))
        orangeButton.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
        orangeButton.orangeButtonTitle.layer.cornerRadius = 3
        let buttonIcon = UILabel(frame: CGRectMake(0, 0, 20, 20))
        buttonIcon.font = FontAwesomeFont
        buttonIcon.text = String(format: "%C", faicon["clock"]!)
        let buttonIconText: String = String(format: "%C", faicon["clock"]!)
        print(buttonIconText)
        orangeButton.orangeButtonTitle.setTitle(buttonIconText + " Happy Journey", forState: UIControlState.Normal)
        //self.view.addSubview(orangeButton)
        
        let footer = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 45))
        footer.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height)
        
        let footerDown = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 45))
        footerDown.center = CGPointMake(footer.frame.size.width / 2, 0)
        footerDown.backgroundColor = mainBlueColor
        footer.addSubview(footerDown)
        
        let footerFeed = FooterView(frame: CGRectMake(0, 0, footer.frame.size.width / 4, 50))
        footerFeed.footerText.text = "Feeed"
        //footerFeed.footerImage.image = UIImage(named: "info_circle")
        footerFeed.center = CGPointMake(0, 30)
        footerDown.addSubview(footerFeed)
        
        let footerNotification = FooterView(frame: CGRectMake(0, 0, footer.frame.size.width / 4, 50))
        footerNotification.footerText.text = "Notification"
        //footerNotification.footerImage.image = UIImage(named: "info_circle")
        footerNotification.center = CGPointMake(footer.frame.size.width - (footer.frame.size.width / 4) - 5, 30)
        footerDown.addSubview(footerNotification)
        
        let footerUp = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width / 2, 50))
        footerUp.center = CGPointMake(self.view.frame.size.width / 2, -10)
        footerUp.backgroundColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 255/255) // #232d4a
        footerUp.layer.borderWidth = 1
        footerUp.layer.borderColor = UIColor(red: 57/255, green: 66/255, blue: 106/255, alpha: 255/255).CGColor // #39426a
        footerUp.layer.cornerRadius = footerUp.frame.self.width / 10
        footer.addSubview(footerUp)
        
        let footerTravel = FooterView(frame: CGRectMake(0, 0, footer.frame.size.width / 4, 50))
        footerTravel.footerText.text = "Travel Life"
        //footerTravel.footerImage.image = UIImage(named: "info_circle")
        footerTravel.center = CGPointMake(0, 35)
        footerUp.addSubview(footerTravel)
        
        let footerLocal = FooterView(frame: CGRectMake(0, 0, footer.frame.size.width / 4, 50))
        footerLocal.footerText.text = "Local Life"
        //footerLocal.footerImage.image = UIImage(named: "info_circle")
        footerLocal.center = CGPointMake(footerUp.frame.size.width / 2 - 10, 35)
        footerUp.addSubview(footerLocal)
        
        self.view.addSubview(footer)
        
        // video post
//        let videoPost = VideoPost(frame: CGRectMake(0, 0, self.view.frame.size.width, 350))
//        videoPost.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
//        self.view.addSubview(videoPost)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
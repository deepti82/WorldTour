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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
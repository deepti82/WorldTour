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
        
        let journey = JourneyTitleView(frame: CGRectMake(0, 0, self.view.frame.size.width, 70))
        journey.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
        self.view.addSubview(journey)
        
        let circle = AddCircle(frame: CGRectMake(0, 0, 50, 50))
        circle.center = CGPointMake(self.view.frame.size.width - 40, self.view.frame.size.height - 100)
        self.view.addSubview(circle)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
//
//  LogInViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)
        self.navigationController?.navigationBarHidden = false
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        
//        let rightButton = UIButton()
//        rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
//        rightButton.addTarget(self, action: #selector(VerifyEmailViewController.selectNationality(_:)), forControlEvents: .TouchUpInside)
//        rightButton.frame = CGRectMake(0, 8, 30, 30)
        
        self.customNavigationBar(leftButton, right: nil)
        
        let logIn = LogInView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 400))
        logIn.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        self.view.addSubview(logIn)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//
//  MyLifeViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 23/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class MyLifeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let momentsView = MomentsTab(frame: CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: self.view.frame.size.height - 100))
//        self.view.addSubview(momentsView)

        let tabs = MyLifeTabs(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100))
        tabs.center = CGPointMake(self.view.frame.width/2, 20)
        self.view.addSubview(tabs)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

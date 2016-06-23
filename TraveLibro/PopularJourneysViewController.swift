//
//  PopularJourneysViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 24/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class PopularJourneysViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGround(self)
        
        self.setNavigationBarItem()
        
        let popJourneyView = PopularJourneyView(frame: CGRect(x: 0, y: 90, width: self.view.frame.size.width, height: 580))
        self.view.addSubview(popJourneyView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

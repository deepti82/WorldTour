//
//  CollectionViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 13/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    var journey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBackGround(self)
        
        let scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        scroll.contentSize.height = 1000
        self.view.addSubview(scroll)
        
        let childVC = storyboard?.instantiateViewController(withIdentifier: "summarySub") as! SummarySubViewController
        childVC.journeyId = journey
        self.addChildViewController(childVC)
        childVC.view.frame.size.height = scroll.contentSize.height
        scroll.addSubview(childVC.view)
        
    }

}

//
//  CollectionViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 13/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBackGround(self)
        
        let scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        scroll.contentSize.height = 1000
        self.view.addSubview(scroll)
        
        let childVC = storyboard?.instantiateViewControllerWithIdentifier("summarySub") as! SummarySubViewController
        self.addChildViewController(childVC)
        childVC.view.frame.size.height = scroll.contentSize.height
        scroll.addSubview(childVC.view)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

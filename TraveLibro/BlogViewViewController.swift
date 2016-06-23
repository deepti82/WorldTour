//
//  BlogViewViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 24/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class BlogViewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        getDarkBackGround(self)
        
//        self.setNavigationBarItem()
        
//        let blogView = BlogView(frame: CGRect(x: 0, y: 70, width: self.view.frame.size.width, height: 600))
//        self.view.addSubview(blogView)
        
//        let iteneraryView = BlogView(frame: CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 600))
//        iteneraryView.blogDetailView.removeFromSuperview()
//        self.view.addSubview(iteneraryView)
        
        
        let blogView = EachMustDo(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(blogView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

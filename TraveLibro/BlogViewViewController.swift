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
        
        
//        let blogView = BlogView(frame: CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 600))
//        self.view.addSubview(blogView)
        
        let iteneraryView = BlogView(frame: CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 600))
        iteneraryView.blogDetailView.removeFromSuperview()
        self.view.addSubview(iteneraryView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

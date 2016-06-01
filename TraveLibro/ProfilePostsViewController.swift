//
//  ProfilePostsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 30/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ProfilePostsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGround(self)
        
//        let otgPost = InProfileOTGPost(frame: CGRect(x: 0, y: 75, width: self.view.frame.width, height: 520))
//        self.view.addSubview(otgPost)
        
        let otgPostTwo = InProfileOTGPost(frame: CGRect(x: 0, y: 75, width: self.view.frame.width, height: 520))
        otgPostTwo.iconButtonView.removeFromSuperview()
        otgPostTwo.statusLabel.removeFromSuperview()
        self.view.addSubview(otgPostTwo)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

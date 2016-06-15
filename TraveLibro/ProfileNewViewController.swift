//
//  ProfileNewViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 14/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ProfileNewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let scrollView = UIScrollView(frame: CGRect(x: 0, y: self.view.frame.size.height/3 - 100, width: self.view.frame.size.width, height: 650))
        self.view.addSubview(scrollView)
        
        scrollView.contentSize.height = 2000
        
//        let vc = ProfileViewController()
//        
//        scrollView.addSubview(vc.view)
        
        
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

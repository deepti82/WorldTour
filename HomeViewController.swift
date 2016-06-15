//
//  HomeViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 15/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGround(self)
        
        let footer = getFooter(frame: CGRect(x: 0, y: self.view.frame.height - 45, width: self.view.frame.width, height: 45))
        footer.layer.zPosition = 100
        self.view.addSubview(footer)
        
        let signUpOne = storyboard?.instantiateViewControllerWithIdentifier("SignUpOne") as! SignInViewController
        self.addChildViewController(signUpOne)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

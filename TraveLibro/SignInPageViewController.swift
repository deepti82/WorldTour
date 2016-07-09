//
//  SignInPageViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SignInPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGround(self)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        
        self.customNavigationBar(leftButton, right: nil)
        
        let pageView = SignInFullView(frame: CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: self.view.frame.size.height - 60))
        self.view.addSubview(pageView)
        
        pageView.signUpButton.addTarget(self, action: #selector(SignInPageViewController.signedUp(_:)), forControlEvents: .TouchUpInside)
        
    }
    
    func signedUp(sender: AnyObject) {
        
        let verifyVC = storyboard?.instantiateViewControllerWithIdentifier("verifyOne") as! VerifyEmailViewController
        self.navigationController?.pushViewController(verifyVC, animated: true)
        
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

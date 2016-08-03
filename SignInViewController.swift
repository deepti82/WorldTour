//
//  SignInViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)
        
        let signInFooter = SignInToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height - 120, width: self.view.frame.size.width, height: 150))
        self.view.addSubview(signInFooter)
        
        signInFooter.signUpButton.addTarget(self, action: #selector(SignInViewController.goToSignUpPage(_:)), forControlEvents: .TouchUpInside)
        
        
    }
    
    func goToSignUpPage(sender: AnyObject) {
        
        print("inside function!")
        print("storyboard: \(self.navigationController)")
        
        let signUpFullVC = storyboard?.instantiateViewControllerWithIdentifier("signUpTwo") as! SignInPageViewController
        self.navigationController?.pushViewController(signUpFullVC, animated: true)
        
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

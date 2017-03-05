//
//  LogInViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Toaster

class LogInViewController: UIViewController {

    @IBOutlet weak var videoScrollView: UIScrollView!
    var layout:HorizontalLayout!
    var logIn = LogInView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in loaded")
        
        layout = HorizontalLayout(height: videoScrollView.frame.height)
        
        videoScrollView.addSubview(layout)
        
        getDarkBackGroundBlur(self)
        self.navigationController?.isNavigationBarHidden = false
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
//        let rightButton = UIButton()
//        rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
//        rightButton.addTarget(self, action: #selector(VerifyEmailViewController.selectNationality(_:)), forControlEvents: .TouchUpInside)
//        rightButton.frame = CGRectMake(0, 8, 30, 30)
        
        self.customNavigationBar(left: leftButton, right: nil)
    
        
        logIn = LogInView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 450))
        logIn.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        self.view.addSubview(logIn)
        
        
        logIn.logInButton.addTarget(self, action: #selector(LogInViewController.loginTabbed(_:)), for: .touchUpInside)
        logIn.fbButton.addTarget(self, action: #selector(SignInPageViewController.facebookSignUp(_:)), for: .touchUpInside)
        logIn.googleButton.addTarget(self, action: #selector(SignInPageViewController.googleSignUp(_:)), for: .touchUpInside)
        
    }
    
    func facebookSignUp(_ sender: AnyObject) {
        
        social.facebookLogin()
        
    }
    
    func googleSignUp(_ sender: AnyObject) {
        
        social.googleLogin()
        
    }
    
    func loginTabbed(_ sender: AnyObject) {
        print("\n loginTabbed ")      
        
        let emailTxt = logIn.emailTxt.text //"testuser@mailinator.com" //logIn.nameField.text!
        let passwordTxt =  logIn.passwordTxt.text //"testuser1" //logIn.passwordField.text!
        
        if emailTxt != "" && passwordTxt != "" {
            
            request.loginUser(email: emailTxt!, password: passwordTxt!) { (response) in
                
                DispatchQueue.main.async(execute: {
                    if response.error != nil {
                        print("error: \(response.error!.localizedDescription)")
                    }
                    else if response["value"].bool! {
                        //Signup on Success
                        let signUpFullVC = self.storyboard?.instantiateViewController(withIdentifier: "signUpTwo") as! SignInPageViewController
                        loggedInUser = response["data"]
                        self.navigationController?.pushViewController(signUpFullVC, animated: true)
                    }
                    else {                    
                        print("response error!")
                        Toast(text: "Error").show()
                    }                    
                })                
            }            
        }
        else {
            let errorAlert = UIAlertController(title: "Error", message: "Please fill email and password properly", preferredStyle: UIAlertControllerStyle.alert)
            let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
                (result : UIAlertAction) -> Void in
                //Cancel Action
            }            
            errorAlert.addAction(DestructiveAction)
            self.navigationController?.present(errorAlert, animated: true, completion: nil)
        }        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

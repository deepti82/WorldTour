//
//  LogInViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Toaster

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var videoScrollView: UIScrollView!
    var layout:HorizontalLayout!
    var logIn = LogInView()
    var forgotView = ForgotPassword()
    var emailTxtField = UITextField()
    let loader = LoadingOverlay()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout = HorizontalLayout(height: videoScrollView.frame.height)
        
        videoScrollView.addSubview(layout)
        
        getDarkBackGroundBlur(self)
        self.navigationController?.isNavigationBarHidden = false
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.customNavigationBar(left: leftButton, right: nil)
        
        logIn = LogInView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 450))
        logIn.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        self.view.addSubview(logIn)
        
        logIn.emailTxt.delegate = self
        logIn.passwordTxt.delegate = self
        
        logIn.logInButton.addTarget(self, action: #selector(LogInViewController.loginTabbed(_:)), for: .touchUpInside)
        logIn.fbButton.addTarget(self, action: #selector(SignInPageViewController.facebookSignUp(_:)), for: .touchUpInside)
        logIn.googleButton.addTarget(self, action: #selector(SignInPageViewController.googleSignUp(_:)), for: .touchUpInside)
        logIn.forgotPassword.addTarget(self, action: #selector(LogInViewController.forgotPasswordTabbed(_:)), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        NotificationCenter.default.addObserver(self, selector: #selector(self.userSocialLoginFailed(notification:)), name: NSNotification.Name(rawValue: "SOCIAL_LOGIN_FAILED"), object: nil)       
        NotificationCenter.default.addObserver(self, selector: #selector(self.saveUserFailed(notification:)), name: NSNotification.Name(rawValue: "SAVE_USER_FAILED"), object: nil)
        logIn.emailTxt.text = ""
        logIn.passwordTxt.text = ""
        if shouldShowLoader {
            loader.showOverlay(self.view)            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        loader.hideOverlayView()
        shouldShowLoader = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()        
    }
    
    
    //MARK: - Button Actions
    
    func facebookSignUp(_ sender: AnyObject) {
        //shouldShowLoader = true
        //loader.showOverlay(self.view)
        social.facebookLogin()
    }
    
    func googleSignUp(_ sender: AnyObject) {
        //shouldShowLoader = true
        //loader.showOverlay(self.view)        
        social.googleLogin()
        
    }
    
    func loginTabbed(_ sender: AnyObject) {
        
        logIn.emailTxt.resignFirstResponder()
        logIn.passwordTxt.resignFirstResponder()
        
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
                        var errorMsg = ""
                        let serverMessage = response["error"]["message"].stringValue
                        errorMsg = serverMessage == "Wrong Email" ? "Please check your Email Id" : "Incorrect username or password"
                        
                        let errorAlert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: UIAlertControllerStyle.alert)
                        let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
                            (result : UIAlertAction) -> Void in
                            if serverMessage == "Wrong Email" {
                                self.logIn.emailTxt.text = ""
                            }
                            else if serverMessage == "Wrong Passsword" {
                                self.logIn.passwordTxt.text = ""
                            }
                        }
                        errorAlert.addAction(DestructiveAction)
                        self.navigationController?.present(errorAlert, animated: true, completion: nil)
                    }                    
                })                
            }            
        }
        else {
            let errorAlert = UIAlertController(title: "Error", message: "Please enter correct email and password.", preferredStyle: UIAlertControllerStyle.alert)
            let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
                (result : UIAlertAction) -> Void in
                //Cancel Action
            }            
            errorAlert.addAction(DestructiveAction)
            self.navigationController?.present(errorAlert, animated: true, completion: nil)
        }        
    }
    
    func forgotPasswordTabbed(_ sender: AnyObject) {        
        forgotView = ForgotPassword(frame: CGRect(x: 0, y: 0, width: screenWidth, height: self.view.frame.height))        
        
        forgotView.backgroundView.layer.cornerRadius = 5.0
        forgotView.emailIDTxtField.delegate = self
        
        forgotView.cancelButton.addTarget(self, action: #selector(self.dismissForgotPassword), for: .touchUpInside)
        forgotView.confirmButton.addTarget(self, action: #selector(self.requestForgotPassword), for: .touchUpInside)
        
        forgotView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight)
        self.view.addSubview(forgotView)
        
        UIView.animate(withDuration: 0.5) {
            self.forgotView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            self.forgotView.center = CGPoint(x: self.view.center.x, y: (screenHeight/2 - 64))
        }        
    }
    
    func requestForgotPassword() {
            
        let emailStr = forgotView.emailIDTxtField.text
        
        if emailStr != "" {
            loader.showOverlay(self.view)
            
            request.forgotPassword(email: emailStr!) { (response) in
                
                DispatchQueue.main.async(execute: {
                    
                    self.loader.hideOverlayView()
                    
                    if response.error != nil {
                        print("error: \(response.error!.localizedDescription)")
                    }
                    else if response["value"].bool! {
                        
                        self.dismissForgotPassword()
                        
                        let mailAlert = UIAlertController(title: "", message: "OTP sent on this email", preferredStyle: UIAlertControllerStyle.alert)
                        let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
                            (result : UIAlertAction) -> Void in
                            //Cancel Action
                        }            
                        mailAlert.addAction(DestructiveAction)
                        self.navigationController?.present(mailAlert, animated: true, completion: nil)
                    }
                    else {                    
                        let mailErrorAlert = UIAlertController(title: "Error", message: "Seems like your account is linked to either Facebook or Google. Please login using your origanally linked Facebook or Google Account.", preferredStyle: UIAlertControllerStyle.alert)
                        let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
                            (result : UIAlertAction) -> Void in
                            //Cancel Action
                        }            
                        mailErrorAlert.addAction(DestructiveAction)
                        self.navigationController?.present(mailErrorAlert, animated: true, completion: nil)
                    }
                })
            }
        }
        else {
            
            let errorAlert = UIAlertController(title: "", message: "Please enter email id ", preferredStyle: UIAlertControllerStyle.alert)
            let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
                (result : UIAlertAction) -> Void in
            }
            errorAlert.addAction(DestructiveAction)
            self.navigationController?.present(errorAlert, animated: true, completion: nil)
        }
        
    }
    
    func dismissForgotPassword() {
        UIView.animate(withDuration: 1) {
            self.forgotView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight)
            self.forgotView.removeFromSuperview()
        }       
    }
    
    
    //MARK: - Dismiss Keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        logIn.emailTxt.resignFirstResponder()
        logIn.passwordTxt.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Notification Handler
    
    func userSocialLoginFailed(notification : Notification) {
        
        let errorAlert = UIAlertController(title: "Error", message: "Unable to login. Please try after some time.", preferredStyle: UIAlertControllerStyle.alert)
        let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
            (result : UIAlertAction) -> Void in
        }            
        errorAlert.addAction(DestructiveAction)
        self.navigationController?.present(errorAlert, animated: true, completion: nil)
    }
    
    func saveUserFailed(notification: Notification)  {
        loader.hideOverlayView()
        let errorAlert = UIAlertController(title: "Error", message: "Something went wrong. Please try after some time.", preferredStyle: UIAlertControllerStyle.alert)
        let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
            (result : UIAlertAction) -> Void in
            //Cancel Action
        }            
        errorAlert.addAction(DestructiveAction)
        self.navigationController?.present(errorAlert, animated: true, completion: nil)
    }
}

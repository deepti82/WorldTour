    //
//  SignInPageViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit


class SignInPageViewController: UIViewController {
    
    var keyboardUp = false
    var params = [String: String]()
    var pageView: SignInFullView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)
        
        self.navigationController?.isNavigationBarHidden = false
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        self.customNavigationBar(left: leftButton, right: nil)
        
        pageView = SignInFullView(frame: CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: self.view.frame.size.height - 60))
        self.view.addSubview(pageView)
        pageView.loginButton.addTarget(self, action: #selector(SignInPageViewController.gotoLogin(_:)), for: .touchUpInside)
        pageView.facebookButton.addTarget(self, action: #selector(SignInPageViewController.facebookSignUp(_:)), for: .touchUpInside)
        pageView.googleButton.addTarget(self, action: #selector(SignInPageViewController.googleSignUp(_:)), for: .touchUpInside)
        pageView.twitterButton.addTarget(self, action: #selector(SignInPageViewController.twitterSignUp(_:)), for: .touchUpInside)
        pageView.instagramButton.addTarget(self, action: #selector(SignInPageViewController.igSignUp(_:)), for: .touchUpInside)
        
        let fbTap = UITapGestureRecognizer(target: self, action: #selector(SignInPageViewController.facebookSignUp(_:)))
        let googleTap = UITapGestureRecognizer(target: self, action: #selector(SignInPageViewController.googleSignUp(_:)))
        let twitterTap = UITapGestureRecognizer(target: self, action: #selector(SignInPageViewController.twitterSignUp(_:)))
        let igTap = UITapGestureRecognizer(target: self, action: #selector(SignInPageViewController.igSignUp(_:)))
        
        pageView.facebookLabel.addGestureRecognizer(fbTap)
        pageView.googleLabel.addGestureRecognizer(googleTap)
        pageView.twitterLabel.addGestureRecognizer(twitterTap)
        pageView.instagramLabel.addGestureRecognizer(igTap)
        
//        pageView.loginBigButton.addTarget(self, action: #selector(SignInPageViewController.signedUp(_:)), forControlEvents: .TouchUpInside)
//        pageView.textField2.secureTextEntry = true
        
//        pageView.textField1.returnKeyType = .Next
//        pageView.textField2.returnKeyType = .Next
//        pageView.textField3.returnKeyType = .Next
//        pageView.textField4.returnKeyType = .Done
        
//        pageView.textField1.tag = 0
//        pageView.textField2.tag = 1
//        pageView.textField3.tag = 2
//        pageView.textField4.tag = 3
        
//        pageView.textField1.delegate = self
//        pageView.textField2.delegate = self
//        pageView.textField3.delegate = self
//        pageView.textField4.delegate = self
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditProfileViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditProfileViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func facebookSignUp(_ sender: AnyObject) {
        
        social.facebookLogin()
        
    }
    
    func googleSignUp(_ sender: AnyObject) {
        
        social.googleLogin()
        
    }
    
    func twitterSignUp(_ sender: AnyObject) {
        
        social.twitterLogin()
        
    }
    
    func igSignUp(_ sender: AnyObject) {
        
//        social.googleLogin()
        
    }
    
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        
//        let nextTag = textField.tag+1;
//        // Try to find next responder
//        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
//        
//        if (nextResponder != nil){
//            // Found next responder, so set it.
//            nextResponder?.becomeFirstResponder()
//        }
//        else
//        {
//            // Not found, so remove keyboard
//            textField.resignFirstResponder()
//        }
//        return false // We do not want UITextField to insert line-breaks.
//    }
    
    func signedUp(_ sender: AnyObject) {
        
//        var isSuccess = false
//        var shouldNavigate = false
        
//        pageView.textField1.resignFirstResponder()
//        pageView.textField2.resignFirstResponder()
//        pageView.textField3.resignFirstResponder()
//        pageView.textField4.resignFirstResponder()
        
//        params["first"] = pageView.textField1.text
//        params["last"] = pageView.textField2.text
//        params["user"] = pageView.textField3.text
//        params["pass"] = pageView.textField4.text
        
//        let isEmail = validateEmail(pageView.textField1.text!)
//        
//        if pageView.textField1.text!.isEmpty {
//            
////            print("first name is empty")
//            let alertController = UIAlertController(title: "Error!", message: "Email cannot be blank", preferredStyle: .Alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(alertController, animated: true, completion: nil)
////            EXIT_SUCCESS
//        }
//        
//        else if pageView.textField2.text!.isEmpty {
//            
////            print("first name is empty")
//            let alertController = UIAlertController(title: "Error!", message: "Password cannot be blank", preferredStyle: .Alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(alertController, animated: true, completion: nil)
//            //            EXIT_SUCCESS
//        }
//        
////        else if pageView.textField3.text!.isEmpty {
////            
//////            print("first name is empty")
////            let alertController = UIAlertController(title: "Error!", message: "Email address cannot be blank", preferredStyle: .Alert)
////            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
////            presentViewController(alertController, animated: true, completion: nil)
////            //            EXIT_SUCCESS
////        }
//        
//        else if !isEmail {
//            
//            //            print("first name is empty")
//            let alertController = UIAlertController(title: "Error!", message: "Please Enter a valid Email Address", preferredStyle: .Alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(alertController, animated: true, completion: nil)
//            //            EXIT_SUCCESS
//        }
//        
////        else if pageView.textField4.text!.isEmpty {
////            
//////            print("first name is empty")
////            let alertController = UIAlertController(title: "Error!", message: "Password cannot be blank", preferredStyle: .Alert)
////            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
////            presentViewController(alertController, animated: true, completion: nil)
////            //            EXIT_SUCCESS
////        }
//        
//        else {
//            
//            isSuccess = true
//            
//        }
        
//        let verifyVC = storyboard?.instantiateViewControllerWithIdentifier("verifyZero") as! VerifyIntermediateViewController
        
//        if isSuccess {
//            
//            let nationalityVC = storyboard?.instantiateViewControllerWithIdentifier("SelectCountryVC") as! SelectCountryViewController
//            nationalityVC.whichView = "selectNationality"
//            self.navigationController?.pushViewController(nationalityVC, animated: true)
//            
////            navigation.signUpUser(pageView.textField1.text!, lastName: pageView.textField2.text!, username: pageView.textField3.text!, password: pageView.textField4.text!, completion: {(json:JSON) -> () in
////                
////                dispatch_async(dispatch_get_main_queue(),{
////                    
////                    print("response: \(json)")
////                    
////                    verifyVC.email = self.pageView.textField3.text!
////                    self.navigationController?.pushViewController(verifyVC, animated: true)
////                    print("print data: \(self.params)")
////                })
////                
////            })
//        }
        
//        if shouldNavigate {
//            
//            
//            
//        }
        
    }
    
//    func validateEmail(email: String) -> Bool {
//        
//        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
//        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(email)
//        
//    }
    
//    func keyboardWillShow(notification: NSNotification) {
//        
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
//            
//            if !keyboardUp {
//                
//                self.view.frame.origin.y -= keyboardSize.height
//                keyboardUp = true
//                
//            }
//            
//            
//        }
//        
//    }
    
//    func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
//            
//            if keyboardUp {
//                
//                self.view.frame.origin.y += keyboardSize.height
//                keyboardUp = false
//                
//            }
//            
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotoLogin(_ sender: UIButton) {
        
        let logInVC = storyboard?.instantiateViewController(withIdentifier: "logIn") as! LogInViewController
        self.navigationController?.pushViewController(logInVC, animated: true)
        
    }

}

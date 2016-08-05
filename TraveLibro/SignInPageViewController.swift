//
//  SignInPageViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignInPageViewController: UIViewController, UITextFieldDelegate {
    
    var keyboardUp = false
    var params = [String: String]()
    var pageView: SignInFullView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        
        self.customNavigationBar(leftButton, right: nil)
        
        pageView = SignInFullView(frame: CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: self.view.frame.size.height - 60))
        self.view.addSubview(pageView)
        
        pageView.signUpButton.addTarget(self, action: #selector(SignInPageViewController.signedUp(_:)), forControlEvents: .TouchUpInside)
        pageView.textField4.secureTextEntry = true
        
        pageView.textField1.returnKeyType = .Next
        pageView.textField2.returnKeyType = .Next
        pageView.textField3.returnKeyType = .Next
        pageView.textField4.returnKeyType = .Done
        
        pageView.textField1.tag = 0
        pageView.textField2.tag = 1
        pageView.textField3.tag = 2
        pageView.textField4.tag = 3
        
        pageView.textField1.delegate = self
        pageView.textField2.delegate = self
        pageView.textField3.delegate = self
        pageView.textField4.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditProfileViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditProfileViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let nextTag = textField.tag+1;
        // Try to find next responder
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        if (nextResponder != nil){
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        return false // We do not want UITextField to insert line-breaks.
    }
    
    func signedUp(sender: AnyObject) {
        
        var isSuccess = false
        var shouldNavigate = false
        
        pageView.textField1.resignFirstResponder()
        pageView.textField2.resignFirstResponder()
        pageView.textField3.resignFirstResponder()
        pageView.textField4.resignFirstResponder()
        
        params["first"] = pageView.textField1.text
        params["last"] = pageView.textField2.text
        params["user"] = pageView.textField3.text
        params["pass"] = pageView.textField4.text
        
        let isEmail = validateEmail(pageView.textField3.text!)
        
        if pageView.textField1.text!.isEmpty {
            
//            print("first name is empty")
            let alertController = UIAlertController(title: "Error!", message: "First Name cannot be blank", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
//            EXIT_SUCCESS
        }
        
        else if pageView.textField2.text!.isEmpty {
            
//            print("first name is empty")
            let alertController = UIAlertController(title: "Error!", message: "Last Name cannot be blank", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
            //            EXIT_SUCCESS
        }
        
        else if pageView.textField3.text!.isEmpty {
            
//            print("first name is empty")
            let alertController = UIAlertController(title: "Error!", message: "Email address cannot be blank", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
            //            EXIT_SUCCESS
        }
        
        else if !isEmail {
            
            //            print("first name is empty")
            let alertController = UIAlertController(title: "Error!", message: "Please Enter a valid Email Address", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
            //            EXIT_SUCCESS
        }
        
        else if pageView.textField4.text!.isEmpty {
            
//            print("first name is empty")
            let alertController = UIAlertController(title: "Error!", message: "Password cannot be blank", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
            //            EXIT_SUCCESS
        }
        
        else {
            
            isSuccess = true
            
        }
        
        
        if isSuccess {
            
            navigation.signUpUser(pageView.textField1.text!, lastName: pageView.textField2.text!, username: pageView.textField3.text!, password: pageView.textField4.text!, completion: {(json:JSON) -> () in
                
                print("response: \(json)")
                shouldNavigate = true
                
            })
            
            print("print data: \(params)")
        }
        
        if shouldNavigate {
            
            let verifyVC = storyboard?.instantiateViewControllerWithIdentifier("verifyOne") as! VerifyEmailViewController
            self.navigationController?.pushViewController(verifyVC, animated: true)
            
        }
        
    }
    
    func validateEmail(email: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(email)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            if !keyboardUp {
                
                self.view.frame.origin.y -= keyboardSize.height
                keyboardUp = true
                
            }
            
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            if keyboardUp {
                
                self.view.frame.origin.y += keyboardSize.height
                keyboardUp = false
                
            }
            
        }
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

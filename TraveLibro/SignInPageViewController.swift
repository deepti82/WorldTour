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
    var pageView: SignInFullView!
    let loader = LoadingOverlay()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)
        
        self.navigationController?.isNavigationBarHidden = false
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        self.customNavigationBar(left: leftButton, right: nil)
        
        pageView = SignInFullView()
        self.view.addSubview(pageView)
        
        pageView.loginButton.addTarget(self, action: #selector(SignInPageViewController.gotoLogin(_:)), for: .touchUpInside)
        pageView.facebookButton.addTarget(self, action: #selector(SignInPageViewController.facebookSignUp(_:)), for: .touchUpInside)
        pageView.googleButton.addTarget(self, action: #selector(SignInPageViewController.googleSignUp(_:)), for: .touchUpInside)
        
        pageView.termsAndConditionsButton.addTarget(self, action: #selector(SignInPageViewController.linksClicked(_:)), for: .touchUpInside)
        pageView.privacyPolicyButton.addTarget(self, action: #selector(SignInPageViewController.linksClicked(_:)), for: .touchUpInside)
        
        let fbTap = UITapGestureRecognizer(target: self, action: #selector(SignInPageViewController.facebookSignUp(_:)))
        let googleTap = UITapGestureRecognizer(target: self, action: #selector(SignInPageViewController.googleSignUp(_:)))       
        
        pageView.facebookLabel.addGestureRecognizer(fbTap)
        pageView.googleLabel.addGestureRecognizer(googleTap)        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAnalytics(name: "SignIn Page")
        NotificationCenter.default.addObserver(self, selector: #selector(self.userSocialLoginFailed(notification:)), name: NSNotification.Name(rawValue: "SOCIAL_LOGIN_FAILED"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.userChangeLoginFailed(notification:)), name: NSNotification.Name(rawValue: "USER_MIGRATE_FAILED"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.saveUserFailed(notification:)), name: NSNotification.Name(rawValue: "SAVE_USER_FAILED"), object: nil)
        setData()
        if shouldShowLoader {
            loader.showOverlay(self.view)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)        
        NotificationCenter.default.removeObserver(self)
        shouldShowLoader = false
        //loader.hideOverlayView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Set Data
    
    func setData() {
        print("\n LoggedInUser : \(loggedInUser)")
        
        if loggedInUser != nil {
            //Existing User
            
            self.title = "Login"
            
            pageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 0)
            
            pageView.profileImage.isHidden = false
            pageView.messageLabel.isHidden = false
            pageView.requestLabel.isHidden = false
            pageView.loginStack.isHidden = true
            pageView.autoMigrateLabel.isHidden = false
            pageView.tncView.isHidden = true
            
            pageView.googleLabel.text = "       Connect with Google+"
            pageView.facebookLabel.text = "       Connect with Facebook"
            
            let url = loggedInUser["profilePicture"].stringValue
            pageView.profileImage.hnk_setImageFromURL(NSURL(string: url)! as URL)
            let msg = getRegularStringWithColor(string: "Hi ", size: 14, color: UIColor.white)
            msg.append(getBoldStringWithColor(string: loggedInUser["name"].stringValue, size: 14, color: UIColor.white))
            msg.append(getRegularStringWithColor(string: ", we have updated the app for a quicker and faster log-in process.", size: 14, color: UIColor.white))
            pageView.messageLabel.attributedText = msg
        }
        else {
            //New User
            
            self.title = "Sign Up"
            
            pageView.frame = CGRect(x: 0, y: -84, width: self.view.frame.size.width, height: self.view.frame.size.height)
            
            pageView.profileImage.isHidden = true
            pageView.messageLabel.isHidden = true
            pageView.requestLabel.isHidden = true
            pageView.loginStack.isHidden = false
            pageView.autoMigrateLabel.isHidden = true
            pageView.tncView.isHidden = false
            
            pageView.googleLabel.text = "       Sign up via Google+"
            pageView.facebookLabel.text = "       Sign up via Facebook"
        }        
    }
    
    //MARK: - Button actions
    
    func facebookSignUp(_ sender: AnyObject) {        
        social.facebookLogin()
    }
    
    func googleSignUp(_ sender: AnyObject) {
        social.googleLogin()        
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
    
    
    
    func gotoLogin(_ sender: UIButton) {
        
        let logInVC = storyboard?.instantiateViewController(withIdentifier: "logIn") as! LogInViewController
        self.navigationController?.pushViewController(logInVC, animated: true)
        
    }
    
    func linksClicked(_ sender: UIButton) {
        let linksShowVC = storyboard?.instantiateViewController(withIdentifier: "EditSettings") as! EditSettingsViewController
        linksShowVC.whichView = (sender.tag == 34) ? "terms&conditions" : "privacyPolicy"
        self.navigationController?.pushViewController(linksShowVC, animated: true)
    }
    
    
    //MARK: - User Migrate failed
    
    func userChangeLoginFailed(notification : Notification) {
        print("\n user change login failed : \(String(describing: notification.object))")
        
        let errorAlert = UIAlertController(title: "Error", message: "Something went wrong. Please try after sometimes.", preferredStyle: UIAlertControllerStyle.alert)
        let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
            (result : UIAlertAction) -> Void in
        }            
        errorAlert.addAction(DestructiveAction)
        self.navigationController?.present(errorAlert, animated: true, completion: nil)
    }
    
    func userSocialLoginFailed(notification : Notification) {
        
        let errorAlert = UIAlertController(title: "Error", message: "Unable to login. Please check your profile public.", preferredStyle: UIAlertControllerStyle.alert)
        let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
            (result : UIAlertAction) -> Void in
        }            
        errorAlert.addAction(DestructiveAction)
        self.navigationController?.present(errorAlert, animated: true, completion: nil)
    }
    
    func saveUserFailed(notification: Notification)  {
        loader.hideOverlayView()
        let errorAlert = UIAlertController(title: "Error", message: "Something went wrong. Please try after sometime", preferredStyle: UIAlertControllerStyle.alert)
        let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
            (result : UIAlertAction) -> Void in
            //Cancel Action
        }            
        errorAlert.addAction(DestructiveAction)
        self.navigationController?.present(errorAlert, animated: true, completion: nil)
    }
    
}

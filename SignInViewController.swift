//
//  SignInViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftHTTP
import Player
import TwitterKit

var currentUser: JSON!
let social = SocialLoginClass()
var profileVC: ProfileViewController!
var nationalityPage: AddNationalityNewViewController!
var navigation: UINavigationController!
var signInVC: SignInViewController!


class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var videoScrollView: UIScrollView!
    @IBOutlet weak var ipTextField: UITextField!
    var player:Player!
    
    var videoHeight:CGFloat!
    var horizontal:HorizontalLayout!
//    var request = HTTPTask()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoHeight = videoScrollView.frame.height
        self.horizontal = HorizontalLayout(height: videoHeight)
        self.videoScrollView.addSubview(horizontal)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: videoHeight))
        imageView.image = UIImage(named:"logo-default")
        
        self.player = Player()
        self.player.delegate = self
        self.player.view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width)
        self.player.view.clipsToBounds = true
        self.player.playbackLoops = true
        self.player.muted = true
        self.player.fillMode = "AVLayerVideoGravityResizeAspectFill"
        self.videoContainer.player = self.player
        var videoUrl:URL!
        self.videoContainer.tagText.isHidden = true
        if(!post.post_isOffline) {
            videoUrl = URL(string: post.videoArr[0].serverUrl)
        } else {
            videoUrl = post.videoArr[0].imageUrl
        }
        self.player.setUrl(videoUrl!)
        self.videoContainer.videoHolder.addSubview(self.player.view)
        self.addSubview(self.videoContainer)
        
        self.horizontal.addSubview(imageView)
        
        
        let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: videoHeight))
        imageView1.image = UIImage(named:"logo-default")
        
        self.horizontal.addSubview(imageView1)
        
        
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: videoHeight))
        imageView2.image = UIImage(named:"logo-default")
        
        self.horizontal.addSubview(imageView2)
        addToLayout();
        
        getDarkBackGroundBlur(self)
        
        self.navigationController?.isNavigationBarHidden = true
        
        let signInFooter = SignInToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height - 140, width: self.view.frame.size.width, height: 140))
        self.view.addSubview(signInFooter)
        
        ipTextField.delegate = self
        ipTextField.returnKeyType = .done
        
        signInFooter.signUp.addTarget(self, action: #selector(SignInViewController.goToSignUp(_:)), for: .touchUpInside)
        signInFooter.signInButton.addTarget(self, action: #selector(SignInViewController.loginButtonTapped(_:)), for: .touchUpInside)
        signInFooter.googleButton.addTarget(self, action: #selector(SignInViewController.googleSignIn(_:)), for: .touchUpInside)
        signInFooter.fbButton.addTarget(self, action: #selector(SignInViewController.facebookSignIn(_:)), for: .touchUpInside)
        signInFooter.twitterButton.addTarget(self, action: #selector(SignInViewController.twitterSignIn(_:)), for: .touchUpInside)
        
        profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        
        nationalityPage = self.storyboard?.instantiateViewController(withIdentifier: "nationalityNew") as! AddNationalityNewViewController
        
        navigation = self.navigationController
        
    }
    
    func addToLayout() {
        self.horizontal.layoutSubviews()
        self.videoScrollView.contentSize = CGSize(width: self.horizontal.frame.width, height: self.horizontal.frame.height)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        ipTextField.resignFirstResponder()
        
        if ipTextField.text != nil && ipTextField.text != "" {
            
            adminUrl = "http://" + ipTextField.text! + "/api/"
            
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        ipTextField.resignFirstResponder()
        
        if ipTextField.text != nil && ipTextField.text != "" {
            
            adminUrl = "http://" + ipTextField.text! + "/api/"
            
        }
        return true
        
    }
   
    func googleSignIn(_ sender: UIButton) {
        
        print("google sign in")
        social.googleLogin()
        
    }
    
    func facebookSignIn(_ sender: UIButton) {
        
        print("facebook sign in")
        
//        Facebook.init()
        print("storyboard: \(self.storyboard)")
        social.facebookLogin()
    }
    
    func twitterSignIn(_ sender: UIButton) {
        
        print("storyboard: \(self.storyboard)")
        social.twitterLogin()
        
    }
    
    func goToSignUp(_ sender: AnyObject) {
        print("storyboard: \(self.navigationController)")
        let signUpFullVC = storyboard?.instantiateViewController(withIdentifier: "signUpTwo") as! SignInPageViewController
        self.navigationController?.pushViewController(signUpFullVC, animated: true)
        
    }
    
    func loginButtonTapped(_ sender: AnyObject) {
        
        let logInVC = storyboard?.instantiateViewController(withIdentifier: "logIn") as! LogInViewController
        self.navigationController?.pushViewController(logInVC, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

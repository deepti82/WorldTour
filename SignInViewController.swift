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


class SignInViewController: UIViewController, UITextFieldDelegate,PlayerDelegate {
    
    @IBOutlet weak var videoScrollView: UIScrollView!
    @IBOutlet weak var ipTextField: UITextField!
    var player1:Player!
    var player2:Player!
    var player3:Player!
    
    var videoHeight:CGFloat!
    var horizontal:HorizontalLayout!
//    var request = HTTPTask()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoHeight = videoScrollView.frame.height
        self.horizontal = HorizontalLayout(height: videoHeight)
        self.videoScrollView.addSubview(horizontal)
        
        let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: videoHeight))
        imageView1.image = UIImage(named:"logo-default")
        imageView1.contentMode = UIViewContentMode.center
        self.player1 = Player()
        self.player1.delegate = self
        self.player1.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: videoHeight)
        self.player1.view.clipsToBounds = true
        self.player1.playbackLoops = true
        self.player1.muted = true
        self.player1.fillMode = "AVLayerVideoGravityResizeAspect"
        self.player1.setUrl(URL(string: "https://storage.googleapis.com/intro-videos/travellife.mp4")!)
        imageView1.addSubview(self.player1.view)
        
        self.horizontal.addSubview(imageView1)
        
        
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: videoHeight))
        imageView2.image = UIImage(named:"logo-default")
        imageView2.contentMode = UIViewContentMode.center
        self.player2 = Player()
        self.player2.delegate = self
        self.player2.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: videoHeight)
        self.player2.view.clipsToBounds = true
        self.player2.playbackLoops = true
        self.player2.muted = true
        self.player2.fillMode = "AVLayerVideoGravityResizeAspect"
        self.player2.setUrl(URL(string: "https://storage.googleapis.com/intro-videos/locallife.mp4")!)
        imageView2.addSubview(self.player2.view)
        self.horizontal.addSubview(imageView2)
        
        
        let imageView3 = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: videoHeight))
        imageView3.image = UIImage(named:"logo-default")
        imageView3.contentMode = UIViewContentMode.center
        self.player3 = Player()
        self.player3.delegate = self
        self.player3.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: videoHeight)
        self.player3.view.clipsToBounds = true
        self.player3.playbackLoops = true
        self.player3.muted = true
        self.player3.fillMode = "AVLayerVideoGravityResizeAspect"
        self.player3.setUrl(URL(string: "https://storage.googleapis.com/intro-videos/mylife.mp4")!)
        imageView3.addSubview(self.player3.view)
        self.horizontal.addSubview(imageView3)
        
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
    
    func playerReady(_ player: Player) {
       player.playFromBeginning()
    }

}

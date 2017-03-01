import UIKit
import SwiftHTTP
import Player
import TwitterKit
import SwiftGifOrigin
import AVKit

var currentUser: JSON!
let social = SocialLoginClass()
var profileVC: ProfileViewController!
var nationalityPage: AddNationalityNewViewController!
var navigation: UINavigationController!
var signInVC: SignInViewController!


class SignInViewController: UIViewController, UITextFieldDelegate, PlayerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var videoScrollView: UIScrollView!
    @IBOutlet weak var ipTextField: UITextField!    
    
    var imageView1: UIImageView!
    var imageView2: UIImageView!
    var imageView3: UIImageView!
    
    var player1:Player!
    var player2:Player!
    var player3:Player!
    
    var videoHeight:CGFloat!
    var horizontal:HorizontalLayout!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadData() {
        
        let videoWidth = videoScrollView.frame.width
        videoHeight = screenHeight
        videoScrollView.delegate = self
        self.horizontal = HorizontalLayout(height: videoHeight)
        self.videoScrollView.addSubview(horizontal)
          
        
        imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: videoWidth, height: videoHeight))
        imageView1.backgroundColor = UIColor.white
        imageView1.image = UIImage.gif(name: "loader")
        imageView1.contentMode = UIViewContentMode.center
        imageView1.center = self.view.center
        
        self.player1 = Player()        
        self.player1.delegate = self
        self.player1.view.frame = CGRect(x: 0, y: 0, width: videoWidth, height: videoHeight)
        self.player1.view.clipsToBounds = true
        self.player1.playbackLoops = true
        self.player1.muted = true
        self.player1.fillMode = "AVLayerVideoGravityResizeAspectFill"
//        guard let path = Bundle.main.path(forResource: "travellife", ofType:"mp4") else {
//            debugPrint("travellife.mp4 not found")
//            return
//        }        
//        self.player1.setUrl(URL(string: path)!)        
        self.player1.setUrl(URL(string: "https://storage.googleapis.com/intro-videos/travellife.mp4")!)        
        imageView1.addSubview(self.player1.view)
        
        
        self.horizontal.addSubview(imageView1)
        
        
        imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: videoWidth, height: videoHeight))
        imageView2.image = UIImage.gif(name: "loader")
        imageView2.backgroundColor = UIColor.white
        imageView2.contentMode = UIViewContentMode.center
        imageView2.center = self.view.center
        self.player2 = Player()
        self.player2.delegate = self
        self.player2.view.frame = CGRect(x: 0, y: 0, width: videoWidth, height: videoHeight)
        self.player2.view.clipsToBounds = true
        self.player2.playbackLoops = true
        self.player2.muted = true        
        self.player2.fillMode = "AVLayerVideoGravityResizeAspectFill"
        self.player2.setUrl(URL(string: "https://storage.googleapis.com/intro-videos/locallife.mp4")!)
//        guard let path2 = Bundle.main.path(forResource: "locallife", ofType:"mp4") else {
//            debugPrint("locallife.mp4 not found")
//            return
//        }
//        print("\n \(URL(fileURLWithPath: path2))")
//        self.player2.setUrl(URL(fileURLWithPath: path2))
        imageView2.addSubview(self.player2.view)
        self.horizontal.addSubview(imageView2)
        
        
        imageView3 = UIImageView(frame: CGRect(x: 0, y: 0, width: videoWidth, height: videoHeight))
        imageView3.backgroundColor = UIColor.white
        imageView3.image = UIImage.gif(name: "loader")
        imageView3.contentMode = UIViewContentMode.center
        imageView3.center = self.view.center
        self.player3 = Player()
        self.player3.delegate = self
        self.player3.view.frame = CGRect(x: 0, y: 0, width: videoWidth, height: videoHeight)
        self.player3.view.clipsToBounds = true
        self.player3.playbackLoops = true
        self.player3.muted = true
        self.player3.fillMode = "AVLayerVideoGravityResizeAspectFill"
        self.player3.setUrl(URL(string: "https://storage.googleapis.com/intro-videos/mylife.mp4")!)
//        guard let path3 = Bundle.main.path(forResource: "mylife", ofType:"mp4") else {
//            debugPrint("mylife.mp4 not found")
//            return
//        }        
//        self.player2.setUrl(URL(string: path3)!)
        imageView3.addSubview(self.player3.view)
        self.horizontal.addSubview(imageView3)
        
        addToLayout();
        
        getDarkBackGroundBlur(self)
        
        self.navigationController?.isNavigationBarHidden = true
        
        videoToPlay()
        
        let signInFooter = SignInToolbar(frame: CGRect(x: 0 , y: self.view.frame.size.height - 140, width: 290, height: 140))
        signInFooter.center = CGPoint(x: self.view.center.x, y: signInFooter.center.y)
        self.view.addSubview(signInFooter)
        
        ipTextField.delegate = self
        ipTextField.returnKeyType = .done
        
        signInFooter.signUp.addTarget(self, action: #selector(SignInViewController.goToSignUp(_:)), for: .touchUpInside)
        signInFooter.signInButton.addTarget(self, action: #selector(SignInViewController.loginButtonTapped(_:)), for: .touchUpInside)
        signInFooter.googleButton.addTarget(self, action: #selector(SignInViewController.googleSignIn(_:)), for: .touchUpInside)
        signInFooter.fbButton.addTarget(self, action: #selector(SignInViewController.facebookSignIn(_:)), for: .touchUpInside)
        //        signInFooter.twitterButton.addTarget(self, action: #selector(SignInViewController.twitterSignIn(_:)), for: .touchUpInside)
        
        profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        
        nationalityPage = self.storyboard?.instantiateViewController(withIdentifier: "nationalityNew") as! AddNationalityNewViewController
        
        navigation = self.navigationController
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
    }
    
    func addToLayout() {
        self.horizontal.layoutSubviews()
        self.videoScrollView.contentSize = CGSize(width: self.horizontal.frame.width, height: self.horizontal.frame.height)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        social.googleLogin()
    }
    
    func facebookSignIn(_ sender: UIButton) {
        social.facebookLogin()
    }
    
    func twitterSignIn(_ sender: UIButton) {
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
    
    
    //MARK: - Player Delegates
    
    func playerReady(_ player: Player) {
        videoToPlay()
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
//        let pageNumber = round(videoScrollView.contentOffset.x / videoScrollView.frame.size.width)
//        print("\n Player ended : \(pageNumber)")
////        player.view.removeFromSuperview()
//        
//        let i = Int(pageNumber)        
//        switch(i) {
//            case 0:
//                let playBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
//                playBtn.backgroundColor = UIColor.red
//                playBtn.center = imageView1.center
//                playBtn.addTarget(self, action: #selector(self.playAgain), for: .touchUpInside)
//                playBtn.imageView?.image = UIImage(named: "video_play_icon")
//                imageView1.addSubview(playBtn)            
//            case 1:
//                let playBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
//                playBtn.backgroundColor = UIColor.red
//                playBtn.center = imageView2.center
//                playBtn.addTarget(self, action: #selector(self.playAgain), for: .touchUpInside)
//                playBtn.imageView?.image = UIImage(named: "video_play_icon")
//                imageView2.addSubview(playBtn) 
//            case 2:
//                let playBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
//                playBtn.backgroundColor = UIColor.red
//                playBtn.center = imageView3.center
//                playBtn.addTarget(self, action: #selector(self.playAgain), for: .touchUpInside)
//                playBtn.imageView?.image = UIImage(named: "video_play_icon")
//                imageView3.addSubview(playBtn) 
//            default: break
//        }
    }
    
    //MARK: - Play 
    
    func videoToPlay ()  {
        let pageNumber = round(videoScrollView.contentOffset.x / videoScrollView.frame.size.width)
        player1.stop()
        player2.stop()
        player3.stop()
        let i = Int(pageNumber)
        print("\n videoToPlay \(i)");
        switch(i) {
        case 0:
            print("\n player1: \(player1)")
            player1.playFromBeginning()
        case 1:
            print("\n player2 : \(player2.playbackState)")
            player2.playFromBeginning()
        case 2:
            player3.playFromBeginning()
        default: break
        }
    }
    
    func playAgain(){
        print("\n play Again")
        let pageNumber = round(videoScrollView.contentOffset.x / videoScrollView.frame.size.width)
        let i = Int(pageNumber)
        
        switch(i) {
            case 0:
                self.player1.setUrl(URL(string: "https://storage.googleapis.com/intro-videos/travellife.mp4")!)
                player1.playFromBeginning()
            case 1:
                self.player2.setUrl(URL(string: "https://storage.googleapis.com/intro-videos/locallife.mp4")!)
                player2.playFromBeginning()
            case 2:
                self.player3.setUrl(URL(string: "https://storage.googleapis.com/intro-videos/mylife.mp4")!)
                player3.playFromBeginning()
            default: break
        }
    }

    //MARK: - Scroll Delegates
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        videoToPlay()
    }
}

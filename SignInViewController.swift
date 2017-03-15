import UIKit
import SwiftHTTP
import Player
import TwitterKit
import SwiftGifOrigin
import AVKit
import TAPageControl

var currentUser: JSON!
var loggedInUser : JSON!
let social = SocialLoginClass()
var profileVC: ProfileViewController!
var nationalityPage: AddNationalityNewViewController!
var navigation: UINavigationController!
var signInVC: SignInViewController!

class SignInViewController: UIViewController, UITextFieldDelegate, PlayerDelegate, UIScrollViewDelegate {
    
    var defaultMute = false
    var showPage = 0
    var shouldShowNavBar = false
    
    @IBOutlet weak var videoScrollView: UIScrollView!
    @IBOutlet weak var ipTextField: UITextField!    
    var toggleSoundButton: UIButton!
    var playBtn: UIButton!
    var videoLabel: UILabel!
    
    var imageView1: UIImageView!
    var imageView2: UIImageView!
    var imageView3: UIImageView!
    
    var player1:Player!
    var player2:Player!
    var player3:Player!
    
    var pageControl = TAPageControl()
    
    var videoHeight:CGFloat!
    var horizontal:HorizontalLayout!
    
    var signInFooter: SignInToolbar!    
    var loader = LoadingOverlay()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        getDarkBackGroundBlur(self)        
        
        if shouldShowNavBar {
            
            let leftButton = UIButton()
            leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
            leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
            leftButton.frame = CGRect(x: 10, y: 20, width: 30, height: 30)
            leftButton.layer.shadowOffset = CGSize(width: 0, height: 0)
            leftButton.layer.shadowOpacity = 0.5
            leftButton.layer.shadowRadius = 5
            self.view.addSubview(leftButton)
        }
        
        videoLabel = UILabel(frame: CGRect(x: 0, y: 20, width: screenWidth, height: 30))
        videoLabel.textAlignment = .center
        videoLabel.backgroundColor = UIColor.clear
        videoLabel.textColor = UIColor.white
        videoLabel.font = NAVIGATION_FONT
        videoLabel.numberOfLines = 0
        videoLabel.lineBreakMode = .byWordWrapping
        videoLabel.shadowColor = UIColor.black
        videoLabel.shadowOffset = CGSize(width: 2, height: 2)
        videoLabel.layer.masksToBounds = true
        videoLabel.text = ""
        self.view.addSubview(videoLabel)
        
        
        pageControl = TAPageControl()
        pageControl.currentPage = showPage
        pageControl.numberOfPages = 3
        pageControl.contentMode = .center
        self.view.addSubview(pageControl)
        
        
        toggleSoundButton = UIButton()
        toggleSoundButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 32)        
        toggleSoundButton.setTitle(String(format: "%C",0xf028), for: UIControlState())
        toggleSoundButton.addTarget(self, action: #selector(SignInViewController.touchButtonTap(_:)), for: .touchUpInside)
        toggleSoundButton.backgroundColor = UIColor.clear
        toggleSoundButton.clipsToBounds = true
        toggleSoundButton.layer.cornerRadius = 5
        self.view.addSubview(toggleSoundButton)
        
        //play button [custumization]
        
        playBtn = UIButton()
        playBtn.backgroundColor = UIColor.clear
        playBtn.imageView?.tintColor = mainBlueColor
        playBtn.setTitle(String(format: "%C",0xf144), for: .normal)
        playBtn.titleLabel?.font = UIFont(name: "FontAwesome", size: 65)        
        playBtn.addTarget(self, action: #selector(self.playAgain), for: .touchUpInside)        
        self.view.addSubview(playBtn)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        playBtn.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
        
        UIView.animate(withDuration: 2) {
            switch self.showPage {
                
            case 0:
                self.videoScrollView.scrollRectToVisible(self.imageView1.frame, animated: true)
                
            case 1: 
                self.videoScrollView.scrollRectToVisible(self.imageView2.frame, animated: true)
                
            case 2:
                self.videoScrollView.scrollRectToVisible(self.imageView3.frame, animated: true)
                
            default:
                break
            }            
        }
        
        playBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 65)
        playBtn.center = imageView1.center
        
        videoToPlay()
    }   
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        showPage = pageControl.currentPage
        destroyViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadData() {
        
        let videoWidth = videoScrollView.frame.width
        videoHeight = screenHeight
        videoScrollView.delegate = self
        self.horizontal = HorizontalLayout(height: videoHeight)
        self.videoScrollView.addSubview(horizontal)
        
        imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: videoWidth, height: videoHeight))
        imageView1.backgroundColor = UIColor.clear
        imageView1.contentMode = UIViewContentMode.center
        imageView1.center = self.view.center
        
        self.player1 = Player()        
        self.player1.delegate = self
        self.player1.view.frame = CGRect(x: 0, y: 0, width: videoWidth, height: videoHeight)
        self.player1.view.clipsToBounds = true
        self.player1.playbackLoops = false
        self.player1.muted = defaultMute
        self.player1.fillMode = "AVLayerVideoGravityResizeAspectFill"
        self.player1.setUrl(NSURL(fileURLWithPath: (Bundle.main.path(forResource: "travellife", ofType:"mp4"))!) as URL)
        imageView1.addSubview(self.player1.view)
        self.horizontal.addSubview(imageView1)
        
        
        imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: videoWidth, height: videoHeight))
        imageView2.backgroundColor = UIColor.clear
        imageView2.contentMode = UIViewContentMode.center
        imageView2.center = self.view.center
        self.player2 = Player()
        self.player2.delegate = self
        self.player2.view.frame = CGRect(x: 0, y: 0, width: videoWidth, height: videoHeight)
        self.player2.view.clipsToBounds = true
        self.player2.playbackLoops = false
        self.player2.muted = defaultMute        
        self.player2.fillMode = "AVLayerVideoGravityResizeAspectFill"              
        self.player2.setUrl(NSURL(fileURLWithPath: (Bundle.main.path(forResource: "locallife", ofType:"mp4"))!) as URL)
        imageView2.addSubview(self.player2.view)
        self.horizontal.addSubview(imageView2)
        
        
        imageView3 = UIImageView(frame: CGRect(x: 0, y: 0, width: videoWidth, height: videoHeight))
        imageView3.backgroundColor = UIColor.clear
        imageView3.contentMode = UIViewContentMode.center
        imageView3.center = self.view.center
        self.player3 = Player()
        self.player3.delegate = self
        self.player3.view.frame = CGRect(x: 0, y: 0, width: videoWidth, height: videoHeight)
        self.player3.view.clipsToBounds = true
        self.player3.playbackLoops = false
        self.player3.muted = defaultMute
        self.player3.fillMode = "AVLayerVideoGravityResizeAspectFill"              
        self.player3.setUrl(NSURL(fileURLWithPath: (Bundle.main.path(forResource: "mylife", ofType:"mp4"))!) as URL)
        imageView3.addSubview(self.player3.view)
        self.horizontal.addSubview(imageView3)
        
        addToLayout()        
        
        signInFooter = SignInToolbar(frame: CGRect(x: 0 , y: screenHeight - 80, width: screenWidth, height: 80))
        signInFooter.center = CGPoint(x: self.view.center.x, y: signInFooter.center.y)
        self.view.addSubview(signInFooter)
        
        ipTextField.delegate = self
        ipTextField.returnKeyType = .done
        
        signInFooter.signUp.addTarget(self, action: #selector(SignInViewController.goToSignUp(_:)), for: .touchUpInside)
        signInFooter.signInButton.addTarget(self, action: #selector(SignInViewController.loginButtonTapped(_:)), for: .touchUpInside)
        
        pageControl.frame = CGRect(x: self.view.center.x, y: signInFooter.frame.origin.y - 15, width: 60, height: 30)
        
        toggleSoundButton.frame = CGRect(x: self.view.frame.maxX - 60, y: signInFooter.frame.origin.y - 60, width: 40, height: 32)
        
        profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        
        nationalityPage = self.storyboard?.instantiateViewController(withIdentifier: "nationalityNew") as! AddNationalityNewViewController
        
        navigation = self.navigationController
    }
    
    func destroyViews() {
        
//        player1.stop()
//        player2.stop()
//        player3.stop()
        
        player1.view.removeFromSuperview()
        player2.view.removeFromSuperview()
        player3.view.removeFromSuperview()
        
        player1 = nil
        player2 = nil
        player3 = nil
        
        imageView1.removeFromSuperview()
        imageView2.removeFromSuperview()
        imageView3.removeFromSuperview()
        
        imageView1 = nil
        imageView2 = nil
        imageView3 = nil
    }
    
    func addToLayout() {
        self.horizontal.layoutSubviews()
        self.videoScrollView.contentSize = CGSize(width: self.horizontal.frame.width, height: self.horizontal.frame.height)
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
    
    
    //MARK: - Button Actions
    
    func goToSignUp(_ sender: AnyObject) {
        print("storyboard: \(self.navigationController)")
        loggedInUser = nil
        let signUpFullVC = storyboard?.instantiateViewController(withIdentifier: "signUpTwo") as! SignInPageViewController
        self.navigationController?.pushViewController(signUpFullVC, animated: true)
    }
    
    func loginButtonTapped(_ sender: AnyObject) {
        let logInVC = storyboard?.instantiateViewController(withIdentifier: "logIn") as! LogInViewController
        self.navigationController?.pushViewController(logInVC, animated: true)
    }
    
    
    //MARK: - Player Delegates
    
    func playerReady(_ player: Player) {
        loader.hideOverlayView()
        videoToPlay()
    }
   
    func playerPlaybackDidEnd(_ player: Player) {
        
        if playBtn != nil {
            let pageNumber = round(videoScrollView.contentOffset.x / videoScrollView.frame.size.width)
            
            let i = Int(pageNumber)
            switch(i) {
            case 0:
                if player1.playbackState == PlaybackState.stopped {
                    playBtn.titleLabel?.textColor = mainOrangeColor
                    playBtn.isHidden = false
                }
                
            case 1:
                if player2.playbackState == PlaybackState.stopped {
                    playBtn.titleLabel?.textColor = mainGreenColor
                    playBtn.isHidden = false
                }
                
            case 2:
                if player3.playbackState == PlaybackState.stopped {
                    playBtn.titleLabel?.textColor = UIColor.white
                    playBtn.isHidden = false
                }
                
            default: break
            }
        }        
    }

    
    //MARK: - Play 
    
    func videoToPlay ()  {
        
        let pageNumber = round(videoScrollView.contentOffset.x / videoScrollView.frame.size.width)
        
        let i = Int(pageNumber)
        pageControl.currentPage = i
        
        switch(i) {
        case 0:   
            videoLabel.text = "Travel Life"
            player1.playFromBeginning()
            
        case 1:  
            videoLabel.text = "Local Life"
            player2.playFromBeginning()
            
        case 2:   
            videoLabel.text = "My Life"
            player3.playFromBeginning()
            
        default: break
        }
    }
    
    func playAgain(){
        
        loader.showOverlay(self.view)
        
        playBtn.isHidden = true
        
        if isConnectedToNetwork() {
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
        else{
            loader.hideOverlayView()
            let errorAlert = UIAlertController(title: "Error", message: "Please check your internet connection", preferredStyle: UIAlertControllerStyle.alert)
            let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
                (result : UIAlertAction) -> Void in
                //Cancel Action
            }            
            errorAlert.addAction(DestructiveAction)
            self.navigationController?.present(errorAlert, animated: true, completion: nil)
        }       
    }

    //MARK: - Scroll Delegates
    
//    @IBAction func toggleSoundtap(_ sender: UIButton) {
    func touchButtonTap(_ sender: UIButton){
        
        if(defaultMute) {
            defaultMute = false
            toggleSoundButton.setTitle(String(format: "%C",0xf028), for: UIControlState())            
        }
        else {
            defaultMute = true
            toggleSoundButton.setTitle(String(format: "%C",0xf026) + "⨯", for: UIControlState())
        }
        
        player1.muted = defaultMute
        player2.muted = defaultMute
        player3.muted = defaultMute
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        playBtn.isHidden = true
        videoToPlay()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.player1.setUrl(NSURL(fileURLWithPath: (Bundle.main.path(forResource: "travellife", ofType:"mp4"))!) as URL)
        self.player2.setUrl(NSURL(fileURLWithPath: (Bundle.main.path(forResource: "locallife", ofType:"mp4"))!) as URL)
        self.player3.setUrl(NSURL(fileURLWithPath: (Bundle.main.path(forResource: "mylife", ofType:"mp4"))!) as URL)
    }

}

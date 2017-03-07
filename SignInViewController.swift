import UIKit
import SwiftHTTP
import Player
import TwitterKit
import SwiftGifOrigin
import AVKit

var currentUser: JSON!
var loggedInUser : JSON!
let social = SocialLoginClass()
var profileVC: ProfileViewController!
var nationalityPage: AddNationalityNewViewController!
var navigation: UINavigationController!
var signInVC: SignInViewController!
//var localLifeText: NSMutableAttributedString!
//var travelLifeText: NSMutableAttributedString!
//var myLifeText: NSMutableAttributedString!

class SignInViewController: UIViewController, UITextFieldDelegate, PlayerDelegate, UIScrollViewDelegate {
    var defaultMute = true
    var showPage = 0
    var shouldShowNavBar = false
    
    
    @IBOutlet weak var toggleSound: UIButton!
    @IBOutlet weak var videoScrollView: UIScrollView!
    @IBOutlet weak var ipTextField: UITextField!    
    
    var playBtn: UIButton!
    var videoLabel: UILabel!
    
    var imageView1: UIImageView!
    var imageView2: UIImageView!
    var imageView3: UIImageView!
    
    var player1:Player!
    var player2:Player!
    var player3:Player!
    
    var pageControl = UIPageControl()
    
    var videoHeight:CGFloat!
    var horizontal:HorizontalLayout!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toggleSound.setTitle(String(format: "%C",0xf026) + "⨯", for: UIControlState())
        toggleSound.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        toggleSound.clipsToBounds = true
        toggleSound.layer.cornerRadius = 5
        
       
        getDarkBackGroundBlur(self)
        
//        travelLifeText = getColorString(string: "TRAVEL\n", font: NAVIGATION_FONT!, color: mainOrangeColor)
//        travelLifeText.append(addImage(imageName: "travel_life"))
//        travelLifeText.append(getColorString(string: " LIFE ", font: NAVIGATION_FONT!, color: UIColor.white))
//        
//        localLifeText = getColorString(string: "LOCAL\n", font: NAVIGATION_FONT!, color: mainGreenColor)
//        localLifeText.append(addImage(imageName: "local_life"))
//        localLifeText.append(getColorString(string: " LIFE ", font: NAVIGATION_FONT!, color: UIColor.white))
//        
//        myLifeText = getColorString(string: "MY\n", font: NAVIGATION_FONT!, color: mainOrangeColor)
//        myLifeText.append(addImage(imageName: "travel_life"))
//        myLifeText.append(getColorString(string: " LIFE ", font: NAVIGATION_FONT!, color: UIColor.white))
        
        if shouldShowNavBar {
            
            let leftButton = UIButton()
            leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
            leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
            leftButton.frame = CGRect(x: 10, y: 20, width: 30, height: 30)
            leftButton.layer.shadowOffset = CGSize(width: 0, height: 0)
            leftButton.layer.shadowOpacity = 0.5
            leftButton.layer.shadowRadius = 5
            self.view.addSubview(leftButton)
            
            videoLabel = UILabel(frame: CGRect(x: 0, y: 20, width: screenWidth, height: 30))
            videoLabel.textAlignment = .center
            videoLabel.backgroundColor = UIColor.clear
            videoLabel.textColor = UIColor.white
            videoLabel.font = NAVIGATION_FONT
            videoLabel.numberOfLines = 0
            videoLabel.lineBreakMode = .byWordWrapping
            videoLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
            videoLabel.layer.shadowOpacity = 1
            videoLabel.layer.shadowRadius = 10
            videoLabel.text = ""
            self.view.addSubview(videoLabel)
            
            self.title = "Travel"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
        
        switch showPage {
        case 0:
            videoScrollView.scrollRectToVisible(imageView1.frame, animated: true)
            
        case 1: 
            videoScrollView.scrollRectToVisible(imageView2.frame, animated: true)
            
        case 2:
            videoScrollView.scrollRectToVisible(imageView3.frame, animated: true)
            
        default:
            break
        }
        
                
        //Add play button [custumization]
        
        playBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 65))
        playBtn.backgroundColor = UIColor.clear
        playBtn.center = imageView1.center
        playBtn.imageView?.tintColor = mainBlueColor
        playBtn.setImage(UIImage(named: "video_play_icon"), for: .normal)
        playBtn.addTarget(self, action: #selector(self.playAgain), for: .touchUpInside)
        
        playBtn.isHidden = true
        self.view.addSubview(playBtn)
        
//        toggleSoundButton = UIButton(frame)
        
        videoToPlay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        
        let videoWidth = videoScrollView.frame.width
        videoHeight = screenHeight
        videoScrollView.delegate = self
        self.horizontal = HorizontalLayout(height: videoHeight)
        self.videoScrollView.addSubview(horizontal)
        
        imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: videoWidth, height: videoHeight))
        imageView1.backgroundColor = UIColor.clear
        imageView1.image = UIImage.gif(name: "loader")
        imageView1.contentMode = UIViewContentMode.center
        imageView1.center = self.view.center
        
        self.player1 = Player()        
        self.player1.delegate = self
        self.player1.view.frame = CGRect(x: 0, y: 0, width: videoWidth, height: videoHeight)
        self.player1.view.clipsToBounds = true
        self.player1.playbackLoops = false
        self.player1.muted = true
        self.player1.fillMode = "AVLayerVideoGravityResizeAspectFill"
//        self.player1.playFromBeginning()        
        let path = Bundle.main.path(forResource: "travellife", ofType:"mp4")       
        self.player1.setUrl(NSURL(fileURLWithPath: path!) as URL)
        imageView1.addSubview(self.player1.view)
         videoScrollView.bringSubview(toFront: toggleSound)
        self.horizontal.addSubview(imageView1)
        
        
        imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: videoWidth, height: videoHeight))
        imageView2.image = UIImage.gif(name: "loader")
        imageView2.backgroundColor = UIColor.clear
        imageView2.contentMode = UIViewContentMode.center
        imageView2.center = self.view.center
        self.player2 = Player()
        self.player2.delegate = self
        self.player2.view.frame = CGRect(x: 0, y: 0, width: videoWidth, height: videoHeight)
        self.player2.view.clipsToBounds = true
        self.player2.playbackLoops = false
        self.player2.muted = true        
        self.player2.fillMode = "AVLayerVideoGravityResizeAspectFill"
        let path2 = Bundle.main.path(forResource: "locallife", ofType:"mp4")       
        self.player2.setUrl(NSURL(fileURLWithPath: path2!) as URL)
        imageView2.addSubview(self.player2.view)
        self.horizontal.addSubview(imageView2)
        
        
        imageView3 = UIImageView(frame: CGRect(x: 0, y: 0, width: videoWidth, height: videoHeight))
        imageView3.backgroundColor = UIColor.clear
        imageView3.image = UIImage.gif(name: "loader")
        imageView3.contentMode = UIViewContentMode.center
        imageView3.center = self.view.center
        self.player3 = Player()
        self.player3.delegate = self
        self.player3.view.frame = CGRect(x: 0, y: 0, width: videoWidth, height: videoHeight)
        self.player3.view.clipsToBounds = true
        self.player3.playbackLoops = false
        self.player3.muted = true
        self.player3.fillMode = "AVLayerVideoGravityResizeAspectFill"
        let path3 = Bundle.main.path(forResource: "mylife", ofType:"mp4")       
        self.player3.setUrl(NSURL(fileURLWithPath: path3!) as URL)
        imageView3.addSubview(self.player3.view)
        self.horizontal.addSubview(imageView3)
        
        addToLayout();
        
        let signInFooter = SignInToolbar(frame: CGRect(x: 0 , y: screenHeight - 80, width: screenWidth, height: 80))
        signInFooter.center = CGPoint(x: self.view.center.x, y: signInFooter.center.y)
        self.view.addSubview(signInFooter)
        
        ipTextField.delegate = self
        ipTextField.returnKeyType = .done
        
        signInFooter.signUp.addTarget(self, action: #selector(SignInViewController.goToSignUp(_:)), for: .touchUpInside)
        signInFooter.signInButton.addTarget(self, action: #selector(SignInViewController.loginButtonTapped(_:)), for: .touchUpInside)
        
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: signInFooter.frame.origin.y - 30, width: screenWidth, height: 30))
        pageControl.currentPage = showPage
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.darkGray
        pageControl.numberOfPages = 3
        self.view.addSubview(pageControl)
            
        
        profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        
        nationalityPage = self.storyboard?.instantiateViewController(withIdentifier: "nationalityNew") as! AddNationalityNewViewController
        
        navigation = self.navigationController
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
        let signUpFullVC = storyboard?.instantiateViewController(withIdentifier: "signUpTwo") as! SignInPageViewController
        self.navigationController?.pushViewController(signUpFullVC, animated: true)
    }
    
    func loginButtonTapped(_ sender: AnyObject) {
        let logInVC = storyboard?.instantiateViewController(withIdentifier: "logIn") as! LogInViewController
        self.navigationController?.pushViewController(logInVC, animated: true)
    }
    
    //MARK: - Player Delegates
    
    func playerReady(_ player: Player) {
        print("\n Player ready called")
        videoToPlay()
    }
    
   
    func playerPlaybackDidEnd(_ player: Player) {
        
        if playBtn != nil {
            let pageNumber = round(videoScrollView.contentOffset.x / videoScrollView.frame.size.width)
            print("Player ended : \(pageNumber)")
            
            let i = Int(pageNumber)
            switch(i) {
            case 0:
                if player1.playbackState == PlaybackState.stopped {
                    playBtn.isHidden = false
                }
                
            case 1:
                if player2.playbackState == PlaybackState.stopped {                    
                    playBtn.isHidden = false
                }
                
            case 2:
                if player3.playbackState == PlaybackState.stopped {
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
        print("\n videoToPlay \(i)");
        switch(i) {
        case 0:
//            videoLabel.attributedText = travelLifeText   
            videoLabel.text = "TRAVEL LIFE"
            player1.playFromBeginning()
        case 1:
//            videoLabel.attributedText = localLifeText  
            videoLabel.text = "LOCAL LIFE"
            player2.playFromBeginning()
        case 2:
//            videoLabel.attributedText = myLifeText   
            videoLabel.text = "MY LIFE"
            player3.playFromBeginning()
        default: break
        }
    }
    
    func playAgain(){
        
        playBtn.isHidden = true
        
        let pageNumber = round(videoScrollView.contentOffset.x / videoScrollView.frame.size.width)
        let i = Int(pageNumber)
        
        switch(i) {
            case 0:
                self.player1.setUrl(URL(string: "https://www.youtube.com/watch?v=90BSVKX9YwI")!)
                player1.playFromBeginning()
            case 1:
                self.player2.setUrl(URL(string: "https://www.youtube.com/watch?v=Efb7c3NonKE")!)
                player2.playFromBeginning()
            case 2:
                self.player3.setUrl(URL(string: "https://www.youtube.com/watch?v=5_GTrAZ2mow")!)
                player3.playFromBeginning()
            default: break
        }
    }

    //MARK: - Scroll Delegates
    
    @IBAction func toggleSoundtap(_ sender: UIButton) {
        
        if(defaultMute) {
            defaultMute = false;
            player1.muted = defaultMute
            toggleSound.setTitle(String(format: "%C",0xf028), for: UIControlState())
        } else {
            defaultMute = true;
            player1.muted = defaultMute
            toggleSound.setTitle(String(format: "%C",0xf026) + "⨯", for: UIControlState())
        }
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        playBtn.isHidden = true
        videoToPlay()
    }
}

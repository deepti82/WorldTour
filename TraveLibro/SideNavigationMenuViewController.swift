import UIKit
import SABlurImageView
var initialLogin = true

class SideNavigationMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var imageName = ""
    
    var profile:ProfilePicFancy! = ProfilePicFancy() 
    
    var mainViewController: UIViewController!
    var homeController:UIViewController!
    var popJourneysController:UIViewController!
    var exploreDestinationsController:UIViewController!
    var popBloggersController:UIViewController!
    var blogsController:UIViewController!
    var inviteFriendsController:UIViewController!
    var rateUsController:UIViewController!
    var feedbackController:UIViewController!
    var loginViewController:UIViewController!
    var settingsViewController: UIViewController!
    var localLifeController: UIViewController!
    var myProfileViewController: UIViewController!
    var signOutViewController: UIViewController!
    
    let labels = ["Popular Journeys", "Popular Itinerary", "Popular Bloggers", "Blogs", "Invite Friends", "Rate Us", "Feedback", "Log Out", "Local Life", "My Profile"]
    
    @IBOutlet weak var profileViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var userBadgeLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var backgroundImage: SABlurImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileNew: UIView!
   
    @IBAction func SettingsTap(_ sender: AnyObject) {
        if currentUser != nil {
            self.slideMenuController()?.changeMainViewController(self.settingsViewController, close: true)
        }            
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginLabel.isHidden = true
        backgroundImage!.addBlurEffect(30, times: 1)

        
//        let bgImage = UIImageView(frame:self.view.frame)
//        bgImage.image = UIImage(named: "darkBgNew")
//        bgImage.layer.zPosition = -1
//        bgImage.isUserInteractionEnabled = false
//        self.view.addSubview(bgImage)
//        self.view.sendSubview(toBack: bgImage)        

        NotificationCenter.default.addObserver(self, selector: #selector(updateProfilePicture), name: NSNotification.Name(rawValue: "currentUserUpdated"), object: nil)
        
        profile = ProfilePicFancy(frame: CGRect(x: 0, y: 0, width: profileNew.frame.width, height: profileNew.frame.height))
        profileNew.addSubview(profile)
        profile.waves.isHidden = true
        makeSideNavigation(profile.image)

        updateProfilePicture()
        
        let settingsVC = storyboard!.instantiateViewController(withIdentifier: "UserProfileSettings") as! UserProfileSettingsViewController
        self.settingsViewController = UINavigationController(rootViewController: settingsVC)
        
        let homeController = storyboard!.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        self.homeController = UINavigationController(rootViewController: homeController)
        
        let PJController = storyboard!.instantiateViewController(withIdentifier: "activityFeeds") as! ActivityFeedsController
        PJController.displayData = "popular"
        self.popJourneysController = UINavigationController(rootViewController: PJController)
        
        let EDController = storyboard!.instantiateViewController(withIdentifier: "activityFeeds") as! ActivityFeedsController
        EDController.displayData = "popitinerary"
        self.exploreDestinationsController = UINavigationController(rootViewController: EDController)
        
        let PBController = storyboard!.instantiateViewController(withIdentifier: "popularBloggers") as! PopularBloggersViewController
        self.popBloggersController = UINavigationController(rootViewController: PBController)
        
        let BlogsController = storyboard!.instantiateViewController(withIdentifier: "blogsList") as! BlogsListViewController
        self.blogsController = UINavigationController(rootViewController: BlogsController)
        
        let inviteController = storyboard!.instantiateViewController(withIdentifier: "inviteFriends") as! InviteFriendsViewController
        self.inviteFriendsController = UINavigationController(rootViewController: inviteController)
        
        let rateUsController = storyboard!.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        self.rateUsController = UINavigationController(rootViewController: rateUsController)
        
        let FBController = storyboard!.instantiateViewController(withIdentifier: "FeedbackVC") as! FeedbackViewController
        self.feedbackController = UINavigationController(rootViewController: FBController)
        
        let loginController = storyboard!.instantiateViewController(withIdentifier: "SignUpOne") as! SignInViewController
        self.loginViewController = UINavigationController(rootViewController: loginController)
        
        let localLifeController = storyboard!.instantiateViewController(withIdentifier: "localLife") as! LocalLifeRecommendationViewController
        self.localLifeController = UINavigationController(rootViewController: localLifeController)
        
        let myProfileController = storyboard!.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        self.myProfileViewController = UINavigationController(rootViewController: myProfileController)
        
        let signoutView = self.storyboard?.instantiateViewController(withIdentifier: "SignUpOne") as! SignInViewController
        self.signOutViewController =  UINavigationController(rootViewController: signoutView)
        
        self.mainViewController = UINavigationController(rootViewController: homeController)
   }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentUser != nil {
//            profileViewHeightConstraint.constant = 207
            settingsButton.isHidden = false
            profileName.isHidden = false
            userBadgeLabel.isHidden = false
        }
        else {
//            profileViewHeightConstraint.constant = 165
            settingsButton.isHidden = true
            profileName.isHidden = true
            userBadgeLabel.isHidden = true
        }
    }   
    
    func updateProfilePicture() {
        if currentUser != nil {            
            profileName.text = currentUser["name"].stringValue
            imageName = currentUser["profilePicture"].stringValue
            let isUrl = verifyUrl(imageName)
            if (isUrl) {
                profilePicture.hnk_setImageFromURL(URL(string:imageName)!)
                profile.image.hnk_setImageFromURL(URL(string:imageName)!)
            } else {
                let getImageUrl = URL(string:adminUrl + "upload/readFile?file=" + imageName + "&width=500")
                profilePicture.hnk_setImageFromURL(getImageUrl!)
                profile.image.hnk_setImageFromURL(getImageUrl!)
            }
            makeTLProfilePicture(profilePicture)
        }        
    }
    
    @IBAction func profileTap(_ sender: AnyObject) {
        if currentUser != nil {
            self.slideMenuController()?.changeMainViewController(self.myProfileViewController, close: true)            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SideMenuTableViewCell
        cell.menuLabel.text = labels[(indexPath as NSIndexPath).item]
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return labels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! SideMenuTableViewCell
//        cell.backgroundColor = mainBlueColor
        cell.menuLabel.textColor = mainGreenColor
        
        switch((indexPath as NSIndexPath).row)
        {
        case 0:
            self.slideMenuController()?.changeMainViewController(self.popJourneysController, close: true)
        case 1:
            self.slideMenuController()?.changeMainViewController(self.exploreDestinationsController, close: true)
        case 2:
            self.slideMenuController()?.changeMainViewController(self.popBloggersController, close: true)
        case 3:
            self.slideMenuController()?.changeMainViewController(self.blogsController, close: true)
        case 4:
            self.slideMenuController()?.changeMainViewController(self.inviteFriendsController, close: true)
        case 5:
            self.slideMenuController()?.changeMainViewController(self.rateUsController, close: true)
        case 6:
            self.slideMenuController()?.changeMainViewController(self.feedbackController, close: true)
        case 7:
            user.dropTable()
            
            self.slideMenuController()?.changeMainViewController(self.signOutViewController, close: true)
        case 8:
            self.slideMenuController()?.changeMainViewController(self.localLifeController, close: true)
        default:
            self.slideMenuController()?.changeMainViewController(self.homeController, close: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! SideMenuTableViewCell
//        cell.backgroundColor = mainGreenColor
        cell.menuLabel.textColor = mainBlueColor
        
    }

}

class SideMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuLabel: UILabel!
    
    
}

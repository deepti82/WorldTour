import UIKit
import SABlurImageView
var initialLogin = true

class SideNavigationMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var imageName = ""
    
    var profile:profilePicNavigation! = profilePicNavigation()
    
    var mainViewController: UIViewController!
    var homeController:UIViewController!
    var popJourneysController:UIViewController!
    var exploreDestinationsController:UIViewController!
    var popBloggersController:UIViewController!
    var blogsController:UIViewController!
    var inviteFriendsController:UIViewController!
    var rateUsController:UIViewController!
    var feedbackController:UIViewController!
    var settingsViewController: UIViewController!
    var localLifeController: UIViewController!
    var myProfileViewController: UIViewController!
    var signOutViewController: UIViewController!
    var signInViewController: SignInViewController!
    
    let labels = ["Popular Journeys", "Popular Itinerary", "Popular Bloggers", "Invite Friends", "Rate Us", "Feedback", "Log Out"]
    
    @IBOutlet weak var profileViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var myLifeDropShadow: UILabel!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var starstack: UIStackView!
    @IBOutlet weak var sideTableView: UITableView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var userBadgeLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
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

        profileName.shadowColor = UIColor.black
        profileName.shadowOffset = CGSize(width: 2, height: 2)
        profileName.layer.masksToBounds = true

        
        myLifeDropShadow.shadowColor = UIColor.black
        myLifeDropShadow.shadowOffset = CGSize(width: 2, height: 2)
        myLifeDropShadow.layer.masksToBounds = true
        


        NotificationCenter.default.addObserver(self, selector: #selector(updateProfilePicture), name: NSNotification.Name(rawValue: "currentUserUpdated"), object: nil)
        
        profile = profilePicNavigation(frame: CGRect(x: 0, y: 0, width: profileNew.frame.width, height: profileNew.frame.height))
        profileNew.addSubview(profile)
        makeSideNavigation(profile.image)

        makeMenuProfilePicture(profile.image)
        
        profile.image.frame.size.height = 116
        profile.image.frame.size.width = 110
        
        profile.flag.frame.size.height = 25
        profile.flag.frame.size.width = 32
        
        sideTableView.tableFooterView = UIView(frame: CGRect.zero)
        updateProfilePicture()
        
        let settingsVC = storyboard!.instantiateViewController(withIdentifier: "UserProfileSettings") as! UserProfileSettingsViewController
        self.settingsViewController = UINavigationController(rootViewController: settingsVC)
        
        let homeController = storyboard!.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        self.homeController = UINavigationController(rootViewController: homeController)
        
        let PJController = storyboard!.instantiateViewController(withIdentifier: "popular") as! PopularController
        PJController.displayData = "popular"
        self.popJourneysController = UINavigationController(rootViewController: PJController)
        
        let EDController = storyboard!.instantiateViewController(withIdentifier: "popular") as! PopularController
        
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
        
        let localLifeController = storyboard!.instantiateViewController(withIdentifier: "localLife") as! LocalLifeRecommendationViewController
        self.localLifeController = UINavigationController(rootViewController: localLifeController)
        
        let myProfileController = storyboard!.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        self.myProfileViewController = UINavigationController(rootViewController: myProfileController)
        
        let signoutView = self.storyboard?.instantiateViewController(withIdentifier: "SignUpOne") as! SignInViewController
        signoutView.shouldShowNavBar = false
        self.signOutViewController =  UINavigationController(rootViewController: signoutView)
        
        self.signInViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpOne") as! SignInViewController
        signInViewController.shouldShowNavBar = true
//        self.signInViewController =  UINavigationController(rootViewController: signInView)
        
        self.mainViewController = UINavigationController(rootViewController: homeController)
   }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sideTableView.reloadData()
//        
//        if currentUser != nil {            
//            userBadgeLabel.isHidden = false
//        }
//        else {            
//            profileName.text = "Login / Sign up"
//            userBadgeLabel.isHidden = true
//        }
    }   
    
    func updateProfilePicture() {
        if currentUser != nil {
            starstack.isHidden = false
            profile.flag.isHidden = false
            profileName.text = currentUser["name"].stringValue
            imageName = currentUser["profilePicture"].stringValue
            loginLabel.isHidden = true
            profileName.isHidden = false
            if currentUser["userBadgeName"].string == "newbie"{
            star1.image = UIImage(named: "star_check")
            star1.tintColor  = UIColor.white
            }else if currentUser["userBadgeName"].string == "justGotWings"{
                star1.image = UIImage(named: "star_check")
                star1.tintColor  = UIColor.white
                star2.image = UIImage(named: "star_check")
                star2.tintColor  = UIColor.white
            } else if currentUser["userBadgeName"].string == "globeTrotter"{
                star1.image = UIImage(named: "star_check")
                star1.tintColor  = UIColor.white
                star2.image = UIImage(named: "star_check")
                star2.tintColor  = UIColor.white
                star3.image = UIImage(named: "star_check")
                star3.tintColor  = UIColor.white
            } else if currentUser["userBadgeName"].string == "wayfarer"{
                star1.image = UIImage(named: "star_check")
                star1.tintColor  = UIColor.white
                star2.image = UIImage(named: "star_check")
                star2.tintColor  = UIColor.white
                star3.image = UIImage(named: "star_check")
                star3.tintColor  = UIColor.white
                star4.image = UIImage(named: "star_check")
                star4.tintColor  = UIColor.white
            } else if currentUser["userBadgeName"].string == "nomad"{
                star1.image = UIImage(named: "star_check")
                star1.tintColor  = UIColor.white
                star2.image = UIImage(named: "star_check")
                star2.tintColor  = UIColor.white
                star3.image = UIImage(named: "star_check")
                star3.tintColor  = UIColor.white
                star4.image = UIImage(named: "star_check")
                star4.tintColor  = UIColor.white
                star5.image = UIImage(named: "star_check")
                star5.tintColor  = UIColor.white
            } else {
                starstack.isHidden = true
                
            }

            
            let isUrl = verifyUrl(imageName)
            if (isUrl) {
                profilePicture.hnk_setImageFromURL(URL(string:imageName)!)
                profile.image.hnk_setImageFromURL(URL(string:imageName)!)
                backgroundImage.hnk_setImageFromURL(URL(string:imageName)!)

            } else {
                let getImageUrl = URL(string:adminUrl + "upload/readFile?file=" + imageName + "&width=500")
                profilePicture.hnk_setImageFromURL(getImageUrl!)
                profile.image.hnk_setImageFromURL(getImageUrl!)
                backgroundImage.hnk_setImageFromURL(getImageUrl!)
            }
            if currentUser["homeCountry"] != nil {                
                profile.flag.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(currentUser["homeCountry"]["flag"].stringValue)", width: 100))
            }
            
            makeMenuProfilePicture(profilePicture)
        }
        else {
            profile.flag.isHidden = true
            starstack.isHidden = true
            loginLabel.isHidden = false
            profileName.isHidden = true
        }
    }
    
    @IBAction func profileTap(_ sender: AnyObject) {
        if currentUser != nil {
            selectedUser = nil
            self.slideMenuController()?.changeMainViewController(self.myProfileViewController, close: true)            
        }
        else{
            closeLeft()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Tableview Delegates and Datasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SideMenuTableViewCell
        cell.menuLabel.text = labels[(indexPath as NSIndexPath).item]
        cell.menuLabel.shadowColor = UIColor.black
        cell.menuLabel.shadowOffset = CGSize(width: 2, height: 2)
        cell.menuLabel.layer.masksToBounds = true
        
        if indexPath.row == 6 && !(currentUser != nil) {     // Login/Logout Option
            cell.menuLabel.text = "Login"            
        }
        
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return labels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! SideMenuTableViewCell
//         cell.backgroundColor = mainBlueColor
//        cell.menuLabel.textColor = mainGreenColor
        
        switch((indexPath as NSIndexPath).row)
        {
        case 0:
            popularView = "popular"
            self.slideMenuController()?.changeMainViewController(self.popJourneysController, close: true)
        case 1:
            popularView = "popitinerary"
            self.slideMenuController()?.changeMainViewController(self.exploreDestinationsController, close: true)
        case 2:
            self.slideMenuController()?.changeMainViewController(self.popBloggersController, close: true)        
        case 3:
            self.shareButtonClicked(sender: cell)
        case 4:
            self.rateUsButtonClicked()
        case 5:
            if currentUser != nil {
                self.slideMenuController()?.changeMainViewController(self.feedbackController, close: true)
            }
            else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
            }            
        case 6:
            if currentUser != nil {
                user.dropTable()
                UserDefaults.standard.set(0, forKey: "notificationCount")
                self.slideMenuController()?.changeMainViewController(self.signOutViewController, close: true)
            }
            else{
                closeLeft()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
            }
            
        case 7:
            if currentUser != nil {
                self.slideMenuController()?.changeMainViewController(self.localLifeController, close: true)
            }
            else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: ["type":1])
            }
        default:
            if currentUser != nil {
                self.slideMenuController()?.changeMainViewController(self.homeController, close: true)
            }
            else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
//        let cell = tableView.cellForRow(at: indexPath) as! SideMenuTableViewCell
//        cell.backgroundColor = mainGreenColor
//        cell.menuLabel.textColor = mainBlueColor
        
    }
    
    //MARK: - Invite
    
    func shareButtonClicked(sender: SideMenuTableViewCell) {
        let textToShare = "Check out this application. This is awesome life :) "
        if let myWebsite = NSURL(string: "http://travelibro.com/") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard, UIActivityType.saveToCameraRoll]
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    //MARK: - Rate Us
    func rateUsButtonClicked() {
        let loader = LoadingOverlay()
        loader.showOverlay(self.view)
        let appID = "1056641759"
        let urlStr = "itms-apps://itunes.apple.com/app/travelibro/id" + appID
        UIApplication.shared.open((NSURL(string: urlStr) as! URL), options: [:]) { (done) in
            loader.hideOverlayView()
        }
    }
 
}

class SideMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuLabel: UILabel!
    
    
}

import UIKit
import SABlurImageView

class SideNavigationMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var imageName = ""
    
    var profile:profilePicNavigation! = profilePicNavigation()
    
    var mainViewController: UIViewController!
    var homeController:UIViewController!
    var popJourneysController:UIViewController!
    var exploreDestinationsController:UIViewController!
    var popBloggersController:UIViewController!    
    var inviteFriendsController:UIViewController!
    var rateUsController:UIViewController!    
    var settingsViewController: UIViewController!
    var localLifeController: UIViewController!
    var myProfileViewController: UIViewController!
    var signOutViewController: UIViewController!
    var signInViewController: SignInViewController!
    
    let labels = ["Popular Journeys", "Popular Itineraries", "Popular Bloggers", "Invite Friends", "Rate Us", "Feedback", "Log Out"]
    
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
            request.getUserFromCache(user.getExistingUser(), completion: { (response) in
                currentUser = response["data"]
                print("\n currentUser : \(currentUser)")
                self.slideMenuController()?.changeMainViewController(self.settingsViewController, close: true)
            })
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
        
        let PJController = storyboard!.instantiateViewController(withIdentifier: "TLMainFeedsView") as! TLMainFeedsViewController
        PJController.pageType = viewType.VIEW_TYPE_POPULAR_JOURNEY
        PJController.shouldLoadFromStart = true
        self.popJourneysController = UINavigationController(rootViewController: PJController)
        
        let EDController = storyboard!.instantiateViewController(withIdentifier: "TLMainFeedsView") as! TLMainFeedsViewController
        EDController.pageType = viewType.VIEW_TYPE_POPULAR_ITINERARY
        PJController.shouldLoadFromStart = true
        self.exploreDestinationsController = UINavigationController(rootViewController: EDController)
        
        let PBController = storyboard!.instantiateViewController(withIdentifier: "popularBloggers") as! PopularBloggersViewController
        self.popBloggersController = UINavigationController(rootViewController: PBController)
        
        let inviteController = storyboard!.instantiateViewController(withIdentifier: "inviteFriends") as! InviteFriendsViewController
        self.inviteFriendsController = UINavigationController(rootViewController: inviteController)
        
        let rateUsController = storyboard!.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        self.rateUsController = UINavigationController(rootViewController: rateUsController)
        
        let localLifeController = storyboard!.instantiateViewController(withIdentifier: "localLife") as! LocalLifeRecommendationViewController
        self.localLifeController = UINavigationController(rootViewController: localLifeController)
        
        let myProfileController = storyboard!.instantiateViewController(withIdentifier: "TLProfileView") as! TLProfileViewController
        myProfileController.displayData = ""
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
        updateProfilePicture()
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
        print("\n updateProfilePicture currentUser : \(currentUser)")
        if currentUser != nil && (currentUser["_id"].stringValue == user.getExistingUser()) {
            print("Current user name : \(currentUser["name"].stringValue)")
            starstack.isHidden = false
            profile.flag.isHidden = false
            profileName.text = currentUser["name"].stringValue
            imageName = currentUser["profilePicture"].stringValue
            loginLabel.isHidden = true
            profileName.isHidden = false
            
            if currentUser["userBadgeName"].string == "newbie"{
                star1.image = UIImage(named: "star_check")
                star1.tintColor  = UIColor.white
            }
            else if currentUser["userBadgeName"].string == "justGotWings"{
                star1.image = UIImage(named: "star_check")
                star1.tintColor  = UIColor.white
                star2.image = UIImage(named: "star_check")
                star2.tintColor  = UIColor.white
            }
            else if currentUser["userBadgeName"].string == "globeTrotter"{
                star1.image = UIImage(named: "star_check")
                star1.tintColor  = UIColor.white
                star2.image = UIImage(named: "star_check")
                star2.tintColor  = UIColor.white
                star3.image = UIImage(named: "star_check")
                star3.tintColor  = UIColor.white
            }
            else if currentUser["userBadgeName"].string == "wayfarer"{
                star1.image = UIImage(named: "star_check")
                star1.tintColor  = UIColor.white
                star2.image = UIImage(named: "star_check")
                star2.tintColor  = UIColor.white
                star3.image = UIImage(named: "star_check")
                star3.tintColor  = UIColor.white
                star4.image = UIImage(named: "star_check")
                star4.tintColor  = UIColor.white
            } 
            else if currentUser["userBadgeName"].string == "nomad"{
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
            }
            else {
                starstack.isHidden = true
                
            }
            
            let isUrl = verifyUrl(imageName)
            if (isUrl) {
                let getImageUrl = URL(string:imageName)!
                profilePicture.sd_setImage(with: getImageUrl, placeholderImage: getPlaceholderImage())
                profile.image.sd_setImage(with: getImageUrl, placeholderImage: getPlaceholderImage())
                backgroundImage.sd_setImage(with: getImageUrl, placeholderImage: getPlaceholderImage())
            } else {
                let getImageUrl = URL(string:adminUrl + "upload/readFile?file=" + imageName + "&width=500")
                profilePicture.sd_setImage(with: getImageUrl, placeholderImage: getPlaceholderImage())
                profile.image.sd_setImage(with: getImageUrl, placeholderImage: getPlaceholderImage())
                backgroundImage.sd_setImage(with: getImageUrl, placeholderImage: getPlaceholderImage())
            }
            if currentUser["homeCountry"] != nil {
                profile.flag.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(currentUser["homeCountry"]["flag"].stringValue)", width: SMALL_PHOTO_WIDTH))
            }
            
            makeMenuProfilePicture(profilePicture)
        }
        else if (currentUser != nil) {
            //Do nothing
        }
        else {
            profile.flag.isHidden = true
            starstack.isHidden = true
            loginLabel.isHidden = false
            profileName.isHidden = true
        }
        
        profile.flag.isHidden = true
    }
    
    @IBAction func profileTap(_ sender: AnyObject?) {
        if currentUser != nil {
            selectedUser = nil
            request.getUserFromCache(user.getExistingUser(), completion: { (response) in
                currentUser = response["data"]
                print("\n currentUser : \(currentUser)")
                self.slideMenuController()?.changeMainViewController(self.myProfileViewController, close: true)
            })
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // main header height 325
        var a = (screenHeight - 280) / 7        
        if a > 76 {
            a = 76
        }
        return a

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! SideMenuTableViewCell
//         cell.backgroundColor = mainBlueColor
//        cell.menuLabel.textColor = mainGreenColor
        
        switch((indexPath as NSIndexPath).row)
        {
        case 0:            
            self.slideMenuController()?.changeMainViewController(self.popJourneysController, close: true)
            
        case 1:            
            self.slideMenuController()?.changeMainViewController(self.exploreDestinationsController, close: true)
            
        case 2:
            self.slideMenuController()?.changeMainViewController(self.popBloggersController, close: true)        
        case 3:
            if currentUser != nil {
                inviteToAppClicked(sender: cell, onView: self)
            }
            else {
                closeLeft()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
            }
        case 4:
            if currentUser != nil {
                self.rateUsButtonClicked()
            }
            else {
                closeLeft()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
            }            
        case 5:
            if currentUser != nil {
                feedbackClicked()
            }
            else {
                closeLeft()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
            }            
        case 6:
            if currentUser != nil {
                logoutUser()
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
    
    //MARK: - Rate Us
    
    func rateUsButtonClicked() {
        closeLeft()
        let loader = LoadingOverlay()
        loader.showOverlay(self.view)
        let appID = "1056641759"
        let urlStr = "itms-apps://itunes.apple.com/app/travelibro/id" + appID
        if #available(iOS 10.0, *) {
            UIApplication.shared.open((NSURL(string: urlStr) as! URL), options: [:]) { (done) in
                loader.hideOverlayView()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    //MARK: - Feedback
    
    func feedbackClicked() {
        
        let reportVC = storyboard?.instantiateViewController(withIdentifier: "EditSettings") as! EditSettingsViewController
        reportVC.whichView = "ReportView"
        let reportNVC = UINavigationController(rootViewController: reportVC)
        self.slideMenuController()?.changeMainViewController(reportNVC, close: true)
    }
    
    
    //MARK: - Logout
    
    func logoutUser() {
        closeLeft()        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let loader = LoadingOverlay()
            loader.showOverlay((globalNavigationController.topViewController?.view)!)
            request.logout(id: user.getExistingUser()) { (response) in
                DispatchQueue.main.async(execute: {
                    loader.hideOverlayView()
                    if response.error != nil {
                        print("error: \(response.error!.localizedDescription)")
                    }
                    else if response["value"].bool! {                                              
                        clearNotificationCount()
                                             
                        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpOne") as! SignInViewController
                        newViewController.shouldShowNavBar = false
                        
                        let nvc = UINavigationController(rootViewController: newViewController)
                        leftViewController = self.storyboard?.instantiateViewController(withIdentifier: "sideMenu") as! SideNavigationMenuViewController                        
                        let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
                        
                        ((UIApplication.shared.delegate as! AppDelegate).window)?.rootViewController = slideMenuController
                        UIViewController().customiseNavigation()
                        
                    }
                    else {
                        let errorAlert = UIAlertController(title: "Error", message: "Logout failed. Please try again later", preferredStyle: UIAlertControllerStyle.alert)
                        let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
                            (result : UIAlertAction) -> Void in
                            //Cancel Action
                        }            
                        errorAlert.addAction(DestructiveAction)
                        self.navigationController?.present(errorAlert, animated: true, completion: nil)
                    }
                })
            }           
        }
    }
 
}


//MARK: - Cell Class

class SideMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuLabel: UILabel!
    
    
}

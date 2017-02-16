import UIKit
import DKChainableAnimationKit

var doRemove: Bool = true
var globalProfileController:ProfileViewController!
class ProfileViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UIViewControllerPreviewingDelegate {

    @IBOutlet weak var scrollImage: UIScrollView!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var livesInStack: UIStackView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profile_badge: UIImageView!
//    @IBOutlet weak var profileLocation: UILabel!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var isPhotographer: UILabel!
    @IBOutlet weak var moreAboutMe: UILabel!
    var myLifeVC:MyLifeViewController!
    
    var profile: ProfilePicFancy!
    var orangeTab:OrangeButton!
    var footer:FooterViewNew!
    var MAM: MoreAboutMe!
    
    var labels = ["0 Following", "0 Followers", "0 Countries Visited", "0 Bucket List", "0 Journeys", "0 Check Ins", "0 Photos", "0 Reviews"]
    dynamic var profileViewYPosition: CGFloat = 0
    
    fileprivate var kvoContext: UInt8 = 0
    
    @IBOutlet weak var MAMStack: UIStackView!
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet weak var MAMatterView: UIView!
    var MAMScrollView: UIScrollView!
    
    @IBOutlet weak var mainProfileView: UIView!
    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var locationIcon: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    var toggle = false
    var initialEntrance = false
    var user = User()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var MAMButton: UIButton!
    @IBAction func MAMTapped(_ sender: AnyObject?) {
        
        if !toggle {
            
            MAMButton.transform = MAMButton.transform.rotated(by: CGFloat(M_PI))
            MAMatterView.animation.makeOpacity(1.0).animate(0.25)
            mainProfileView.animation.moveY(-80.0).moveHeight(80.0).animate(0.25)
            toggle = true
        }
        
        else {
            
            MAMButton.transform = MAMButton.transform.rotated(by: CGFloat(M_PI))
            MAMatterView.animation.makeOpacity(0.0).animate(0.25)
            mainProfileView.animation.moveY(80.0).makeHeight(350.0).animate(0.25)
            toggle = false
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    var allCount: JSON!

    
    func setCount() {
        
        if (allCount["following_count"].stringValue == "" || allCount["following_count"].stringValue == " ")
        {
            print("ERROR OCCUERED");
        } else {
            for i in 0 ..< labels.count {
                
                switch i {
                case 0:
                    labels[0] = allCount["following_count"].stringValue + " Following"
                    break
                case 1:
                    labels[1] = allCount["followers_count"].stringValue + " Followers"
                    break
                case 2:
                    labels[2] = allCount["countriesVisited_count"].stringValue + " Countries Visited"
                    break
                case 3:
                    labels[3] = allCount["bucketList_count"].stringValue + " Bucket List"
                    break
                case 4:
                    labels[4] = allCount["journeysCreated_count"].stringValue + " Journeys"
                    break
                case 5:
                    labels[5] = allCount["checkins_count"].stringValue + " Check Ins"
                    break
                case 6:
                    labels[6] = allCount["photos_count"].stringValue + " Photos"
                    break
                case 7:
                    labels[7] = allCount["reviews_count"].stringValue + " Reviews"
                    break
                default:
                    break
                }
            }
            profileCollectionView.reloadData()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
//        scrollImage.isScrollEnabled =  true
//        scrollImage.contentSize.width = 10000
//        scrollViewWillBeginDragging(collectionView)
        myLifeVC = storyboard?.instantiateViewController(withIdentifier: "myLife") as! MyLifeViewController
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
        globalProfileController = self
        transparentCardWhite(mainProfileView)
        profileUsername.adjustsFontSizeToFitWidth = true
        MAMButton.layer.zPosition = 500000
        moreAboutMe.layer.zPosition = 500000
        collectionView.layer.zPosition = 500000
        isPhotographer.layer.zPosition = 500000
        profileView.layer.zPosition = 500000
        profile_badge.layer.zPosition = 500000
        profile_badge.layer.zPosition = 500000
        profileUsername.layer.zPosition = 500000
        MAMatterView.layer.zPosition = 500000
        livesInStack.layer.zPosition = 500000
        initialLogin = false
        self.navigationController?.isNavigationBarHidden = false
        getDarkBackGround(self)
        profilePicture.contentMode = .scaleAspectFit
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "search_toolbar"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(ProfileViewController.search(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: -10, y: 8, width: 30, height: 30)
        self.setOnlyRightNavigationButton(rightButton)
        let customView = UIView(frame:(CGRect(x: 0, y: self.view.frame.size.height - 75, width: self.view.frame.width, height: 75)))
        self.orangeTab = OrangeButton(frame: CGRect(x: 5, y: self.view.frame.size.height - 125, width: self.view.frame.size.width - 10, height: 50))
        orangeTab.orangeButtonTitle.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        orangeTab.orangeButtonTitle.setTitle("My Life", for: UIControlState())
        let fontAwesomeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: orangeTab.frame.size.height))
        fontAwesomeLabel.center = CGPoint(x: 90, y: orangeTab.orangeButtonTitle.titleLabel!.frame.size.height/2 + 10)
        fontAwesomeLabel.font = FontAwesomeFont
        fontAwesomeLabel.text = String(format: "%C", faicon["angle_up"]!)
        fontAwesomeLabel.textColor = UIColor.white
        orangeTab.orangeButtonTitle.titleLabel!.addSubview(fontAwesomeLabel)
        self.view.addSubview(orangeTab)
        customView.backgroundColor = UIColor.white
        self.view.addSubview(customView)
        orangeTab.orangeButtonTitle.addTarget(self, action: #selector(ProfileViewController.MyLifeDetailsShow(_:)), for: .touchUpInside)
        MAMStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.MAMStacKTap(_:))))
        locationIcon.text = String(format: "%C", faicon["location"]!)
        MAMButton.transform = MAMButton.transform.rotated(by: CGFloat(M_PI))
    }
    
    
    
    func onLoaded() {
        
        self.allCount = currentUser
        
        
        
        profile = ProfilePicFancy(frame: CGRect(x: 10, y: 0, width: profileView.frame.width, height: profileView.frame.height))
        profile.backgroundColor = UIColor.clear
        profileView.addSubview(profile)
        
        footer = FooterViewNew(frame: CGRect(x: 0, y: self.view.frame.height - 70, width: self.view.frame.width, height: 70))
        self.view.addSubview(footer)

        
        
        profilePicture.isHidden = true
        
        MAMatterView.layer.opacity = 0.0
        
        
        
        MAM = MoreAboutMe(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 20, height: 150))
        MAM.backgroundColor = UIColor.clear
        MAMatterView!.addSubview(MAM)
        
        var imageName = ""
        
        if currentUser != nil {
            self.title = "My Life"
        
            profileUsername.text = "\(currentUser["name"].string!)"
            imageName = currentUser["profilePicture"].string!
            
            if currentUser["homeCountry"] != nil {
                countryName.text = currentUser["homeCountry"]["name"].string!
            }
            
            if currentUser["homeCity"] != nil {
                let place = currentUser["homeCity"].string!.components(separatedBy: ",")
                placeLabel.text = " \(place[0])"
            }
            
            let isUrl = verifyUrl(imageName)
            
            if isUrl {
                self.profilePicture.hnk_setImageFromURL(URL(string:imageName)!)
                self.profilePicture.isHidden = true
                profile.image.hnk_setImageFromURL(URL(string:imageName)!)
            }
            else {
                let getImageUrl = URL(string:adminUrl + "upload/readFile?file=" + imageName + "&width=500")
                profilePicture.hnk_setImageFromURL(getImageUrl!)
                profile.image.hnk_setImageFromURL(getImageUrl!)
            }
            makeTLProfilePicture(self.profilePicture)
        }
        var isNotDone = true
        if(currentUser["travelConfig"]["preferToTravel"].array != nil) {
            if(isNotDone) {
                
                for prefer in currentUser["travelConfig"]["preferToTravel"].array! {
                    if(prefer.stringValue == "Blogger") {
                        isNotDone = false
                        self.isPhotographer.text = "Blogger"
                    }
                }
            }
            if(isNotDone) {
                for prefer in currentUser["travelConfig"]["preferToTravel"].array! {
                    if(prefer.stringValue == "Photographer") {
                        isNotDone = false
                        self.isPhotographer.text = "Photographer"
                    }
                }
            }
            
            if(isNotDone) {
                isNotDone = false
                self.isPhotographer.text = ""
            }
        } else {
            isNotDone = false
            self.isPhotographer.text = ""
        }
        
        
        
        profile_badge.image = UIImage(named:currentUser["userBadgeName"].stringValue.lowercased())
        
        
        
        
        
        
    }
    
    
    func goToLocalLife(_ sender : AnyObject) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "localLife") as! LocalLifeRecommendationViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        globalNavigationController = self.navigationController
        self.getUser()
    }
    
    func getUser() {
        request.getUser(user.getExistingUser(), completion: {(request) in
            DispatchQueue.main.async {
                currentUser = request["data"]
                self.onLoaded()
                self.setCount()
            }
        });
    }
    
    func openNotifications(_ sender: UITapGestureRecognizer) {
        
        for vc in self.navigationController!.viewControllers {
            
            if vc.isKind(of: NewTLViewController.self) {
                
                
            }
            
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "notifySub") as! NotificationSubViewController
        vc.whichView = "Notify"
        self.navigationController?.pushViewController(vc, animated: false)
        
        
    }
    
    func gotoOTG(_ sender: UITapGestureRecognizer) {
        
        
        
        
        var isThere = 0
        let vcs = self.navigationController!.viewControllers
        
        for vc in vcs {
            if vc.isKind(of: NewTLViewController.self) {
                self.navigationController!.popToViewController(vc, animated: false)
                isThere = 1
            }
        }

        if isThere == 0 {
            let tlVC = self.storyboard!.instantiateViewController(withIdentifier: "newTL") as! NewTLViewController
            tlVC.isJourney = false
            if(currentUser["journeyId"].stringValue == "-1") {
                isJourneyOngoing = false
                tlVC.showJourneyOngoing(journey: JSON(""))
//                self.navigationController?.navigationBar.isHidden = true
            }
            self.navigationController?.pushViewController(tlVC, animated: false) 
        }
    }
    func gotoFeed(_ sender: UITapGestureRecognizer) {
        
        let tlVC = self.storyboard!.instantiateViewController(withIdentifier: "activityFeeds") as! ActivityFeedsController
            self.navigationController?.pushViewController(tlVC, animated: false)
    
    }
    
    func MAMStacKTap(_ sender: UITapGestureRecognizer) {
        self.MAMTapped(sender)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func search(_ sender: AnyObject) {
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "Search") as! SearchViewController
        globalNavigationController.pushViewController(searchVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        
        let myValues = labels[(indexPath as NSIndexPath).item]
        let valueArray = myValues.characters.split{$0 == " "}.map(String.init)
        
        let textOne = NSAttributedString(string: valueArray[0], attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
        let textTwo = NSMutableAttributedString(string: valueArray[1], attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!])
        
        if valueArray.count > 2 {
            let textThree = NSAttributedString(string: valueArray[2], attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!])
            textTwo.append(NSAttributedString(string: " "))
            textTwo.append(textThree)
        }
        
        let fullText = NSMutableAttributedString(attributedString: textOne)
        fullText.append(NSAttributedString(string: "\n"))
        fullText.append(textTwo)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProfileDetailCell
        cell.infoLabel.attributedText = fullText
        cell.infoLabel.layer.zPosition = 50000
        cell.infoLabel.adjustsFontSizeToFitWidth = true
        if (indexPath as NSIndexPath).row == labels.count - 1 {
            cell.separatorView.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labels.count
    }

    
    func gotoBucketList() {
        let num = Int(allCount["bucketList_count"].stringValue)
        if(num == 0) {
            let bucketVC = self.storyboard?.instantiateViewController(withIdentifier: "emptyPages") as! EmptyPagesViewController
            bucketVC.whichView = "BucketList"
            self.navigationController?.pushViewController(bucketVC, animated: true)
        } else {
            let bucketVC = self.storyboard?.instantiateViewController(withIdentifier: "bucketList") as! BucketListTableViewController
            bucketVC.whichView = "BucketList"
            self.navigationController?.pushViewController(bucketVC, animated: true)
        }
       
    }
    
    func gotoCountriesVisited() {
        let num = Int(allCount["countriesVisited_count"].stringValue)
        if(num == 0) {
            let bucketVC = self.storyboard?.instantiateViewController(withIdentifier: "emptyPages") as! EmptyPagesViewController
            bucketVC.whichView = "CountriesVisited"
            self.navigationController?.pushViewController(bucketVC, animated: true)
        } else {
            let bucketVC = self.storyboard?.instantiateViewController(withIdentifier: "bucketList") as! BucketListTableViewController
            bucketVC.whichView = "CountriesVisited"
            self.navigationController?.pushViewController(bucketVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if toggle {
            
            MAMTapped(nil)
        }
        
        print("Selected item: \((indexPath as NSIndexPath).item)")
        
        switch (indexPath as NSIndexPath).item {
        case 0:
            let followersVC = storyboard?.instantiateViewController(withIdentifier: "followers") as! FollowersViewController
            followersVC.whichView = "Following"
            self.navigationController?.pushViewController(followersVC, animated: true)
            break
        case 1:
            let followersVC = storyboard?.instantiateViewController(withIdentifier: "followers") as! FollowersViewController
            followersVC.whichView = "Followers"
            self.navigationController?.pushViewController(followersVC, animated: true)
            break
        case 2:
            gotoCountriesVisited()
            break
        case 3:
            gotoBucketList()
            break
        case 4 :
            let journeys = storyboard?.instantiateViewController(withIdentifier: "allJourneysCreated") as! AllJourneysViewController
            self.navigationController?.pushViewController(journeys, animated: true)
            break
        case 5:
            let journeys = storyboard?.instantiateViewController(withIdentifier: "allJourneysCreated") as! AllJourneysViewController
            self.navigationController?.pushViewController(journeys, animated: true)
            break
        case 6 :
            let photosVC = storyboard?.instantiateViewController(withIdentifier: "multipleCollectionVC") as! MyLifeMomentsViewController
            photosVC.whichView = "All"
            self.navigationController?.pushViewController(photosVC, animated: true)
            break
        case 7 :
            let reviewsVC = storyboard?.instantiateViewController(withIdentifier: "multipleTableVC") as! AccordionViewController
            self.navigationController?.pushViewController(reviewsVC, animated: true)
            break
        default:
            break
        }
        
    }
    
    func MyLifeDetailsShow(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            self.navigationController!.pushViewController(self.myLifeVC, animated: false)
            UIView.setAnimationTransition(UIViewAnimationTransition.curlUp, for: self.navigationController!.view!, cache: false)
        })
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        var peep:UIViewController!
        print(self.orangeTab)
        print(location);
        let myLife = self.orangeTab.frame.contains(location)
        if(myLife) {
            peep = self.myLifeVC
        }
        return peep
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
}


class ProfileDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
}

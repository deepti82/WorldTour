import UIKit
import DKChainableAnimationKit
import Toaster
import SwiftGifOrigin
import Crashlytics


var doRemove: Bool = true
var globalProfileController:ProfileViewController!
class ProfileViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerPreviewingDelegate {
   
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
    var customView : UIView!
    var footer:FooterViewNew!
    var MAM: MoreAboutMe!
    var displayData: String = ""
    var imageView1: UIImageView!
    var loader = LoadingOverlay()
    var labels = [["count":"0","text":"Following"], ["count":"0","text":"Followers"], ["count":"0","text":"Countries Visited"], ["count":"0","text":"Bucket List"], ["count":"0","text":"Journeys"], ["count":"0","text":"Check Ins"], ["count":"0","text":"Photos"], ["count":"0","text":"Reviews"]]
    var currentSelectedUser: JSON = []
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
        
        if(!selectedUser.isEmpty && currentUser["status"].stringValue == "private"){}
        else {
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
                    labels[0]["count"] = allCount["following_count"].stringValue
                    break
                case 1:
                    labels[1]["count"] = allCount["followers_count"].stringValue
                    break
                case 2:
                    labels[2]["count"] = allCount["countriesVisited_count"].stringValue
                    break
                case 3:
                    labels[3]["count"] = allCount["bucketList_count"].stringValue
                    break
                case 4:
                    labels[4]["count"] = allCount["journeysCreated_count"].stringValue
                    break
                case 5:
                    labels[5]["count"] = allCount["checkins_count"].stringValue
                    break
                case 6:
                    labels[6]["count"] = allCount["photos_count"].stringValue
                    break
                case 7:
                    labels[7]["count"] = allCount["reviews_count"].stringValue
                    break
                default:
                    break
                }
            }
            profileCollectionView.reloadData()
            
        }
        
    }
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        getUnreadNotificationCount()
        
        loader.showOverlay(self.view)
        self.title = ""
//        scrollImage.isScrollEnabled =  true
//        scrollImage.contentSize.width = 10000
//        scrollViewWillBeginDragging(collectionView)
        myLifeVC = storyboard?.instantiateViewController(withIdentifier: "myLife") as! MyLifeViewController
        myLifeVC.whatEmptyTab = "Journeys"
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
        profileCollectionView.delegate = self
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
        
        if displayData == "search" {
//            createNavigation()
        }else{
            let rightButton = UIButton()
            rightButton.setImage(UIImage(named: "search_toolbar"), for: UIControlState())
            rightButton.addTarget(self, action: #selector(self.searchTapped(_:)), for: .touchUpInside)
            rightButton.frame = CGRect(x: -10, y: 8, width: 30, height: 30)
            self.setOnlyRightNavigationButton(rightButton)
        }
        
        customView = UIView(frame:(CGRect(x: 0, y: self.view.frame.size.height - 75, width: self.view.frame.width, height: 75)))
        self.orangeTab = OrangeButton(frame: CGRect(x: 5, y: self.view.frame.size.height - 125, width: self.view.frame.size.width - 10, height: 50))
        orangeTab.orangeButtonTitle.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        orangeTab.orangeButtonTitle.setTitle("Explore My Life", for: UIControlState())
        let fontAwesomeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: orangeTab.frame.size.height))
        fontAwesomeLabel.center = CGPoint(x: 150, y: orangeTab.orangeButtonTitle.titleLabel!.frame.size.height/2 + 10)
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
        loader.showOverlay(self.view)
        
        self.getUser()
    }
    
    func createNavigation() {
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.imageView?.image = leftButton.imageView?.image!.withRenderingMode(.alwaysTemplate)
        leftButton.imageView?.tintColor = UIColor.white
        
        
        let rightButton = UIButton()
        rightButton.titleLabel?.font = avenirFont
//        rightButton.contentHorizontalAlignment = .right
        setFollowButtonTitle(button: rightButton, followType: currentUser["following"].intValue, otherUserID: currentUser["_id"].stringValue)
        rightButton.addTarget(self, action: #selector(self.rightFollowTapped(sender:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 1000000, y: 5, width: 100, height: 40)
        self.customNavigationBar(left: leftButton, right: rightButton)
            
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.orangeTab.frame = CGRect(x: 5, y: self.view.frame.size.height - 125, width: self.view.frame.size.width - 10, height: 50)
        customView.frame = CGRect(x: 0, y: self.view.frame.size.height - 75, width: self.view.frame.width, height: 75)
        
        selectedUser = currentSelectedUser
        
        if isCountryAdded {
            isCountryAdded = false
            getUser()
        }
        else if isSettingsEdited && selectedUser.isEmpty && currentUser != nil {            
            var imageName = ""
            imageName = currentUser["profilePicture"].string!
            
            if currentUser["homeCountry"] != nil {
                countryName.text = currentUser["homeCountry"]["name"].string!
                profile.flag.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(currentUser["homeCountry"]["flag"].stringValue)", width: 100))
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
            
            isSettingsEdited = false
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.orangeTab.frame = CGRect(x: 5, y: self.view.frame.size.height - 125, width: self.view.frame.size.width - 10, height: 50)
        customView.frame = CGRect(x: 0, y: self.view.frame.size.height - 75, width: self.view.frame.width, height: 75)
        
        globalNavigationController = self.navigationController
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onLoaded() {
        self.loader.hideOverlayView()
        self.allCount = currentUser
        
        
        profile = ProfilePicFancy(frame: CGRect(x: 10, y: 0, width: profileView.frame.width, height: profileView.frame.height))
        profile.backgroundColor = UIColor.clear
        profileView.addSubview(profile)
        footer = FooterViewNew(frame: CGRect(x: 0, y: self.view.frame.height - 65, width: self.view.frame.width, height: 65))
        self.view.addSubview(footer)
        makeTLProfilePicture(profile.image)
        profilePicture.isHidden = true
        
        MAMatterView.layer.opacity = 0.0
        
        if (MAM != nil){
            MAM.removeFromSuperview()
        }
        let myFont = moreAboutMe.font
        print("\n Myfont :\(myFont) \n")
        
        if(!selectedUser.isEmpty && currentUser["status"].stringValue == "private") {
            //Dont show anything
            moreAboutMe.text = "This Account Is Private"
            moreAboutMe.textColor = mainOrangeColor
            moreAboutMe.font = avenirFont
            orangeTab.orangeButtonTitle.imageView?.image = nil
            orangeTab.backgroundColor = UIColor.lightGray
            orangeTab.isUserInteractionEnabled = false
            MAMButton.isHidden = true
        }
        else {
            moreAboutMe.font = myFont
            moreAboutMe.text = "more about me..."
            moreAboutMe.textColor = mainBlueColor
            orangeTab.orangeButtonTitle.imageView?.image = UIImage(named: "orangeFooter")
            orangeTab.isUserInteractionEnabled = true
            
            MAM = MoreAboutMe(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 20, height: 150))
            MAM.backgroundColor = UIColor.clear
            MAMatterView!.addSubview(MAM)
            MAMButton.isHidden = false
        }
        
        if currentUser != nil {
            
            self.title = "My Life"
            
            print("==========\(currentUser)")
            profileUsername.text = "\(currentUser["name"].string!)"
            
            var imageName = ""
            imageName = currentUser["profilePicture"].string!
            
            if currentUser["homeCountry"] != nil {
                countryName.text = currentUser["homeCountry"]["name"].string!
                profile.flag.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(currentUser["homeCountry"]["flag"].stringValue)", width: 100))
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
    
    
    func getUser() {
        request.getUser(user.getExistingUser(), urlSlug:selectedUser["urlSlug"].stringValue, completion: {(request) in
            DispatchQueue.main.async {
                currentUser = request["data"]
                if self.displayData == "search" {
                    self.createNavigation()
                }
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
        tlVC.displayData = "activity"

            self.navigationController?.pushViewController(tlVC, animated: false)
    
    }
    
    func MAMStacKTap(_ sender: UITapGestureRecognizer) {
        self.MAMTapped(sender)
    }
    
    //MARK: - Collection View Delagtes and Datasource
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (collectionView.frame.size.width/3 - 3), height: (collectionView.frame.size.width/3 - 3))
//    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        
//        let myValues = labels[(indexPath as NSIndexPath).item]
//        let valueArray = myValues.characters.split{$0 == " "}.map(String.init)
//        
//        let textOne = NSAttributedString(string: valueArray[0], attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
//        let textTwo = NSMutableAttributedString(string: valueArray[1], attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!])
//        
//        if valueArray.count > 2 {
//            let textThree = NSAttributedString(string: valueArray[2], attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!])
//            textTwo.append(NSAttributedString(string: " "))
//            textTwo.append(textThree)
//        }
//        
//        let fullText = NSMutableAttributedString(attributedString: textOne)
//        fullText.append(NSAttributedString(string: "\n"))
//        fullText.append(textTwo)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProfileDetailCell
        
        cell.infoLabel.text = labels[indexPath.row]["text"]
        cell.countLabel.text = labels[indexPath.row]["count"]
        cell.infoLabel.sizeToFit()
        cell.infoLabel.frame.size.width = 77;
        cell.infoLabel.textAlignment = .center
        cell.infoLabel.layer.zPosition = 50000
//        cell.infoLabel.adjustsFontSizeToFitWidth = true
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
            if displayData == "search" {
            }else{
            let bucketVC = self.storyboard?.instantiateViewController(withIdentifier: "emptyPages") as! EmptyPagesViewController
            bucketVC.whichView = "BucketList"
            self.navigationController?.pushViewController(bucketVC, animated: true)
            }
        } else {
            let bucketVC = self.storyboard?.instantiateViewController(withIdentifier: "bucketList") as! BucketListTableViewController
            
            if displayData == "search" {
                bucketVC.otherUser = "search"
            }
            bucketVC.whichView = "BucketList"
            self.navigationController?.pushViewController(bucketVC, animated: true)
        }
       
    }
    
    func gotoCountriesVisited() {
        let num = Int(allCount["countriesVisited_count"].stringValue)
        if(num == 0) {
            if displayData == "search" {
            }else{
            let bucketVC = self.storyboard?.instantiateViewController(withIdentifier: "emptyPages") as! EmptyPagesViewController
            bucketVC.whichView = "CountriesVisited"
            self.navigationController?.pushViewController(bucketVC, animated: true)
            }
        } else {
            
            let bucketVC = self.storyboard?.instantiateViewController(withIdentifier: "bucketList") as! BucketListTableViewController
            if displayData == "search" {
                bucketVC.otherUser = "search"
            }
            bucketVC.whichView = "CountriesVisited"
            self.navigationController?.pushViewController(bucketVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if toggle {
            MAMTapped(nil)
        }        
        
        switch (indexPath as NSIndexPath).item {
        case 0:
            if displayData == "search" {
                if allCount["following_count"].stringValue == "0" {
                }else{
                    let followersVC = storyboard?.instantiateViewController(withIdentifier: "followers") as! FollowersViewController
                    followersVC.whichView = "Following"
                    if !(selectedUser.isEmpty){
                        followersVC.back = false
                    }
                    self.navigationController?.pushViewController(followersVC, animated: true)
                }
                
            }else{
                let followersVC = storyboard?.instantiateViewController(withIdentifier: "followers") as! FollowersViewController
                followersVC.whichView = "Following"
                if !(selectedUser.isEmpty){
                    followersVC.back = false
                }
                self.navigationController?.pushViewController(followersVC, animated: true)
            }
            break
        case 1:
            if displayData == "search" {
                if allCount["followers_count"].stringValue == "0" {
                }else{
                    let followersVC = storyboard?.instantiateViewController(withIdentifier: "followers") as! FollowersViewController
                    followersVC.whichView = "Followers"
                    if !(selectedUser.isEmpty){
                        followersVC.back = false
                    }
                    self.navigationController?.pushViewController(followersVC, animated: true)
                }
            }else{
                let followersVC = storyboard?.instantiateViewController(withIdentifier: "followers") as! FollowersViewController
                followersVC.whichView = "Followers"
                if !(selectedUser.isEmpty){
                    followersVC.back = false
                }
                self.navigationController?.pushViewController(followersVC, animated: true)
            }
            break
        case 2:
            gotoCountriesVisited()
            break
        case 3:
            gotoBucketList()
            break
        case 4 :
            if displayData == "search" {
                if allCount["journeysCreated_count"].stringValue == "0" {
                }else{
                    self.myLifeNavigateWithTab(whichView: "Journeys")
                }
            }else{
                self.myLifeNavigateWithTab(whichView: "Journeys")
            }
            break
        case 5:
            if displayData == "search" {
                if allCount["journeysCreated_count"].stringValue == "0" {
                    
                }else{
                    if(!selectedUser.isEmpty && currentUser["status"].stringValue == "private") {
                        //Dont show anything
                    }
                    else {
                        self.myLifeNavigateWithTab(whichView: "Journeys")
                    }
                }
            }
            else{
                self.myLifeNavigateWithTab(whichView: "Journeys")
            }
            break
        case 6 :
            if displayData == "search" {
                if allCount["checkins_count"].stringValue == "0" {
                    
                }else{
                    if(!selectedUser.isEmpty && currentUser["status"].stringValue == "private") {
                        //Dont show anything
                    }
                    else {
                        self.myLifeNavigateWithTab(whichView: "Moments")
                    }
                }
            }else{
                if(!selectedUser.isEmpty && currentUser["status"].stringValue == "private") {
                    //Dont show anything
                }
                else {
                    self.myLifeNavigateWithTab(whichView: "Moments")
                }
            }
            break
        case 7 :
            if displayData == "search" {
                if allCount["reviews_count"].stringValue == "0" {
                    
                }else{
                    self.myLifeNavigateWithTab(whichView: "Reviews")
                }
            }else{
                self.myLifeNavigateWithTab(whichView: "Reviews")
            }
            break
        default:
            break
        }
        
    }
    
    func MyLifeDetailsShow(_ sender: AnyObject?) {
//        UIView.animate(withDuration: 0.75, animations: { () -> Void in
//            UIView.setAnimationCurve(UIViewAnimationCurve.linear)
        if(!selectedUser.isEmpty && currentUser["status"].stringValue == "private") {
            //Dont show anything
        }
        else {            
            let myLifeVC = self.storyboard?.instantiateViewController(withIdentifier: "myLife") as! MyLifeViewController
            self.navigationController!.pushViewController(myLifeVC, animated: false)
        }
//            UIView.setAnimationTransition(UIViewAnimationTransition.curlUp, for: self.navigationController!.view!, cache: false)
//        })
    }
    
    func myLifeNavigateWithTab(whichView: String) {
        
        let photosVC = storyboard?.instantiateViewController(withIdentifier: "myLife") as! MyLifeViewController
        photosVC.whatEmptyTab = whichView
        self.navigationController?.pushViewController(photosVC, animated: true)
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
    
    func rightFollowTapped(sender: UIButton) {
        if sender.titleLabel?.text == "Follow" {
            request.followUser(user.getExistingUser(), followUserId: currentUser["_id"].stringValue, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    
                    if response.error != nil {
                        print("error: \(response.error!.localizedDescription)")
                    }
                    else if response["value"].bool! {
                        setFollowButtonTitle(button: sender, followType: response["data"]["responseValue"].intValue, otherUserID: "")
                    }
                    else {
                        print("error: \(response["error"])")
                    }
                })
            })
        }
        else if sender.titleLabel?.text == "Following" {
            request.unfollow(user.getExistingUser(), unFollowId: currentUser["_id"].stringValue, completion: {(response) in
                DispatchQueue.main.async(execute: {
                    if response.error != nil {
                        print("error: \(response.error!.localizedDescription)")
                    }
                    else if response["value"].bool! {
                        setFollowButtonTitle(button: sender, followType: response["data"]["responseValue"].intValue, otherUserID: "")
                    }
                    else {
                        print("error: \(response["error"])")
                    }
                })
            })
        }
    }
    
}


class ProfileDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    
}

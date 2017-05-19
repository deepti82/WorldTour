//
//  TLProfileViewController.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 22/04/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
import DKChainableAnimationKit
import Toaster
import SwiftGifOrigin
import Crashlytics

class TLProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var mamStackView: UIStackView!
    @IBOutlet weak var MAMTextView: UIView!
    @IBOutlet weak var moreAboutMeLabel: UILabel!
    @IBOutlet weak var moreAboutMeButton: UIButton!
    @IBOutlet weak var MAMTextViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var userBadgeImageView: UIImageView!
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    @IBOutlet weak var exploreMyLifeView: UIView!
    
    var footer: FooterViewNew!
    
    var user = User()
    
    var currentlyShowingUser: JSON = []
    var currentSelectedUser: JSON = []
    var isShowingSelf = true
    
    var strIndex = 0
    var shouldStopAnimate = true
    var isProfileVCVisible = true
    var isLoadedForFirstTime = false
    
    var myLifeVC:MyLifeViewController!
    var MAM: MoreAboutMe!
    var displayData: String = ""
    
    var loader = LoadingOverlay()
    
    var labels = [["count":"0","text":" following "],
                  ["count":"0","text":" followers "],
                  ["count":"0","text":"countries visited"],
                  ["count":"0","text":"bucket list"],
                  ["count":"0","text":"  journeys  "],
                  ["count":"0","text":"  check ins  "],
                  ["count":"0","text":"   photos   "],
                  ["count":"0","text":"   reviews   "]]

    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLoadedForFirstTime = true
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        getDarkBackGround(self)
        
        getUnreadNotificationCount()
//        userBadgeImageView.imageresizeImage(image: userBadgeImageView.image!,newWidth: 50)

        self.userNameLabel.text = ""
        self.cityNameLabel.text = ""
        
        loader.showOverlay(self.view)
        
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        
        //myLifeVC instance created 
        myLifeVC = storyboard?.instantiateViewController(withIdentifier: "myLife") as! MyLifeViewController
        myLifeVC.whatEmptyTab = "Journeys"
        
        footer = FooterViewNew(frame: CGRect.zero)
        self.view.addSubview(footer)
        
        if self.displayData == "search" {
            self.isShowingSelf = false
        }
        else {
            self.isShowingSelf = true
        }
        
        if !self.isShowingSelf {
            self.getUser()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shouldShowTransperentNavBar = true
        
        self.setNavigationBar()
        
        if !currentlyShowingUser.isEmpty {
            if !isSelfUser(otherUserID: currentlyShowingUser["_id"].stringValue) {
                selectedUser = currentlyShowingUser                
            }
        }        
        
        if self.isShowingSelf {
            self.getUser()
        }
        
        self.footer.setFooterDefaultState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        globalNavigationController = self.navigationController
        
        self.setNavigationBar()
        
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isProfileVCVisible = false
        shouldShowTransperentNavBar = false        
        if (self.mamStackView.tag == 1) {
            self.toggleMAMTextView(stackView: self.mamStackView)
        }
        self.customiseNavigation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - UI
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
//        
//        let scale = newWidth / image.size.width
//        let newHeight = image.size.height * scale
//        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
//        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
//        
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    func setNavigationBar() {
        
        setNavigationBarItemText("My Life")
        
        if displayData == "search" {
            let leftButton = UIButton()
            leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
            leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
            leftButton.imageView?.image = leftButton.imageView?.image!.withRenderingMode(.alwaysTemplate)
            leftButton.imageView?.tintColor = UIColor.white
            
            
            let rightButton = UIButton()
            rightButton.titleLabel?.font = avenirBold
            setFollowButtonTitle(button: rightButton, followType: currentlyShowingUser["following"].intValue, otherUserID: currentlyShowingUser["_id"].stringValue)
            rightButton.addTarget(self, action: #selector(self.rightFollowTapped(sender:)), for: .touchUpInside)
            rightButton.frame = CGRect(x: 1000000, y: 5, width: 100, height: 40)
            self.customNavigationBar(left: leftButton, right: rightButton)
        }
        else{            
            let rightButton = UIButton()
            rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            rightButton.addTarget(self, action: #selector(self.searchTapped(_:)), for: .touchUpInside)
            rightButton.setImage(UIImage(named: "search_toolbar"), for: .normal)            
            let rightBarButtonItem = UIBarButtonItem(customView: rightButton)
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
            
            
            let leftButton = UIButton()
            leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            leftButton.addTarget(self, action: #selector(UIViewController.toggleLeft), for: .touchUpInside)
            leftButton.setImage(UIImage(named: "menu_left_icon"), for: .normal)            
            let leftBarButtonItem = UIBarButtonItem(customView: leftButton)
            self.navigationItem.leftBarButtonItem = leftBarButtonItem
        }
        self.navigationController?.navigationBar.setNeedsDisplay()
    }
    
    func updateUI() {
        
        footer.frame = CGRect(x: 0, y: self.view.frame.height - MAIN_FOOTER_HEIGHT, width: self.view.frame.width, height: MAIN_FOOTER_HEIGHT)
        
        flagImageView.layer.masksToBounds = false
        flagImageView.layer.cornerRadius = flagImageView.frame.height/2
        flagImageView.clipsToBounds = true
        
        if isLoadedForFirstTime {
            self.addBorder(toView: self.profileCollectionView, position: layerEdge.TOP, color: UIColor(white: 1, alpha: 0.2), borderWidth: CGFloat(1), width: self.profileCollectionView.contentSize.width)
            self.addBorder(toView: self.profileCollectionView, position: layerEdge.BOTTOM, color: UIColor(white: 1, alpha: 0.2), borderWidth: CGFloat(1), width: self.profileCollectionView.contentSize.width)
            isLoadedForFirstTime = false
        }
        
        exploreMyLifeView.layer.cornerRadius = (exploreMyLifeView.frame.size.height * 0.15)
        
        setUserBadgeName(badge: currentlyShowingUser["userBadgeName"].stringValue)
    }
    
    func setUserName(username: String) {
        self.self.userNameLabel.text = username
        self.setCityName(cityName: self.currentlyShowingUser["homeCity"].stringValue, countryName: self.currentlyShowingUser["homeCountry"]["name"].stringValue)
    }
    
    func setCityName(cityName: String, countryName: String) {
        if !isShowingSelf && cityName == "" {
            self.cityNameLabel.text = ""            
        }
        else {
            self.cityNameLabel.text = "LIVES IN : \(cityName.uppercased())"
        }
    }
    
    func setUserBadgeName(badge: String) {
        print(screenWidth/25)
        if currentUser["userBadgeName"].string == "newbie"{
            self.userBadgeImageView.image = resizeImage(image: UIImage(named: "badge1")!, newWidth: screenWidth/25)
        }
        else if currentUser["userBadgeName"].string == "justGotWings"{
            self.userBadgeImageView.image = resizeImage(image: UIImage(named: "badge2")!, newWidth: screenWidth/25)
        }
        else if currentUser["userBadgeName"].string == "globeTrotter"{
            self.userBadgeImageView.image = resizeImage(image: UIImage(named: "badge3")!, newWidth: screenWidth/25)
        }
        else if currentUser["userBadgeName"].string == "wayfarer"{
            self.userBadgeImageView.image = resizeImage(image: UIImage(named: "badge4")!, newWidth: screenWidth/25)
        } 
        else if currentUser["userBadgeName"].string == "nomad"{
            self.userBadgeImageView.image = resizeImage(image: UIImage(named: "badge5")!, newWidth: screenWidth/25)
        }
    }
    
    func setData() {
        
        self.loader.hideOverlayView()
        
        if (MAM != nil){
            MAM.removeFromSuperview()
        }
        
        if shouldRestrictCurrentUserProfile() {
            //Private Account
            moreAboutMeLabel.text = "This Account Is Private"
            moreAboutMeLabel.textColor = mainOrangeColor
            moreAboutMeButton.isHidden = true
            mamStackView.isUserInteractionEnabled = false
            
            exploreMyLifeView.isUserInteractionEnabled = false
            exploreMyLifeView.backgroundColor = UIColor.lightGray
        }
        else {
            moreAboutMeLabel.text = "more about me..."
            moreAboutMeLabel.textColor = UIColor.white
            moreAboutMeButton.isHidden = false
            mamStackView.isUserInteractionEnabled = true
            
            exploreMyLifeView.isUserInteractionEnabled = true
            exploreMyLifeView.backgroundColor = UIColor(red: 252/255, green: 103/255, blue: 89/255, alpha: 0.8)
        }
        
        if currentlyShowingUser != nil {
            
            print("SetData Called")
            
           // print("==========\(currentUser)")
            
            self.userProfileImageView.hnk_setImageFromURL(getImageURL(currentlyShowingUser["profilePicture"].stringValue, width: 0))
            
            setUserName(username: currentlyShowingUser["name"].stringValue)
            
            setUserBadgeName(badge: currentlyShowingUser["userBadgeName"].stringValue)
            
            if currentlyShowingUser["homeCountry"] != nil {
                self.countryNameLabel.text = currentlyShowingUser["homeCountry"]["name"].stringValue.uppercased()
                self.flagImageView.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(currentlyShowingUser["homeCountry"]["flag"].stringValue)", width: SMALL_PHOTO_WIDTH))
            }
            
            self.setCollectionViewData()
            
        }
        
//        profile_badge.image = UIImage(named:currentUser["userBadgeName"].stringValue.lowercased())
        
    }
    
    func setCollectionViewData() {
        
        if (currentlyShowingUser["following_count"].stringValue == "" || currentlyShowingUser["following_count"].stringValue == " ") {
            print("ERROR OCCUERED");
        }
        else {
            for i in 0 ..< labels.count {
                
                switch i {
                case 0:
                    labels[0]["count"] = currentlyShowingUser["following_count"].stringValue
                    break
                case 1:
                    labels[1]["count"] = currentlyShowingUser["followers_count"].stringValue
                    break
                case 2:
                    labels[2]["count"] = currentlyShowingUser["countriesVisited_count"].stringValue
                    break
                case 3:
                    labels[3]["count"] = currentlyShowingUser["bucketList_count"].stringValue
                    break
                case 4:
                    labels[4]["count"] = currentlyShowingUser["journeysCreated_count"].stringValue
                    break
                case 5:
                    labels[5]["count"] = currentlyShowingUser["checkins_count"].stringValue
                    break
                case 6:
                    labels[6]["count"] = currentlyShowingUser["photos_count"].stringValue
                    break
                case 7:
                    labels[7]["count"] = currentlyShowingUser["reviews_count"].stringValue
                    break
                default:
                    break
                }
            }
            profileCollectionView.reloadData()
        }
    }
    
    
    //MARK: - Actions
    
    @IBAction func MAMToggleButtonTabbed(_ sender: UIButton) {
        self.toggleMAMTextView(stackView: self.mamStackView)
    }
    
    @IBAction func MAMStackViewTabbed(_ sender: UITapGestureRecognizer) {
        self.toggleMAMTextView(stackView: self.mamStackView)
    }
    
    @IBAction func exploreMyLifeViewTabbed(_ sender: UITapGestureRecognizer) {
        self.exploreMyLife(selectionTab: "Journeys")
    }
    
    @IBAction func exploreMyLifeTextButtonTabbed(_ sender: UIButton) {
        self.exploreMyLife(selectionTab: "Journeys")
    }
    
    @IBAction func exploreMyLifeButtonTabbed(_ sender: UIButton) {
        self.exploreMyLife(selectionTab: "Journeys")
    }
    
    func rightFollowTapped(sender: UIButton) {
        if sender.titleLabel?.text == "Follow" {
            request.followUser(user.getExistingUser(), followUserId: currentlyShowingUser["_id"].stringValue, completion: {(response) in
                
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
            request.unfollow(user.getExistingUser(), unFollowId: currentlyShowingUser["_id"].stringValue, completion: {(response) in
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
    
    
    //MARK: - Colloection View Datasource and Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labels.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (getTextSize(text: labels[indexPath.row]["text"]!).width + CGFloat(10))
        return CGSize(width: cellWidth, height: profileCollectionView.bounds.height - 1)
    }    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TLProfileDetailCell
        cell.separatorView.isHidden = false
        
        cell.countLabel.text = labels[indexPath.row]["count"]
        cell.infoLabel.text = getTrimmedString(inputString: labels[indexPath.row]["text"]!)
//        cell.infoLabel.sizeToFit()
//        cell.infoLabel.center = CGPoint(x: cell.center.x, y: cell.infoLabel.center.y)
        
        if indexPath.row == labels.count-1 {
            cell.separatorView.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.item {
        case 0:
            if isShowingSelf {
                self.gotoFollowersController(selectionOption: "Following")
            }else{
                if currentlyShowingUser["following_count"].stringValue != "0" {
                    self.gotoFollowersController(selectionOption: "Following")
                }
            }
            break
            
        case 1:
            if isShowingSelf {
                self.gotoFollowersController(selectionOption: "Followers")
            }else{
                if currentlyShowingUser["followers_count"].stringValue != "0" {
                    self.gotoFollowersController(selectionOption: "Followers")
                }
            }
            break
            
        case 2:
            if isShowingSelf {
                gotoCountriesVisited()
            }else{
                if currentlyShowingUser["countriesVisited_count"].stringValue != "0" {
                    gotoCountriesVisited()
                }
            }
            break
            
        case 3:
            gotoBucketList()
            break
            
        case 4 :
            fallthrough
        case 5:
            if isShowingSelf {
                self.exploreMyLife(selectionTab: "Journeys")
            }else{
                if currentlyShowingUser[indexPath.item == 4 ? "journeysCreated_count" : "checkins_count" ].stringValue != "0" {
                    self.exploreMyLife(selectionTab: "Journeys")
                }
            }
            break
        
        case 6 :
            if isShowingSelf {
                self.exploreMyLife(selectionTab: "Moments")
            }else{
                if currentlyShowingUser["photos_count"].stringValue != "0" {
                    self.exploreMyLife(selectionTab: "Moments")
                }
            }
            break
            
        case 7 :
            if isShowingSelf {
                self.exploreMyLife(selectionTab: "Reviews")
            }else{
                if currentlyShowingUser["reviews_count"].stringValue != "0" {
                    self.exploreMyLife(selectionTab: "Reviews")
                }
            }
            break
            
        default:
            break
        }
    }
    
    
    //MARK: - Action Helpers
    
    func toggleMAMTextView(stackView: UIStackView) {
        
        if stackView.tag == 0 {
            self.MAM = MoreAboutMe()
            self.MAM.forUser = currentlyShowingUser
            self.MAM.reloadTravelPrefeces()
            print("uuuuuuuu\(MAM.mainTextView.frame.height)")
            
            let textViewHeight = (heightOfAttributedText(attributedString: MAM.mainTextView.attributedText.mutableCopy() as! NSMutableAttributedString, width: (self.MAMTextView.frame.size.width - 25)) + 15)
            print("textHeight : \(textViewHeight)")
            self.MAM.frame = CGRect(x: 0, y: 0, width: self.MAMTextView.frame.size.width, height: textViewHeight)
            
            self.MAM.backgroundColor = UIColor.clear
//            self.MAM.transform = CGAffineTransform(translationX: 0, y: 0);
            self.MAMTextView.addSubview(self.MAM)
            
            self.MAMTextViewHeightConstraint.constant = textViewHeight + CGFloat(15)
            self.MAMTextView.frame.size.height = textViewHeight + CGFloat(15)
            self.mamStackView.tag = 1
            
        }
        else {
            if (MAM != nil){
                MAM.removeFromSuperview()
            }
            
            self.MAMTextViewHeightConstraint.constant = 0
            self.MAMTextView.frame.size.height = 0
            self.mamStackView.tag = 0
            UIView.animate(withDuration: 0.5){
                self.view.layoutIfNeeded()
            }
        }
    
    }
    
    func exploreMyLife(selectionTab: String) {
        let myLifeViewCtrllr = storyboard?.instantiateViewController(withIdentifier: "myLife") as! MyLifeViewController
        myLifeViewCtrllr.whatEmptyTab = selectionTab
        self.navigationController?.pushViewController(myLifeViewCtrllr, animated: true)
    }
    
    func gotoFollowersController(selectionOption: String) {
        let followersVC = storyboard?.instantiateViewController(withIdentifier: "followers") as! FollowersViewController
        followersVC.whichView = selectionOption
        if !(selectedUser.isEmpty){
            followersVC.back = false
        }
        self.navigationController?.pushViewController(followersVC, animated: true)
    }
    
    func gotoBucketList() {
        let num = Int(currentlyShowingUser["bucketList_count"].stringValue)
        if(num == 0) {
            if isShowingSelf {
                let bucketVC = self.storyboard?.instantiateViewController(withIdentifier: "emptyPages") as! EmptyPagesViewController
                bucketVC.whichView = "BucketList"
                self.navigationController?.pushViewController(bucketVC, animated: true)
            }
        }
        else {
            let bucketVC = self.storyboard?.instantiateViewController(withIdentifier: "bucketList") as! BucketListTableViewController
            bucketVC.otherUser = displayData
            bucketVC.whichView = "BucketList"
            self.navigationController?.pushViewController(bucketVC, animated: true)
        }
    }
    
    func gotoCountriesVisited() {
        let bucketVC = self.storyboard?.instantiateViewController(withIdentifier: "bucketList") as! BucketListTableViewController
        bucketVC.otherUser = displayData        
        bucketVC.whichView = "CountriesVisited"
        self.navigationController?.pushViewController(bucketVC, animated: true)
    }
    
    
    //MARK: - Functional Helpers
    
    func getUser() {
        print("\n getUser called")
        
        request.getUser(user.getExistingUser(), urlSlug:selectedUser["urlSlug"].stringValue, completion: {(request) in
            DispatchQueue.main.async {
                self.currentlyShowingUser = request["data"]
                currentUser = request["data"]
                if !self.isShowingSelf {
                    self.setNavigationBar()
                }
                self.shouldStopAnimate = true
                self.setData()
            }
        });
    }
    
    func shouldRestrictCurrentUserProfile() -> Bool {
        if(!isShowingSelf && (currentlyShowingUser["status"].stringValue == "private" && (currentlyShowingUser["following"].intValue != 1))) {
            return true
        }
        return false
    }
    
    
    //MARK: - UI Helper Functions
    
    func getTextSize(text: String) -> CGSize {
        let testLabel = UILabel()
        testLabel.font = UIFont(name: "Avenir-Roman", size: 14)
        testLabel.text = text
        return testLabel.intrinsicContentSize
    }
    
    func addBorder(toView: UIView, position: layerEdge, color: UIColor, borderWidth: CGFloat, width: CGFloat) {
        let newBorder = CALayer()
        newBorder.backgroundColor = color.cgColor
        
        switch position {
        case .TOP:
            newBorder.frame = CGRect(x: 0, y: 0, width: width, height: borderWidth)
            
        case .BOTTOM:
            newBorder.frame = CGRect(x: 0, y: toView.frame.size.height-borderWidth, width: width, height: borderWidth)
            
        case .LEFT:
            newBorder.frame = CGRect(x:0, y: 0, width: borderWidth, height: toView.frame.size.height)
            
        case .RIGHT:
            newBorder.frame = CGRect(x: toView.frame.size.width-borderWidth, y: 0, width: 1, height: toView.frame.size.height)
        }
        
        toView.layer.addSublayer(newBorder)
    }
    
    func setTextWithAnimation(onView: UILabel, text: String) {
        
        let charArray = Array(text.characters)
        print("\n charArray : \(charArray)")
        onView.text = ""
        
        strIndex = 0
        
        self.addNextChar(onView: onView, str: text)
    }
    
    func addNextChar(onView: UILabel, str: String) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            if self.isProfileVCVisible {
                print("onView.text \(onView.text)")
                let charArray = Array(str.characters)
                if charArray.count > 0 { 
                    onView.text = onView.text?.appending(String(charArray[self.strIndex]))
                    self.strIndex += 1
                    
                    if self.strIndex < charArray.count { 
                        self.addNextChar(onView: onView, str: str)
                    }
                    else if !self.shouldStopAnimate {
                        self.setCityName(cityName: self.currentlyShowingUser["homeCity"].stringValue, countryName: self.currentlyShowingUser["homeCountry"]["name"].stringValue)
                    }
                }
            }
        }
        
    }       
}


//MARK: - Profile Cell

class TLProfileDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    
}


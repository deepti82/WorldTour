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
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    @IBOutlet weak var exploreMyLifeView: UIView!
    
    var currentlyShowingUser: JSON = []
    var isShowingSelf = true
    
    var strIndex = 0
    var shouldStopAnimate = false
    
    var myLifeVC:MyLifeViewController!
    var displayData: String = ""
    
    var loader = LoadingOverlay()
    
    var labels = [["count":"0","text":"Following"],
                  ["count":"0","text":"Followers"],
                  ["count":"0","text":"Countries Visited"],
                  ["count":"0","text":"Bucket List"],
                  ["count":"0","text":"Journeys"],
                  ["count":"0","text":"Check Ins"],
                  ["count":"0","text":"Photos"],
                  ["count":"0","text":"Reviews"]]

    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        getDarkBackGround(self)
        
        getUnreadNotificationCount()

        self.userNameLabel.text = ""
        self.cityNameLabel.text = ""
        
        loader.showOverlay(self.view)
        
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        
        //myLifeVC instance created 
        myLifeVC = storyboard?.instantiateViewController(withIdentifier: "myLife") as! MyLifeViewController
        myLifeVC.whatEmptyTab = "Journeys"
        
        self.setNavigationBar()
        
        self.getUser()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectedUser = currentlyShowingUser
        
        if (currentlyShowingUser.isEmpty) {            
            self.getUser()
        }
        
        if isCountryAdded {
            isCountryAdded = false
            getUser()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        globalNavigationController = self.navigationController
        
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - UI
    
    func setNavigationBar(){
        
        if displayData == "search" {
            let leftButton = UIButton()
            leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
            leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
            leftButton.imageView?.image = leftButton.imageView?.image!.withRenderingMode(.alwaysTemplate)
            leftButton.imageView?.tintColor = UIColor.white
            
            
            let rightButton = UIButton()
            rightButton.titleLabel?.font = avenirFont
            setFollowButtonTitle(button: rightButton, followType: currentlyShowingUser["following"].intValue, otherUserID: currentlyShowingUser["_id"].stringValue)
            rightButton.addTarget(self, action: #selector(self.rightFollowTapped(sender:)), for: .touchUpInside)
            rightButton.frame = CGRect(x: 1000000, y: 5, width: 100, height: 40)
            self.customNavigationBar(left: leftButton, right: rightButton)
        }else{
            let rightButton = UIButton()
            rightButton.setImage(UIImage(named: "search_toolbar"), for: UIControlState())
            rightButton.addTarget(self, action: #selector(self.searchTapped(_:)), for: .touchUpInside)
            rightButton.frame = CGRect(x: -10, y: 8, width: 30, height: 30)
            self.setOnlyRightNavigationButton(rightButton)
        }
    }
    
    func updateUI() {
        
        self.addBorder(toView: self.profileCollectionView, position: layerEdge.TOP, color: UIColor.white, borderWidth: CGFloat(1), width: self.profileCollectionView.contentSize.width)
        self.addBorder(toView: self.profileCollectionView, position: layerEdge.BOTTOM, color: UIColor.white, borderWidth: CGFloat(1), width: self.profileCollectionView.contentSize.width)
        
        flagImageView.layer.masksToBounds = false
        flagImageView.layer.cornerRadius = flagImageView.frame.height/2
        flagImageView.clipsToBounds = true
        
        exploreMyLifeView.layer.cornerRadius = (exploreMyLifeView.frame.size.height * 0.15)
    }
    
    func setUserName(username: String) {
        self.shouldStopAnimate = false
        self.userNameLabel.text = ""
        self.setTextWithAnimation(onView: self.userNameLabel, text: username)
    }
    
    func setCityName(cityName: String) {
        self.shouldStopAnimate = true
        self.cityNameLabel.text = ""
        self.setTextWithAnimation(onView: self.cityNameLabel, text: "LIVES IN : \(cityName))")
    }
    
    func setData() {
        
        self.loader.hideOverlayView()
        
        if shouldRestrictCurrentUserProfile() {
            //Private Account
            moreAboutMeLabel.text = "This Account Is Private"
            moreAboutMeLabel.textColor = mainOrangeColor
            moreAboutMeButton.isHidden = true
            
            exploreMyLifeView.isUserInteractionEnabled = false
            exploreMyLifeView.backgroundColor = UIColor.lightGray
        }
        else {
            moreAboutMeLabel.text = "more about me..."
            moreAboutMeLabel.textColor = UIColor.white
            moreAboutMeButton.isHidden = false
            
            exploreMyLifeView.isUserInteractionEnabled = true
            exploreMyLifeView.backgroundColor = mainOrangeColor //TODO:Change this color later            
        }
        
        if currentlyShowingUser != nil {
            
            self.title = "My Life"
            
            print("==========\(currentUser)")
            
            self.userProfileImageView.hnk_setImageFromURL(getImageURL(currentlyShowingUser["profilePicture"].stringValue, width: 0))
            
            setUserName(username: currentlyShowingUser["name"].stringValue)
            
            if currentlyShowingUser["homeCountry"] != nil {
                self.countryNameLabel.text = currentlyShowingUser["homeCountry"]["name"].stringValue
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
        let cellWidth = (getTextSize(text: labels[indexPath.row]["text"]!).width + CGFloat(30))
        return CGSize(width: cellWidth, height: profileCollectionView.bounds.height - 1)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProfileDetailCell
        cell.separatorView.isHidden = false
        
        cell.infoLabel.text = labels[indexPath.row]["text"]
        cell.countLabel.text = labels[indexPath.row]["count"]
        
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
            UIView.animate(withDuration: 1) {
                self.viewDidLayoutSubviews()
                self.MAMTextViewHeightConstraint.constant = 30
                self.MAMTextView.frame.size.height = 30
                self.mamStackView.tag = 1
            }
        }
        else {
            self.MAMTextViewHeightConstraint.constant = 0
            self.MAMTextView.frame.size.height = 0
            self.mamStackView.tag = 0
        }
        
        
        
    }
    
    func exploreMyLife(selectionTab: String) {
        let myLifeViewCtrllr = storyboard?.instantiateViewController(withIdentifier: "myLife") as! MyLifeViewController
        myLifeViewCtrllr.whatEmptyTab = whichView
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
            if !isShowingSelf {
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
        request.getUser(user.getExistingUser(), urlSlug:selectedUser["urlSlug"].stringValue, completion: {(request) in
            DispatchQueue.main.async {
                self.currentlyShowingUser = request["data"]
                if self.displayData == "search" {
                    self.setNavigationBar()
                    self.isShowingSelf = false
                }
                else {
                    currentUser = request["data"]
                    self.isShowingSelf = true
                }
                
                self.setData()
            }
        });
    }
    
    func shouldRestrictCurrentUserProfile() -> Bool {
        if(!selectedUser.isEmpty && (currentlyShowingUser["status"].stringValue == "private" && (currentlyShowingUser["following"].intValue != 1))) {
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
            print("onView.text \(onView.text)")
            let charArray = Array(str.characters)
            onView.text = onView.text?.appending(String(charArray[self.strIndex]))
            self.strIndex += 1
            
            if self.strIndex < charArray.count { 
                self.addNextChar(onView: onView, str: str)
            }
            else if !self.shouldStopAnimate {
                self.setCityName(cityName: self.currentlyShowingUser["homeCity"].stringValue)
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


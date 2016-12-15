//
//  ProfileViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 21/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import DKChainableAnimationKit

var doRemove: Bool = true

class ProfileViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profile_badge: UIImageView!
//    @IBOutlet weak var profileLocation: UILabel!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var isPhotographer: UILabel!
    
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
        initialLogin = false
        self.navigationController?.isNavigationBarHidden = false
        getDarkBackGround(self)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "search_toolbar"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(ProfileViewController.search(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: -10, y: 8, width: 30, height: 30)
        self.setOnlyRightNavigationButton(rightButton)
        self.allCount = currentUser
        self.getUser()
        
        locationIcon.text = String(format: "%C", faicon["location"]!)
        
        let profile = ProfilePicFancy(frame: CGRect(x: 10, y: 0, width: profileView.frame.width, height: profileView.frame.height))
        profile.backgroundColor = UIColor.clear
        profileView.addSubview(profile)
        
        let footer = FooterViewNew(frame: CGRect(x: 0, y: self.view.frame.height - 50, width: self.view.frame.width, height: 55))
        self.view.addSubview(footer)
        
        let tlTap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.gotoOTG(_:)))
        footer.TLView.addGestureRecognizer(tlTap)
        let tapFour = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.openNotifications(_:)))
        footer.notifyView.addGestureRecognizer(tapFour)
        
        
        
        profilePicture.isHidden = true
        
        MAMatterView.layer.opacity = 0.0
        
        MAMButton.transform = MAMButton.transform.rotated(by: CGFloat(M_PI))
        
        let MAM = MoreAboutMe(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 20, height: 150))
        MAM.backgroundColor = UIColor.clear
        MAMatterView!.addSubview(MAM)
        
        var imageName = ""
        
        if currentUser != nil {
            self.title = "\(currentUser["firstName"])'s Profile"
            profileUsername.text = "\(currentUser["firstName"].string!) \(currentUser["lastName"].string!)"
            imageName = currentUser["profilePicture"].string!
            
            if currentUser["homeCountry"] != nil {
                
                profile.country.text = currentUser["homeCountry"]["name"].string!
                
            }
            
            if currentUser["homeCity"] != nil {
                let place = currentUser["homeCity"].string!.components(separatedBy: ",")
                placeLabel.text = " \(place[0])"
                
            }
            
            if currentUser["isBlogger"] != nil && currentUser["isBlogger"].bool! {
                
                self.isPhotographer.text = "Blogger"
                
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
        
        let orangeTab = OrangeButton(frame: CGRect(x: 5, y: self.view.frame.size.height - 110, width: self.view.frame.size.width - 10, height: 55))
        orangeTab.orangeButtonTitle.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        orangeTab.orangeButtonTitle.setTitle("My Life", for: UIControlState())
        let fontAwesomeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: orangeTab.frame.size.height))
        fontAwesomeLabel.center = CGPoint(x: 90, y: orangeTab.orangeButtonTitle.titleLabel!.frame.size.height/2 + 10)
        fontAwesomeLabel.font = FontAwesomeFont
        fontAwesomeLabel.text = String(format: "%C", faicon["angle_up"]!)
        fontAwesomeLabel.textColor = UIColor.white
        orangeTab.orangeButtonTitle.titleLabel!.addSubview(fontAwesomeLabel)
        self.view.addSubview(orangeTab)
        
        orangeTab.orangeButtonTitle.addTarget(self, action: #selector(ProfileViewController.MyLifeDetailsShow(_:)), for: .touchUpInside)
        
        MAMStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.MAMStacKTap(_:))))
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidLoad()
    }
    
    func getUser() {
        
        if user.getExistingUser() == "" {
            
            var socialType = ""
            var socialId = ""
            
            if currentUser["googleID"].string! != "" {
                socialType = "google"
                socialId = currentUser["googleID"].string!
            }
            else if currentUser["instagramID"].string! != "" {
                socialType = "instagram"
                socialId = currentUser["instagramID"].string!
            }
            else if currentUser["twitterID"].string! != "" {
                socialType = "twitter"
                socialId = currentUser["twitterID"].string!
            }
            else if currentUser["facebookID"].string! != "" {
                socialType = "facebook"
                socialId = currentUser["facebookID"].string!
            }
            user.setUser(currentUser["_id"].stringValue, name: currentUser["name"].stringValue, useremail: currentUser["email"].stringValue, profilepicture: currentUser["profilePicture"].stringValue, travelconfig: "", loginType: socialType, socialId: socialId, userBadge: currentUser["userBadgeImage"].stringValue, homecountry: currentUser["homeCountry"]["name"].stringValue, homecity: currentUser["homeCity"].stringValue, isloggedin: currentUser["alreadyLoggedIn"].bool!)
            request.getUser(user.getExistingUser(), completion: {(request) in
                DispatchQueue.main.async {
                    currentUser = request["data"]
                    self.setCount()
                }
            });
           
        }
        else {
            let currentUserId = user.getExistingUser()
            let myUser = user.getUser(currentUserId)
            let nameTemp = myUser.0.components(separatedBy: " ")
            request.getUser(user.getExistingUser(), completion: {(request) in
                DispatchQueue.main.async {
                    currentUser = request["data"]
                    self.setCount()
                }
            });
            
            
        }
        
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
            }
            self.navigationController?.pushViewController(tlVC, animated: false)
            
            
        }
    }
    
    func MAMStacKTap(_ sender: UITapGestureRecognizer) {
        self.MAMTapped(sender)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func search(_ sender: AnyObject) {
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myValues = labels[(indexPath as NSIndexPath).item]
        
        print(myValues);
        let valueArray = myValues.characters.split{$0 == " "}.map(String.init)
        
        let textOne = NSAttributedString(string: valueArray[0], attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
        let textTwo = NSMutableAttributedString(string: valueArray[1], attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 12)!])
        
        if valueArray.count > 2 {
            let textThree = NSAttributedString(string: valueArray[2], attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 12)!])
            textTwo.append(NSAttributedString(string: " "))
            textTwo.append(textThree)
        }
        
        let fullText = NSMutableAttributedString(attributedString: textOne)
        fullText.append(NSAttributedString(string: "\n"))
        fullText.append(textTwo)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProfileDetailCell
        cell.infoLabel.attributedText = fullText
        
        if (indexPath as NSIndexPath).row == labels.count - 1 {
            cell.separatorView.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labels.count
    }
    
    func gotoBucketList() {
        
        request.getBucketListCount(currentUser["_id"].string!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if let error = response.error {
                }
                    
                else if response["value"].bool! {
                    
                    if response["data"]["bucketList_count"].int == 0 {
                        
                        let bucketVC = self.storyboard?.instantiateViewController(withIdentifier: "emptyPages") as! EmptyPagesViewController
                        bucketVC.whichView = "BucketList"
                        self.navigationController?.pushViewController(bucketVC, animated: true)
                        
                    }
                        
                    else if response["data"]["bucketList_count"] != nil {
                        
                        let bucketVC = self.storyboard?.instantiateViewController(withIdentifier: "bucketList") as! BucketListTableViewController
                        bucketVC.whichView = "BucketList"
                        self.navigationController?.pushViewController(bucketVC, animated: true)
                        
                    }
                        
                    else {
                        
                        print("some problem idk")
                    }
                    
                }
                    
                else {
                    
                    print("response error: \(response["error"])")
                }
                
            })
            
        })
        
    }
    
    func gotoCountriesVisited() {
        
        request.getBucketListCount(currentUser["_id"].string!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if let error = response.error {
                    
                    print("error- \(error.code): \(error.localizedDescription)")
                    
                }
                    
                else if response["value"].bool! {
                    
                    if response["data"]["countriesVisited_count"].int == 0 {
                        
                        let bucketVC = self.storyboard?.instantiateViewController(withIdentifier: "emptyPages") as! EmptyPagesViewController
                        bucketVC.whichView = "CountriesVisited"
                        self.navigationController?.pushViewController(bucketVC, animated: true)
                        
                    }
                        
                    else if response["data"]["countriesVisited_count"] != nil {
                        
                        let bucketVC = self.storyboard?.instantiateViewController(withIdentifier: "bucketList") as! BucketListTableViewController
                        bucketVC.whichView = "CountriesVisited"
                        self.navigationController?.pushViewController(bucketVC, animated: true)
                        
                    }
                        
                    else {
                        
                        print("some problem idk")
                    }
                    
                }
                    
                else {
                    
                    print("response error: \(response["error"])")
                }
                
            })
            
        })
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
        
        let myLifeVC = storyboard?.instantiateViewController(withIdentifier: "myLife") as! MyLifeViewController
        self.navigationController?.present(myLifeVC, animated: true, completion: nil)
        
    }
    
    
}


class ProfileDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
}

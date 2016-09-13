//
//  ProfileViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 21/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import DKChainableAnimationKit
import SwiftyJSON

var doRemove: Bool = true

class ProfileViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profile_badge: UIImageView!
//    @IBOutlet weak var profileLocation: UILabel!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var isPhotographer: UILabel!
    
    var labels = ["0 Following", "0 Followers", "0 Countries Visited", "0 Bucket List", "0 Journeys", "0 Check Ins", "0 Photos", "0 Reviews"]
    dynamic var profileViewYPosition: CGFloat = 0
    
    private var kvoContext: UInt8 = 0
    
    @IBOutlet weak var MAMStack: UIStackView!
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet weak var MAMatterView: UIView!
    var MAMScrollView: UIScrollView?
    
    @IBOutlet weak var mainProfileView: UIView!
    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var locationIcon: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    var toggle = false
    var initialEntrance = false
    
    
    @IBOutlet weak var MAMButton: UIButton!
    @IBAction func MAMTapped(sender: AnyObject?) {
        
        if !toggle {
            
            MAMButton.transform = CGAffineTransformRotate(MAMButton.transform, CGFloat(M_PI))
            MAMatterView.animation.makeOpacity(1.0).animate(0.25)
            mainProfileView.animation.moveY(-80.0).moveHeight(80.0).animate(0.25)
            toggle = true
        }
        
        else {
            
            MAMButton.transform = CGAffineTransformRotate(MAMButton.transform, CGFloat(M_PI))
            MAMatterView.animation.makeOpacity(0.0).animate(0.25)
            mainProfileView.animation.moveY(80.0).makeHeight(350.0).animate(0.25)
            toggle = false
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
//        if initialEntrance {
//            
////            doRemove = false
//            slideMenuController()?.changeMainViewController(self, close: false)
//            initialEntrance = false
//            
//        }
        
    }
    
    var allCount: JSON!
    
    func getCount() {
        
        print("in get count")
        
        request.getBucketListCount(currentUser["_id"].string!, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error?.localizedDescription)")
                    
                }
                    
                else if response["value"] {
                    
                    self.allCount = response["data"]
                    self.setCount()
                }
                    
                else {
                    
                    print("response error: \(response["error"])")
                    
                }
                
            })
            
            
        })
        
        
    }
    
    func setCount() {
        
        print("in set count")
        
        for i in 0 ..< labels.count {
            
            switch i {
            case 0:
                labels[0] = "\(allCount["following_count"]) Following"
                break
            case 1:
                labels[1] = "\(allCount["followers_count"]) Followers"
                break
            case 2:
                labels[2] = "\(allCount["countriesVisited_count"]) Countries Visited"
                break
            case 3:
                labels[3] = "\(allCount["bucketList_count"]) Bucket List"
                break
            case 4:
                labels[4] = "\(allCount["journeysCreated_count"]) Journeys"
                break
            case 5:
                labels[5] = "\(allCount["checkins_count"]) Check Ins"
                break
            case 6:
                labels[6] = "\(allCount["photos_count"]) Photos"
                break
            case 7:
                labels[7] = "\(allCount["reviews_count"]) Reviews"
                break
            default:
                break
            }
        }
        
        profileCollectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLogin = false
        self.navigationController?.navigationBarHidden = false
        getDarkBackGround(self)
        
        print("navigation: \(self.navigationController)")
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "search_toolbar"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(ProfileViewController.search(_:)), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRectMake(-10, 8, 30, 30)
        self.setOnlyRightNavigationButton(rightButton)
        
        locationIcon.text = String(format: "%C", faicon["location"]!)
        
        let profile = ProfilePicFancy(frame: CGRect(x: 10, y: 0, width: profileView.frame.width, height: profileView.frame.height))
        profile.backgroundColor = UIColor.clearColor()
        profileView.addSubview(profile)
        
        let footer = FooterViewNew(frame: CGRect(x: 0, y: self.view.frame.height - 50, width: self.view.frame.width, height: 55))
        self.view.addSubview(footer)
        
        let tlTap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.gotoOTG(_:)))
        footer.TLView.addGestureRecognizer(tlTap)
        
        getCount()
        
        
        
//        if currentUser != nil {
//            
//            
//            
//            
//            
//        }
        
        MAMatterView.layer.opacity = 0.0
//         let footer = getFooter(frame: CGRect(x: 0, y: self.view.frame.height - 45, width: self.view.frame.width, height: 45))
//        footer.layer.zPosition = 100
//        self.view.addSubview(footer)
        
//        let profileSquare = ProfileMainView(frame: CGRect(x: 10, y: self.view.frame.size.height/3 - 100, width: self.view.frame.size.width - 20,  height: 500))
//        self.view.addSubview(profileSquare)
        
//        MAMScrollView = UIScrollView(frame: CGRect(x: 10, y: self.view.frame.size.height/3 - 45, width: self.view.frame.size.width - 20, height: 600))
//        MAMScrollView!.scrollEnabled = true
//        self.view.addSubview(MAMScrollView!)
//      
        MAMButton.transform = CGAffineTransformRotate(MAMButton.transform, CGFloat(M_PI))
        
        let MAM = MoreAboutMe(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 20, height: 150))
        MAM.backgroundColor = UIColor.clearColor()
        MAMatterView!.addSubview(MAM)
        
        var imageName = ""
        
        if currentUser != nil {
            
            //            print("inside if statement \(sideMenu.profilePicture)")
            self.title = "\(currentUser["firstName"])'s Profile"
            profileUsername.text = "\(currentUser["firstName"].string!) \(currentUser["lastName"].string!)"
            imageName = currentUser["profilePicture"].string!
            
            if currentUser["homeCountry"] != nil {
                
                profile.country.text = currentUser["homeCountry"].string!
                
            }
            
            if currentUser["homeCity"] != nil {
                
                let place = currentUser["homeCity"].string!.componentsSeparatedByString(",")
                
                print("place: \(place)")
                
                placeLabel.text = " \(place[0])"
                
            }
            
            if currentUser["isBlogger"] {
                
                isPhotographer.text = "Blogger"
                
            }
            
            
            print("image: \(imageName)")
            
            let isUrl = verifyUrl(imageName)
            print("isUrl: \(isUrl)")
            
            if isUrl {
                
                print("inside if statement")
                let data = NSData(contentsOfURL: NSURL(string: imageName)!)
                
                if data != nil {
                    
                    print("some problem in data \(data)")
                    //                uploadView.addButton.setImage(, forState: .Normal)
                    profilePicture.image = UIImage(data: data!)
                    profile.image.image = UIImage(data: data!)
//                    makeTLProfilePicture(profile.image)
                    makeTLProfilePicture(profilePicture)
                }
            }
                
            else {
                
                let getImageUrl = adminUrl + "upload/readFile?file=" + imageName + "&width=100"
                
//                print("getImageUrl: \(getImageUrl)")
                
                let data = NSData(contentsOfURL: NSURL(string: getImageUrl)!)
//                print("data: \(data)")
                
                if data != nil {
                    
                    //                uploadView.addButton.setImage(UIImage(data:data!), forState: .Normal)
                    print("inside if statement \(profilePicture.image)")
                    profilePicture.image = UIImage(data: data!)
                    print("sideMenu.profilePicture.image: \(profilePicture.image)")
                    profile.image.image = UIImage(data: data!)
                    makeTLProfilePicture(profilePicture)
                }
                
            }
            
        }

//
//        MAMScrollView!.contentSize.height = 750
//        MAMScrollView?.delegate = self
        
        let orangeTab = OrangeButton(frame: CGRect(x: 5, y: self.view.frame.size.height - 110, width: self.view.frame.size.width - 10, height: 55))
        orangeTab.orangeButtonTitle.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        orangeTab.orangeButtonTitle.setTitle("My Life", forState: .Normal)
        let fontAwesomeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: orangeTab.frame.size.height))
        fontAwesomeLabel.center = CGPointMake(90, orangeTab.orangeButtonTitle.titleLabel!.frame.size.height/2 + 10)
        fontAwesomeLabel.font = FontAwesomeFont
        fontAwesomeLabel.text = String(format: "%C", faicon["angle_up"]!)
        fontAwesomeLabel.textColor = UIColor.whiteColor()
        orangeTab.orangeButtonTitle.titleLabel!.addSubview(fontAwesomeLabel)
        self.view.addSubview(orangeTab)
        
        orangeTab.orangeButtonTitle.addTarget(self, action: #selector(ProfileViewController.MyLifeDetailsShow(_:)), forControlEvents: .TouchUpInside)
        
//        self.view.bringSubviewToFront(profileCollectionView)
        
//        self.addObserver(self, forKeyPath: "profileViewYPosition", options: .New, context: nil)
        
//        profileViewYPosition = profileViewY
        
//        self.view.setNeedsDisplay()
        
        MAMStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.MAMStacKTap(_:))))
    }
    
//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        
//        print("this function is getting called!!")
//        
//    }
    
    func gotoOTG(sender: UITapGestureRecognizer) {
        
        let tlVC = storyboard?.instantiateViewControllerWithIdentifier("newTL") as! NewTLViewController
        self.navigationController?.pushViewController(tlVC, animated: false)
        
    }
    
    func MAMStacKTap(sender: UITapGestureRecognizer) {
        
        self.MAMTapped(sender)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func search(sender: AnyObject) {
        
        print("Search Tapped!")
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let myValues = labels[indexPath.item]
        let valueArray = myValues.characters.split{$0 == " "}.map(String.init)
        
        let textOne = NSAttributedString(string: valueArray[0], attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
        let textTwo = NSMutableAttributedString(string: valueArray[1], attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 12)!])
        
        if valueArray.count > 2 {
        
            let textThree = NSAttributedString(string: valueArray[2], attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 12)!])
            textTwo.appendAttributedString(NSAttributedString(string: " "))
            textTwo.appendAttributedString(textThree)
            
        }
        
        let fullText = NSMutableAttributedString(attributedString: textOne)
        fullText.appendAttributedString(NSAttributedString(string: "\n"))
        fullText.appendAttributedString(textTwo)
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ProfileDetailCell
        cell.infoLabel.attributedText = fullText
//        print("Loading \(cell.infoLabel.attributedText)")
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return labels.count
        
    }
    
    func gotoBucketList() {
        
        request.getBucketListCount(currentUser["_id"].string!, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if let error = response.error {
                    
                    print("error- \(error.code): \(error.localizedDescription)")
                    
                }
                    
                else if response["value"] {
                    
                    if response["data"]["bucketList_count"].int == 0 {
                        
                        let bucketVC = self.storyboard?.instantiateViewControllerWithIdentifier("emptyPages") as! EmptyPagesViewController
                        bucketVC.whichView = "BucketList"
                        self.navigationController?.pushViewController(bucketVC, animated: true)
                        
                    }
                        
                    else if response["data"]["bucketList_count"].int > 0 {
                        
                        let bucketVC = self.storyboard?.instantiateViewControllerWithIdentifier("bucketList") as! BucketListTableViewController
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
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if let error = response.error {
                    
                    print("error- \(error.code): \(error.localizedDescription)")
                    
                }
                    
                else if response["value"] {
                    
                    if response["data"]["countriesVisited_count"].int == 0 {
                        
                        let bucketVC = self.storyboard?.instantiateViewControllerWithIdentifier("emptyPages") as! EmptyPagesViewController
                        bucketVC.whichView = "CountriesVisited"
                        self.navigationController?.pushViewController(bucketVC, animated: true)
                        
                    }
                        
                    else if response["data"]["countriesVisited_count"].int > 0 {
                        
                        let bucketVC = self.storyboard?.instantiateViewControllerWithIdentifier("bucketList") as! BucketListTableViewController
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if toggle {
            
            MAMTapped(nil)
        }
        
        print("Selected item: \(indexPath.item)")
        
        switch indexPath.item {
        case 0:
            let followersVC = storyboard?.instantiateViewControllerWithIdentifier("followers") as! FollowersViewController
            followersVC.whichView = "Following"
            self.navigationController?.pushViewController(followersVC, animated: true)
            break
//            let followersVC = storyboard?.instantiateViewControllerWithIdentifier("NoFollowing") as! NoFollowingViewController
//            self.navigationController?.pushViewController(followersVC, animated: true)
//            break
        case 1:
//            let followersVC = storyboard?.instantiateViewControllerWithIdentifier("followers") as! FollowersViewController
//            followersVC.whichView = "No Followers"
//            self.navigationController?.pushViewController(followersVC, animated: true)
            let followersVC = storyboard?.instantiateViewControllerWithIdentifier("followers") as! FollowersViewController
            followersVC.whichView = "Followers"
            self.navigationController?.pushViewController(followersVC, animated: true)
            break
        case 2:
            gotoCountriesVisited()
//            let bucketVC = storyboard?.instantiateViewControllerWithIdentifier("bucketList") as! BucketListTableViewController
//            bucketVC.whichView = "CountriesVisited"
//            self.navigationController?.pushViewController(bucketVC, animated: true)
//            let noBucketVC = storyboard?.instantiateViewControllerWithIdentifier("emptyPages") as! EmptyPagesViewController
//            self.navigationController?.pushViewController(noBucketVC, animated: true)
            break
        case 3:
            gotoBucketList()
            break
        case 4 :
            let journeys = storyboard?.instantiateViewControllerWithIdentifier("allJourneysCreated") as! AllJourneysViewController
//            journeys.whichView = "All"
            self.navigationController?.pushViewController(journeys, animated: true)
            break
        case 5:
            let journeys = storyboard?.instantiateViewControllerWithIdentifier("allJourneysCreated") as! AllJourneysViewController
//            journeys.whichView = "All"
            self.navigationController?.pushViewController(journeys, animated: true)
            break
        case 6 :
            let photosVC = storyboard?.instantiateViewControllerWithIdentifier("multipleCollectionVC") as! MyLifeMomentsViewController
            photosVC.whichView = "All"
            self.navigationController?.pushViewController(photosVC, animated: true)
            break
        case 7 :
            let reviewsVC = storyboard?.instantiateViewControllerWithIdentifier("multipleTableVC") as! AccordionViewController
            self.navigationController?.pushViewController(reviewsVC, animated: true)
            break
        default:
            break
        }
        
    }
    
//    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        
//        print("fn 2")
//        scrollView.delegate = self
//        MAMScrollView?.layer.zPosition = 20
//        
//    }
//    
//    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        
//        
//        MAMScrollView?.layer.zPosition = 0
//    }
//    
//    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
//        
//        MAMScrollView?.layer.zPosition = 20
//        
//    }
//    
//    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
//        
//        MAMScrollView?.layer.zPosition = 0
//        
//    }
    
    func MyLifeDetailsShow(sender: AnyObject) {
        
        let myLifeVC = storyboard?.instantiateViewControllerWithIdentifier("myLife") as! MyLifeViewController
        self.navigationController?.presentViewController(myLifeVC, animated: true, completion: nil)
        
    }
    
    
}


class ProfileDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    
}

//
//  SideNavigationMenuViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 20/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

var initialLogin = true

class SideNavigationMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var mainViewController: UIViewController!
    var homeController:UIViewController!
    var popJourneysController:UIViewController!
    var exploreDestinationsController:UIViewController!
    var popBloggersController:UIViewController!
    var blogsController:UIViewController!
    var inviteFriendsController:UIViewController!
    var rateUsController:UIViewController!
    var feedbackController:UIViewController!
    var logOutController:UIViewController!
    var settingsViewController: UIViewController!
    var localLifeController: UIViewController!
    var myProfileViewController: UIViewController!
    
    let labels = ["Popular Journeys", "Explore Destinations", "Popular Bloggers", "Blogs", "Invite Friends", "Rate Us", "Feedback", "Log Out", "Local Life", "My Profile"]
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileNew: UIView!
    @IBAction func SettingsTap(_ sender: AnyObject) {
        
        self.slideMenuController()?.changeMainViewController(self.settingsViewController, close: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var imageName = ""
        
        print("in view did load, current user: \(currentUser)")
        
        let profile = ProfilePicFancy(frame: CGRect(x: 0, y: 0, width: profileNew.frame.width, height: profileNew.frame.height))
        profileNew.addSubview(profile)
        
        if currentUser != nil {
            
//            print("inside if statement \(sideMenu.profilePicture)")
            profileName.text = "\(currentUser["firstName"]) \(currentUser["lastName"])"
            imageName = currentUser["profilePicture"].string!
            print("image: \(imageName)")
            
            let isUrl = verifyUrl(imageName)
            print("isUrl: \(isUrl)")
            
            if isUrl {
                
                print("inside if statement")
                let data = try? Data(contentsOf: URL(string: imageName)!)
                
                if data != nil {
                    
                    print("some problem in data \(data)")
                    //                uploadView.addButton.setImage(, forState: .Normal)
                    profilePicture.image = UIImage(data: data!)
                    profile.image.image = UIImage(data: data!)
                    makeTLProfilePicture(profilePicture)
                }
            }
                
            else {
                
                let getImageUrl = adminUrl + "upload/readFile?file=" + imageName + "&width=100"
                
//                print("getImageUrl: \(getImageUrl)")
                
                let data = try? Data(contentsOf: URL(string: getImageUrl)!)
//                print("data: \(data)")
                
                if data != nil {
                    
                    //                uploadView.addButton.setImage(UIImage(data:data!), forState: .Normal)
                    print("inside if statement \(profilePicture.image)")
                    profilePicture.image = UIImage(data: data!)
                    profile.image.image = UIImage(data: data!)
                    print("sideMenu.profilePicture.image: \(profilePicture.image)")
                    makeTLProfilePicture(profilePicture)
                }
                
            }
            
        }

        
        let settingsVC = storyboard!.instantiateViewController(withIdentifier: "UserProfileSettings") as! UserProfileSettingsViewController
        self.settingsViewController = UINavigationController(rootViewController: settingsVC)
        
        let homeController = storyboard!.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        self.homeController = UINavigationController(rootViewController: homeController)
        
        let PJController = storyboard!.instantiateViewController(withIdentifier: "popularJourneys") as! PopularJourneysViewController
        self.popJourneysController = UINavigationController(rootViewController: PJController)
        
        let EDController = storyboard!.instantiateViewController(withIdentifier: "exploreDestinations") as! ExploreDestinationsViewController
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
        
        let logOutController = storyboard!.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        self.logOutController = UINavigationController(rootViewController: logOutController)
        
        let localLifeController = storyboard!.instantiateViewController(withIdentifier: "localLife") as! LocalLifeRecommendationViewController
        self.localLifeController = UINavigationController(rootViewController: localLifeController)
        
        let myProfileController = storyboard!.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        self.myProfileViewController = UINavigationController(rootViewController: myProfileController)
        
        self.mainViewController = UINavigationController(rootViewController: homeController)
        
//        let tapForProfile = UIGestureRecognizer(target: self, action: #selector(self.profileTap(_:)))
//        profileView.addGestureRecognizer(tapForProfile)
        
    }
    
    @IBAction func profileTap(_ sender: AnyObject) {
        
        self.slideMenuController()?.changeMainViewController(self.myProfileViewController, close: true)
        
    }
    
//    func profileTap (sender: UITapGestureRecognizer? = nil) {
//        
//        let myProfileController = storyboard!.instantiateViewControllerWithIdentifier("ProfileVC") as! ProfileViewController
//        self.myProfileViewController = UINavigationController(rootViewController: myProfileController)
//        
//    }

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
        cell.backgroundColor = mainBlueColor
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
            self.slideMenuController()?.changeMainViewController(self.logOutController, close: true)
        case 8:
            self.slideMenuController()?.changeMainViewController(self.localLifeController, close: true)
        default:
            self.slideMenuController()?.changeMainViewController(self.homeController, close: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! SideMenuTableViewCell
        cell.backgroundColor = mainGreenColor
        cell.menuLabel.textColor = mainBlueColor
        
    }

}

class SideMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuLabel: UILabel!
    
    
}

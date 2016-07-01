//
//  SideNavigationMenuViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 20/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

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
    
    
    
    let labels = ["Popular Journeys", "Explore Destinations", "Popular Bloggers", "Blogs", "Invite Friends", "Rate Us", "Feedback", "Log Out", "Local Life"]
    
    @IBOutlet weak var profileView: UIView!
    
    @IBAction func SettingsTap(sender: AnyObject) {
        
        self.slideMenuController()?.changeMainViewController(self.settingsViewController, close: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let settingsVC = storyboard.instantiateViewControllerWithIdentifier("UserProfileSettings") as! UserProfileSettingsViewController
        self.settingsViewController = UINavigationController(rootViewController: settingsVC)
        
        let homeController = storyboard.instantiateViewControllerWithIdentifier("Home") as! HomeViewController
        self.homeController = UINavigationController(rootViewController: homeController)
        
        let PJController = storyboard.instantiateViewControllerWithIdentifier("popularJourneys") as! PopularJourneysViewController
        self.popJourneysController = UINavigationController(rootViewController: PJController)
        
        let EDController = storyboard.instantiateViewControllerWithIdentifier("exploreDestinations") as! ExploreDestinationsViewController
        self.exploreDestinationsController = UINavigationController(rootViewController: EDController)
        
        let PBController = storyboard.instantiateViewControllerWithIdentifier("popularBloggers") as! PopularBloggersViewController
        self.popBloggersController = UINavigationController(rootViewController: PBController)
        
        let BlogsController = storyboard.instantiateViewControllerWithIdentifier("blogsList") as! BlogsListViewController
        self.blogsController = UINavigationController(rootViewController: BlogsController)
        
        let inviteController = storyboard.instantiateViewControllerWithIdentifier("followers") as! FollowersViewController
        self.inviteFriendsController = UINavigationController(rootViewController: inviteController)
        
        let rateUsController = storyboard.instantiateViewControllerWithIdentifier("rating") as! RatingReviewViewController
        self.rateUsController = UINavigationController(rootViewController: rateUsController)
        
        let FBController = storyboard.instantiateViewControllerWithIdentifier("emptyPages") as! EmptyPagesViewController
        self.feedbackController = UINavigationController(rootViewController: FBController)
        
        let logOutController = storyboard.instantiateViewControllerWithIdentifier("emptyPages") as! EmptyPagesViewController
        self.logOutController = UINavigationController(rootViewController: logOutController)
        
        let localLifeController = storyboard.instantiateViewControllerWithIdentifier("localLife") as! LocalLifeRecommendationViewController
        self.localLifeController = UINavigationController(rootViewController: localLifeController)
        
//        let tapForSettings = UIGestureRecognizer(target: self, action: #selector(self.profileTap(_:)))
//        profileView.addGestureRecognizer(tapForSettings)
        
    }
    
    @IBAction func profilTap(sender: AnyObject) {
        
        self.SettingsTap(sender)
        
    }
//    func profileTap (sender: UITapGestureRecognizer? = nil) {
//        
//        
//        
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! SideMenuTableViewCell
        cell.menuLabel.text = labels[indexPath.item]
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return labels.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch(indexPath.row)
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

}

class SideMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuLabel: UILabel!
    
    
}

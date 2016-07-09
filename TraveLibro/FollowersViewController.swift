//
//  FollowersViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 31/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class FollowersViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var mailShare: UIButton!
    @IBOutlet weak var whatsappShare: UIButton!
    @IBOutlet weak var facebookShare: UIButton!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var followerTable: UITableView!
    
    internal var whichView: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCheckInNavigationBarItem(self)
        
        if whichView == "Following" {
            
            shareView.removeFromSuperview()
            seperatorView.removeFromSuperview()
            tableHeightConstraint.constant = self.view.frame.height
        }
        
        else if whichView == "No Followers" {
            
            shareView.removeFromSuperview()
            seperatorView.removeFromSuperview()
            followerTable.removeFromSuperview()
            
            let nofollow = NoFollowers(frame: CGRect(x: 0, y: 75, width: self.view.frame.width, height: 250))
            self.view.addSubview(nofollow)
            
        }
            
        else {
            
            mailShare.setTitle(String(format: "%C", faicon["email"]!), forState: .Normal)
            whatsappShare.setTitle(String(format: "%C", faicon["whatsapp"]!), forState: .Normal)
            facebookShare.setTitle(String(format: "%C", faicon["facebook"]!), forState: .Normal)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! FollowersCell
        self.addStylingToButton(cell.followButton)
        cell.followButton.addTarget(self, action: #selector(FollowersViewController.followUser(_:)), forControlEvents: .TouchUpInside)
        cell.followButton.selected = false
        
        if whichView == "Following" {
            
            cell.followButton.backgroundColor = UIColor(red: 44/255, green: 55/255, blue: 87/255, alpha: 1)
            let followTick = UIImageView(frame: CGRect(x: -15, y: 2, width: 12, height: 12))
            followTick.image = UIImage(named: "correct-signal")
            cell.followButton.titleLabel?.addSubview(followTick)
            cell.followButton.setTitle("Following", forState: .Normal)
            cell.followButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            cell.followButton.contentHorizontalAlignment = .Right
            cell.followButton.selected = true
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return 10
        
    }
    
    func addStylingToButton(sender: UIButton) {
        
        sender.layer.borderColor = UIColor(red: 44/255, green: 55/255, blue: 87/255, alpha: 1).CGColor
        sender.layer.borderWidth = 1.0
        sender.layer.cornerRadius = 5
        
    }
    
    func followUser(sender: UIButton) {
        
        if !sender.selected {
            
            sender.backgroundColor = UIColor(red: 44/255, green: 55/255, blue: 87/255, alpha: 1)
            let followTick = UIImageView(frame: CGRect(x: -15, y: 2, width: 12, height: 12))
            followTick.image = UIImage(named: "correct-signal")
            sender.titleLabel?.addSubview(followTick)
            sender.setTitle("Following", forState: .Normal)
            sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            sender.contentHorizontalAlignment = .Right
            sender.selected = true
            
        }
        
        else {
            
            sender.backgroundColor = UIColor.whiteColor()
            sender.titleLabel?.textColor = UIColor.whiteColor()
            sender.setTitle("+ Follow", forState: .Normal)
            sender.setTitleColor(UIColor(red: 44/255, green: 55/255, blue: 87/255, alpha: 1), forState: .Normal)
            sender.contentHorizontalAlignment = .Center
            sender.selected = false
            
        }
        
        
    }

}

class FollowersCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
}


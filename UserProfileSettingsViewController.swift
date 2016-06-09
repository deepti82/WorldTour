//
//  UserProfileSettingsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class UserProfileSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let labels = ["Edit Profile - a little more about me", "Change Password", "Data Upload", "Privacy", "Report a Problem"]
    let sideImages = ["edit_profile_icon", "change_pswd_icon", "data_upload_icon", "privacy_icon", "report_icon"]
    
    @IBOutlet weak var settingsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        settingsTableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print("current section: \(indexPath.section)")
        
        if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("aboutCell") as! AboutTableViewCell
            return cell
            
        }
        
        else if indexPath.section == 1 {
            
            if indexPath.row == 2 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("dataUploadCell") as! SettingsTableViewCell
                return cell
                
            }
            
           let cell = tableView.dequeueReusableCellWithIdentifier("settingsCell") as! SettingsTableViewCell
           cell.settingsLabel.text = labels[indexPath.item]
           cell.LabelIcon.image = UIImage(named: sideImages[indexPath.item])
           return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("profileCell") as! MainProfileTableViewCell
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            
            return labels.count
            
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 100
        }
        
        return 45
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            
//            let viewController = storyboard?.instantiateViewControllerWithIdentifier("EditProfileViewController")
//            self.showViewController(viewController!, sender: nil)
            self.performSegueWithIdentifier("editProfile", sender: nil)
            
        }
        
        if indexPath.section == 2 {
           
            print("Section 2 selected")
            self.performSegueWithIdentifier("editSetting", sender: nil)
            
        }
        
        else {
            
            print("Section 1 selected")
            
            if indexPath.row == 2 {
                
                self.performSegueWithIdentifier("uploadSetting", sender: nil)
            }
            
            self.performSegueWithIdentifier("editSettingSectionOne", sender: nil)
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


class MainProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var DoB: UILabel!
    
}

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var LabelIcon: UIImageView!
    @IBOutlet weak var settingsLabel: UILabel!
    
}

class AboutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var aboutTL: UILabel!
    
}
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
        self.setNavigationBarItem()
        print("navigation controller: \(self.navigationController)")
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
        
        switch indexPath.section {
        case 0:
            print("selecting section 0 row 0")
            let profileEditVC = storyboard?.instantiateViewControllerWithIdentifier("EditProfile") as! EditProfileViewController
            self.navigationController?.pushViewController(profileEditVC, animated: true)
            break
        case 1:
            switch indexPath.row {
            case 0:
                print("selecting section 1 row 0")
                let editMAMVC = storyboard?.instantiateViewControllerWithIdentifier("EditSettings") as! EditSettingsViewController
                editMAMVC.whichView = "MAMView"
                self.navigationController?.pushViewController(editMAMVC, animated: true)
                break
            case 1:
                print("selecting section 1 row 1")
                let editNewPswdVC = storyboard?.instantiateViewControllerWithIdentifier("EditSettings") as! EditSettingsViewController
                editNewPswdVC.whichView = "NewPswdView"
                self.navigationController?.pushViewController(editNewPswdVC, animated: true)
                break
            case 2:
                print("selecting section 1 row 2")
                let dataUsageVC = storyboard?.instantiateViewControllerWithIdentifier("SettingsVC") as! SettingsViewController
                dataUsageVC.labels = ["Cellular and WiFi", "WiFi", "Cellular"]
                self.navigationController?.pushViewController(dataUsageVC, animated: true)
                break
            case 3:
                print("selecting section 1 row 3")
                let privacyVC = storyboard?.instantiateViewControllerWithIdentifier("SettingsVC") as! SettingsViewController
                privacyVC.labels = ["Public - Everyone", "Private - My Followers"]
                self.navigationController?.pushViewController(privacyVC, animated: true)
                break
            case 4:
                print("selecting section 1 row 4")
                let reportVC = storyboard?.instantiateViewControllerWithIdentifier("EditSettings") as! EditSettingsViewController
                reportVC.whichView = "ReportView"
                self.navigationController?.pushViewController(reportVC, animated: true)
                break
            default:
                break
            }
        case 2:
            print("selecting section 2 row 0")
            let aboutUsVC = storyboard?.instantiateViewControllerWithIdentifier("EditSettings") as! EditSettingsViewController
            aboutUsVC.whichView = "NoView"
            self.navigationController?.pushViewController(aboutUsVC, animated: true)
            break
        default:
            break
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
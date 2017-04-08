//
//  UserProfileSettingsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class UserProfileSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let labels = ["Little More About Me", "Privacy", "Report A Problem"]
    let section2Labels = ["About Us", "Terms & Conditions", "Privacy Policy"] 
    let sideImages = ["edit_profile_icon", "privacy_icon", "report_icon"]
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    //MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGround(self)
        
        self.setNavigationBarItem()
                
        settingsTableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsTableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(currentUserUpdated), name: NSNotification.Name(rawValue: "currentUserUpdated"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "currentUserUpdated"), object: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func currentUserUpdated() {
        settingsTableView.reloadData()
    }
    
    
    //MARK:- TableView Datasource and Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            return labels.count
        }
        else if section == 2 {
            return section2Labels.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath as NSIndexPath).section == 0 {
            
            return 100
        }
        
        return 45
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).section == 1 {
            
           let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as! SettingsTableViewCell
           cell.settingsLabel.text = labels[(indexPath as NSIndexPath).item]            
           cell.LabelIcon.image = UIImage(named: sideImages[indexPath.row])
           return cell
        }
            
        else if (indexPath as NSIndexPath).section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "aboutCell") as! AboutTableViewCell
            cell.aboutTL.text = labels[(indexPath as NSIndexPath).item]
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as! MainProfileTableViewCell
        makeTLProfilePicture(cell.profileImage)
        cell.profileImage.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])", width: 100))
        cell.profileName.text = currentUser["name"].stringValue
        cell.DoB.text = "Edit Profile"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath as NSIndexPath).section {
        case 0:            
            let profileEditVC = storyboard?.instantiateViewController(withIdentifier: "EditProfile") as! EditProfileViewController
            self.navigationController?.pushViewController(profileEditVC, animated: true)
            break
            
        case 1:
            switch (indexPath as NSIndexPath).row {
            case 0:                
                let editMAMVC = storyboard?.instantiateViewController(withIdentifier: "EditSettings") as! EditSettingsViewController
                editMAMVC.whichView = "MAMView"
                self.navigationController?.pushViewController(editMAMVC, animated: true)
                break
            case 1:
                let privacyVC = storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsViewController
                privacyVC.dataSourceOption = "privacyOptions"
                self.navigationController?.pushViewController(privacyVC, animated: true)
                break
            case 2:
                let reportVC = storyboard?.instantiateViewController(withIdentifier: "EditSettings") as! EditSettingsViewController
                reportVC.whichView = "ReportView"
                self.navigationController?.pushViewController(reportVC, animated: true)
                break
            default:
                break
            }
            
        case 2:
            switch (indexPath as NSIndexPath).row {
            case 0:                
                let aboutUsVC = storyboard?.instantiateViewController(withIdentifier: "EditSettings") as! EditSettingsViewController
                aboutUsVC.whichView = "AboutUsView"
                self.navigationController?.pushViewController(aboutUsVC, animated: true)
                break
            case 1:
                let aboutUsVC = storyboard?.instantiateViewController(withIdentifier: "EditSettings") as! EditSettingsViewController
                aboutUsVC.whichView = "terms&conditions"
                self.navigationController?.pushViewController(aboutUsVC, animated: true)
                break
            case 2:
                let aboutUsVC = storyboard?.instantiateViewController(withIdentifier: "EditSettings") as! EditSettingsViewController
                aboutUsVC.whichView = "privacyPolicy"
                self.navigationController?.pushViewController(aboutUsVC, animated: true)
                break
                
            default:
                break
            }           
            
        default:
            break
        }
        
        settingsTableView.deselectRow(at: indexPath, animated: true)
        
    }

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

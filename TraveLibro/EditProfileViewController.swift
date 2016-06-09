//
//  EditProfileViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 06/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let labels = ["Profile Photo", "16 Jan 1988", "Yash Chudasama", "Dream Destination", "Favourite City", "Nationality", "City", "Male"]
    var myView: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("profilePhotoCell") as! ProfilePhotoTableViewCell
            cell.accessoryType = .None
            return cell
            
        }
        
        else if indexPath.section == 1 || indexPath.section == 6 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("EditLabelCell") as! EditProfileTableViewCell
            cell.editLabel.text = labels[indexPath.section]
            cell.accessoryType = .DisclosureIndicator
            return cell
        }
        
        else if indexPath.section == 5 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("EditNationalityCell") as! EditProfileTableViewCell
            cell.editLabel.text = labels[indexPath.section]
            cell.accessoryType = .DisclosureIndicator
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EditLabelCell") as! EditProfileTableViewCell
        cell.editLabel.text = labels[indexPath.section]
        cell.accessoryType = .None
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        myView = tableView.indexPathForSelectedRow!.section
        
        switch myView {
        case 1, 7, 6:
            print("in 1 switch case")
            self.performSegueWithIdentifier("editDateETC", sender: nil)
            break
            
        case 5:
            self.performSegueWithIdentifier("editNationality", sender: nil)
            break
            
        default:
            break
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 8
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 15
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 75
        }
        
        return 50
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        
//        
//        
//    }
    
    override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
        
        if identifier == "editDateETC" {
            print("In segue fn: \(myView)")
            let childVC = storyboard?.instantiateViewControllerWithIdentifier("EditEdit")  as! EditEditProfileViewController
            childVC.whichView = myView
        }
        
    }
}


class EditProfileTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var editLabel: UILabel!
    
    
}

class ProfilePhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
}
//
//  EditProfileViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 06/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let labels = ["16 Jan 1988", "16 Jan 1988", "16 Jan 1988", "16 Jan 1988"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("profilePhotoCell") as! ProfilePhotoTableViewCell
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EditLabelCell") as! EditProfileTableViewCell
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return labels.count + 1
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 75
        }
        
        return 50
        
    }
    
}


class EditProfileTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var editLabel: UILabel!
    
    
}

class ProfilePhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
}
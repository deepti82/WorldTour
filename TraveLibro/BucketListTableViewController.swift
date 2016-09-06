//
//  BucketListTableViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 31/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftyJSON

class BucketListTableViewController: UITableViewController  {
    
    var whichView: String!
    var bucket: [JSON] = []
    var isComingFromEmptyPages = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.gotoProfile(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "add_fa_icon"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(BucketListTableViewController.addCountriesVisited(_:)), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRectMake(0, 8, 30, 30)
        
        self.customNavigationBar(leftButton, right: rightButton)
        
        if whichView == "BucketList" {
            
            self.title = "Bucket List"
            getBucketList()
            
        }
        
        if whichView == "CountriesVisited" {
            
            request.getCountriesVisited(currentUser["_id"].string!, completion: {(response) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if response.error != nil {
                        
                        print("error - \(response.error!.code): \(response.error!.localizedDescription)")
                    }
                    else if response["value"] {
                        
//                        self.bucket = response["data"]["countriesVisited"].array!
//                        self.tableView.reloadData()
                        
                    }
                    else {
                        
                        print("response error: \(response["data"])")
                        
                    }
                })
                
                
            })
            
            
        }
        
        tableView.separatorColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if isComingFromEmptyPages {
            
            print("has come here")
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotoProfile(sender: UIButton) {
        
        let profile = storyboard?.instantiateViewControllerWithIdentifier("ProfileVC") as! ProfileViewController
        self.navigationController?.pushViewController(profile, animated: true)
//        (ProfileViewController(), animated: true)
        
//        if ((self.navigationController?.viewControllers.contains(profile)) != nil) {
//            
//            let arrayOfVCs = self.navigationController!.viewControllers as Array
//            
//            let index = arrayOfVCs.indexOf(profile)
//            print("index: \(index)")
//            print("inside contains")
//            
//        }

//        for container in self.navigationController!.viewControllers {
//            
//            if container.isEqual(profile) {
//                
//                print("contains")
//                
//            }
//            
//        }
        
        
//        self.navigationController?.popToRootViewControllerAnimated(true)
//        self.navigationController?.popToViewController(, animated: true)
        
    }
    
    func getBucketList() {
        
            request.getBucketList(currentUser["_id"].string!, completion: {(response) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if response.error != nil {
                        
                        print("error - \(response.error?.code): \(response.error?.localizedDescription)")
                    }
                    else if response["value"] {
                        
//                        let profile = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2] as! ProfileViewController
//                        profile.setCount()
//                        profile.getCount()
                        
                        self.bucket = response["data"]["bucketList"].array!
                        if self.bucket.count == 0 {
                            
                            print("bucket list is empty")
                            let emptyBucket = self.storyboard?.instantiateViewControllerWithIdentifier("emptyPages") as! EmptyPagesViewController
                            emptyBucket.whichView = self.whichView
                            self.navigationController?.pushViewController(emptyBucket, animated: false)
                            
                        }
                        self.tableView.reloadData()
                        
                    }
                    else {
                        
                        print("response error: \(response["data"])")
                        
                    }
                })
                
            })
            
            
//        }
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if whichView == "BucketList" {
            
            return 1
            
        }
        
        return 1
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bucket.count
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if whichView == "BucketList" {
            
//            if indexPath.row % 2 == 0 {
            
                let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! BucketListTableViewCell
                cell.countryName.text = bucket[indexPath.row]["name"].string!
                cell.yearOfVisit.hidden = true
                return cell
                
//            }
//            
//            let cell = tableView.dequeueReusableCellWithIdentifier("SeperatorCell", forIndexPath: indexPath) as! NoViewTableViewCell
//            return cell
            
        }
        
//        if indexPath.row % 2 == 0 {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! BucketListTableViewCell
            return cell
            
//        }
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("SeperatorCell", forIndexPath: indexPath) as! NoViewTableViewCell
//        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
//        if indexPath.row % 2 == 0 {
        
            return 72
//        }
//        
//        return 3
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        if whichView == "BucketList" {
            let delete = UITableViewRowAction(style: .Destructive, title: "             ") { (action, indexPath) in
                
//                print("bucket list removal: \(self.bucket[indexPath.row]["_id"])")
                
                request.removeBucketList(currentUser["_id"].string!, country: self.bucket[indexPath.row]["_id"].string!, completion: {(response) in
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        if response.error != nil {
                            
                            print("error- \(response.error?.code): \(response.error?.localizedDescription)")
                            
                        }
                        else if response["value"] {
                            
//                            tableView.reloadData()
                            self.getBucketList()
                            
                        }
                        else {
                            
                            print("response error: \(response["error"])")
                            
                        }
                    })
                })
                
            }
            delete.backgroundColor = UIColor(patternImage: UIImage(named: "trash")!)
            return [delete]
        }
        
        let delete = UITableViewRowAction(style: .Normal, title: "") { (action, indexPath) in
            // delete item at indexPath
        }
        
//        let share = UITableViewRowAction(style: .Normal, title: "Disable") { (action, indexPath) in
//            // share item at indexPath
//        }
//        
//        share.backgroundColor = UIColor.blueColor()
        
        return [delete]
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 35
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if whichView == "CountriesVisited" {
            
            return "2016"
            
        }
        
        return nil
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    func addCountriesVisited(sender: UIButton) {
        
        if whichView == "BucketList" {
            
            let nextVC = storyboard?.instantiateViewControllerWithIdentifier("SelectCountryVC") as! SelectCountryViewController
            nextVC.whichView = "BucketList"
            print("bucket list \(bucket)")
            nextVC.alreadySelected = bucket
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        else {
            
            let nextVC = storyboard?.instantiateViewControllerWithIdentifier("SelectCountryVC") as! SelectCountryViewController
            nextVC.whichView = "CountriesVisited"
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
    }

}

class BucketListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryPicture: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var yearOfVisit: UILabel!
    
}

class NoViewTableViewCell: UITableViewCell {
    
    
    
}

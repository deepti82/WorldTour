//
//  BucketListTableViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 31/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class BucketListTableViewController: UITableViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.separatorColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! BucketListTableViewCell
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SeperatorCell", forIndexPath: indexPath) as! NoViewTableViewCell
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row % 2 == 0 {
            
            return 72
        }
        
        return 3
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        if indexPath.row % 2 == 0 {
            let delete = UITableViewRowAction(style: .Destructive, title: "             ") { (action, indexPath) in
                // delete item at indexPath
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
        
        return 80
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class BucketListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryPicture: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var yearOfVisit: UILabel!
    
}

class NoViewTableViewCell: UITableViewCell {
    
    
    
}

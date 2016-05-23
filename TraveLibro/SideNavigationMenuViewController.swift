//
//  SideNavigationMenuViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 20/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SideNavigationMenuViewController: UIViewController, UITableViewDataSource {

    let labels = ["Popular Journeys", "Explore Destinations", "Popular Bloggers", "Blogs", "Invite Friends", "Rate Us", "Feedback", "Log Out"]
    
    @IBOutlet weak var profileView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class SideMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuLabel: UILabel!
    
    
}

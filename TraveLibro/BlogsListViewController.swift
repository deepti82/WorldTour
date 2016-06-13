//
//  BlogsListViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 13/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class BlogsListViewController: UIViewController, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("blogCell") as! PopularBlogTableviewCell
        cell.LikeFA.text = String(format: "%C", faicon["likes"]!)
        cell.calendarFA.text = String(format: "%C", faicon["calendar"]!)
        cell.clockFA.text = String(format: "%C", faicon["clock"]!)
        return cell
        
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


class PopularBlogTableviewCell: UITableViewCell {
    
    @IBOutlet weak var LikeFA: UILabel!
    @IBOutlet weak var calendarFA: UILabel!
    @IBOutlet weak var clockFA: UILabel!
    
    
    
}
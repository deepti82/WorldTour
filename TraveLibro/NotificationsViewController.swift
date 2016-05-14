//
//  NotificationsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 14/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let statusView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
//        statusView.backgroundColor = mainBlueColor
//        self.view.addSubview(statusView)
        
        let header = NotificationsHeader(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        header.center = CGPointMake(self.view.frame.size.width/2, 20)
        header.backgroundColor = UIColor.whiteColor()
        header.layer.zPosition = 20
        self.view.addSubview(header)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! NotificationViewCell
        cell.profileImage.image = UIImage(named: "profile_icon")
        cell.notificationText.text = "mananvora liked your photo 2m"
        cell.thumbnail.image = UIImage(named: "photobar1")
        return cell
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

}


class NotificationViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var notificationText: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    
    
}

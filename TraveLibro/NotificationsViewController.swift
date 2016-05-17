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
        
        let header = NotificationsHeader(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 60))
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
        
        print(indexPath.item)
        if (indexPath.item == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("cellAdd") as! NotificationAddAlbumViewCell
            cell.profileImage.image = UIImage(named: "profile_icon")
            cell.notifyText.text = "Manan Vora wants to tag you in his On the Go Journey - London Diaries. Accept Manan Vora's request to create your travel memories together."
            cell.acceptButton.backgroundColor = mainOrangeColor
            cell.decilneButton.backgroundColor = UIColor(red: 167/255, green: 167/255, blue: 167/255, alpha: 255/255)
            cell.acceptButton.layer.cornerRadius = 5
            cell.decilneButton.layer.cornerRadius = 5
            let timestamp = DateAndTime(frame: CGRect(x: 60, y: 150, width: self.view.frame.size.width/2, height: 25))
            cell.addSubview(timestamp)
            return cell
            
        }
        
        
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! NotificationViewCell
            cell.profileImage.image = UIImage(named: "profile_icon")
            cell.notificationText.text = "mananvora liked your photo 2m"
            cell.thumbnail.image = UIImage(named: "photobar1")
            let timestamp = DateAndTime(frame: CGRect(x: 60, y: 70, width: self.view.frame.size.width/2, height: 25))
            cell.addSubview(timestamp)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.item == 0) {
            return 180
        }
        else {
            return 120
        }
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

class NotificationAddAlbumViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var notifyText: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var decilneButton: UIButton!
    
}

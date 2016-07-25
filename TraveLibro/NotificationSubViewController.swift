//
//  NotificationSubViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 25/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class NotificationSubViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var whichView: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if whichView == "Notify" {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("bigCell") as! NotifyBigTableViewCell
                cell.clockIcon.text = String(format: "%C", faicon["clock"]!)
                cell.calendarIcon.text = String(format: "%C", faicon["calendar"]!)
                cell.acceptButton.addTarget(self, action: #selector(NotificationSubViewController.acceptTag(_:)), forControlEvents: .TouchUpInside)
                cell.declineButton.addTarget(self, action: #selector(NotificationSubViewController.declineTag(_:)), forControlEvents: .TouchUpInside)
                return cell
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier("simpleCell") as! simpleNotifyTableViewCell
            cell.clockIcon.text = String(format: "%C", faicon["clock"]!)
            cell.calendarIcon.text = String(format: "%C", faicon["calendar"]!)
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell") as! messageNotifyTableViewCell
        return cell
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 25))
        header.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: 22))
        label.center.y = header.frame.height/2
        label.font = avenirFont
        label.textColor = UIColor.darkGrayColor()
        
        if section == 0 {
            
            label.text = "RECENT"
        }
        
        else {
            
            label.text = "OLDER"
        }
        header.addSubview(label)
        
        return header
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if whichView == "Notify" {
            
            if indexPath.row == 0 {
                
                return 180
            }
            
            return 65
            
        }
        
        return 55
        
    }
    
    func acceptTag(sender: UIButton) {
        
        print("in the accept tag button")
        
        
    }
    
    func declineTag(sender: UIButton) {
        
        print("in the decline tag button")
        
        
        
    }
    
}

class simpleNotifyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var actionText: UILabel!
    @IBOutlet weak var timeAgo: UILabel!
    @IBOutlet weak var clockIcon: UILabel!
    @IBOutlet weak var calendarIcon: UILabel!
    @IBOutlet weak var calendarText: UILabel!
    @IBOutlet weak var clockText: UILabel!
    @IBOutlet weak var imageForNotify: UIImageView!
    
}

class NotifyBigTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var notifyText: UITextView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var calendarIcon: UILabel!
    @IBOutlet weak var calendarText: UILabel!
    @IBOutlet weak var clockIcon: UILabel!
    @IBOutlet weak var clockText: UILabel!
    
}

class messageNotifyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var timeAgo: UILabel!
    @IBOutlet weak var imageForMessage: UIImageView!
    
}

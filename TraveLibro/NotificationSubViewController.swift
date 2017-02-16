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
    var notifications: [JSON] = []
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var notifyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDarkBackGroundBlur(self)
        notifyTableView.backgroundColor = UIColor.clear
        
        getNotification()
        
        notifyTableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNotification() {
        
        request.getNotify(currentUser["_id"].string!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    self.notifications = response["data"].array!
                    self.notifyTableView.reloadData()
                    
                }
                else {
                    
                    print("response error!")
                    
                }
                
            })
            
        })
        
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notifications.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellNotificationData = notifications[indexPath.row]
        
        let notificationType = cellNotificationData["type"].stringValue
        
        print("notificationType: \(notificationType)")
        switch notificationType {
        
        case "postTag":
            break
            
        case "journeyRequest":
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath) as? NotificationActionCell
            if cell == nil {
                cell = NotificationActionCell.init(style: .default, reuseIdentifier: "actionCell", notificationData: cellNotificationData, helper: self) 
            }
            cell?.setData(notificationData: cellNotificationData, helper: self)
            
            cell?.NFPermission.NFLeftButton.tag = indexPath.row
            cell?.NFPermission.NFRightButton.tag = indexPath.row
            
            cell?.backgroundColor = UIColor.clear
            return cell!
            
        case "postLike":
            fallthrough
            
        case "journeyComment":
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "acknolwdgeCell", for: indexPath) as? NotificationActionCell
            if cell == nil {
                cell = NotificationActionCell.init(style: .default, reuseIdentifier: "acknolwdgeCell", notificationData: cellNotificationData, helper: self) 
            }
            cell?.setData(notificationData: cellNotificationData, helper: self)
            
            cell?.backgroundColor = UIColor.clear
            return cell!
            
        case "userFollowing":
//            var cell = tableView.dequeueReusableCell(withIdentifier: cellNotificationData["type"].stringValue, for: indexPath) as? NotificationTableViewCell
//            if cell == nil {
//                cell = NotificationTableViewCell.init(style: .default, reuseIdentifier: cellNotificationData["type"].stringValue, notificationData: cellNotificationData) 
//            }
//            cell?.backgroundColor = UIColor.clear
//            return cell!
            break
        
        case "postTag":
            break
            
        default:
            break
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell") 
        }
        cell.backgroundColor = UIColor.clear
        return cell
        
    }
    
    /*func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.estimatedRowHeight = 145
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        let date = dateFormatter.date(from: notifications[indexPath.row]["createdAt"].string!)
        dateFormatter.dateFormat = "dd MMM, yyyy"
        timeFormatter.dateFormat = "hh:mm a"
        
        let getImageUrl = adminUrl + "upload/readFile?file=123"
        
        
        if notifications[(indexPath as NSIndexPath).row]["type"].string! == "request" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "bigCell") as! NotifyBigTableViewCell
            cell.acceptButton.tag = (indexPath as NSIndexPath).row
            cell.notifyText.text = notifications[(indexPath as NSIndexPath).row]["message"].string!
            cell.clockIcon.text = String(format: "%C", faicon["clock"]!)
            cell.calendarIcon.text = String(format: "%C", faicon["calendar"]!)
            cell.acceptButton.addTarget(self, action: #selector(NotificationSubViewController.acceptTag(_:)), for: .touchUpInside)
            cell.declineButton.addTarget(self, action: #selector(NotificationSubViewController.declineTag(_:)), for: .touchUpInside)
            
            cell.profile.image = nil
            cell.profile.hnk_setImageFromURL(URL(string:getImageUrl)!)
            makeTLProfilePicture(cell.profile)
            
            
            cell.calendarText.text = "\(dateFormatter.string(from: date!))"
            cell.clockText.text = "\(timeFormatter.string(from: date!))"
            
            cell.acceptButton.layer.cornerRadius = 3.0
            cell.declineButton.layer.cornerRadius = 3.0
            cell.acceptButton.clipsToBounds = true
            cell.declineButton.clipsToBounds = true
            
            return cell
            
//            if indexPath.row == 0 {
//                
//                
//            }
//            
//            let cell = tableView.dequeueReusableCellWithIdentifier("simpleCell") as! simpleNotifyTableViewCell
//            cell.clockIcon.text = String(format: "%C", faicon["clock"]!)
//            cell.calendarIcon.text = String(format: "%C", faicon["calendar"]!)
//            return cell
            
        }
        
        if notifications[(indexPath as NSIndexPath).row]["type"].string! == "post" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell") as! simpleNotifyTableViewCell
            cell.profile.image = nil
            
            cell.profile.hnk_setImageFromURL(URL(string:getImageUrl)!)
            makeTLProfilePicture(cell.profile)
            
            cell.calendarText.text = "\(dateFormatter.string(from: date!))"
            cell.clockText.text = "\(timeFormatter.string(from: date!))"
            
            cell.actionText.text = notifications[indexPath.row]["message"].string!
            cell.timeAgo.isHidden = true
            cell.clockIcon.text = String(format: "%C", faicon["clock"]!)
            cell.calendarIcon.text = String(format: "%C", faicon["calendar"]!)
            cell.imageForNotify.isHidden = true
            return cell
        }
        
        //if notifications[(indexPath as NSIndexPath).row]["type"].string! == "message" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as! messageNotifyTableViewCell
            cell.profile.image = nil
        
            cell.profile.hnk_setImageFromURL(URL(string:getImageUrl)!)
            makeTLProfilePicture(cell.profile)
        
            cell.calenderText.text = "\(dateFormatter.string(from: date!))"
            cell.clockText.text = "\(timeFormatter.string(from: date!))"
        
            cell.clockIcon.text = String(format: "%C", faicon["clock"]!)
            cell.calenderIcon.text = String(format: "%C", faicon["calendar"]!)
            cell.imageForMessage.isHidden = true
            cell.timeAgo.isHidden = true
//            cell.messageText.text = notifications[indexPath.row]["message"].string!
            return cell
        //}
        
    }*/
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 25))
//        header.backgroundColor = UIColor.whiteColor()
//        
//        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: 22))
//        label.center.y = header.frame.height/2
//        label.font = avenirFont
//        label.textColor = UIColor.darkGrayColor()
//        
//        if section == 0 {
//            
//            label.text = "RECENT"
//        }
//        
//        else {
//            
//            label.text = "OLDER"
//        }
//        header.addSubview(label)
//        
//        return header
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        if notifications[(indexPath as NSIndexPath).row]["type"].string! == "request" {
                
            return 300
//        }
            
        return 65
    
    }
    
    
    //MARK:- Button Action
    
    func acceptTag(_ sender: UIButton) {
        
        print("in the accept tag button, \(notifications[sender.tag]["journeyUnique"]), \(currentUser["_id"]), \(notifications[sender.tag]["inMiddle"])")
        
        request.acceptJourney(notifications[sender.tag]["journeyUnique"].string!, id: currentUser["_id"].string!, isInMiddle: "\(notifications[sender.tag]["inMiddle"])", completion: {(response) in
            
            if response.error != nil {
                
                print("error: \(response.error!.localizedDescription)")
                
            }
            else if response["value"].bool! {
                
                print("response arrived")
                let tl = self.storyboard!.instantiateViewController(withIdentifier: "newTL") as! NewTLViewController
                self.navigationController?.pushViewController(tl, animated: true)
                
            }
            else {
                
                print("response error")
            }
            
        })
        
    }
    
    func declineTag(_ sender: UIButton) {
        
        print("in the decline tag button")
        
    }
    
    
    
}

/*
class simpleNotifyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profile: UIImageView!
    //@IBOutlet weak var username: UILabel!
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
    @IBOutlet weak var calenderIcon: UILabel!
    @IBOutlet weak var clockIcon: UILabel!
    @IBOutlet weak var calenderText: UILabel!
    @IBOutlet weak var clockText: UILabel!
    
}
*/

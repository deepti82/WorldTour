//
//  NotificationSubViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 25/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Toaster

class NotificationSubViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var inMiddle: Bool! = true
    var whichView: String!
    var notifications: [JSON] = []
    let refreshControl = UIRefreshControl()
    var currentPageNumber = 0
    var hasNext = true
    var currentCellHeight = CGFloat(10)
    
    @IBOutlet weak var notifyTableView: UITableView!
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Notifications"
        
        getDarkBackGround(self)
        notifyTableView.backgroundColor = UIColor.clear
        
        getNotification()
        
        notifyTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Helper
    
    func getNotification() {
        
        currentPageNumber += 1
        
        if hasNext {
            
            Toast(text: "Please wait ...").show()
            
            request.getNotify(currentUser["_id"].string!, pageNumber: currentPageNumber,  completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    
                    if response.error != nil {
                        
                        print("error: \(response.error!.localizedDescription)")
                        
                    }
                    else if response["value"].bool! {
                        
                        ToastCenter.default.cancelAll()
                        let newResponse = response["data"].array!
                        
                        print("New Notification count: \(newResponse.count)")
                        if newResponse.isEmpty {
                            self.hasNext = false
                        }
                        
                        if self.notifications.isEmpty {
                            self.notifications = newResponse
                            if newResponse.isEmpty {
                                Toast(text: "No notifications for you....").show()
                            }
                        }
                        else {                        
                            self.notifications.append(contentsOf: newResponse)                            
                            DispatchQueue.global().async(execute: {
                                self.getNotification()                                
                            })
                        }
                        
                        if !(newResponse.isEmpty) {
                            self.notifyTableView.reloadData()                            
                        }                        
                    }
                    else {
                        
                        print("response error!")
                        
                    }
                    
                })
                
            })
        }
    }
    
    func canLoadCommentCell(notificationData: JSON) -> Bool {
        
        var shouldLoadCommentCell = true
        
        if (notificationData["data"]["type"].string == "photo") {
            shouldLoadCommentCell = false
        }
        if (notificationData["data"]["photos"].array?.count)! > 0 || (notificationData["data"]["videos"].array?.count)! > 0 {
            shouldLoadCommentCell = false
        }
        
        return shouldLoadCommentCell
    }
    
    
    //MARK: - TableView Datasource and Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notifications.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cellNotificationData = notifications[indexPath.row]
        
        let notificationType = cellNotificationData["type"].stringValue
        
        switch notificationType {
            
        case "postTag":
            fallthrough            
        case "postLike":
            fallthrough            
        case "postComment":
            fallthrough            
        case "photoComment":
            fallthrough
        case "photoLike":
            fallthrough
        case "journeyAccept":
            fallthrough
        case "journeyMentionComment":
            fallthrough
        case "journeyComment":
            fallthrough
        case "journeyLike":
            fallthrough
        case "itineraryMentionComment":
            fallthrough
        case "itineraryLike":
            fallthrough
        case "itineraryComment":
            fallthrough
        case "postMentionComment":
            
            return currentCellHeight
            
            
       
        case "journeyLeft":
            fallthrough            
        case "journeyRequest":
            
            return currentCellHeight
            
            
        case "journeyComment":
            fallthrough
        case "journeyLike":
            
            return currentCellHeight
            
            
        case "userFollowing":
            fallthrough
        case "userFollowingRequest":
            
            return currentCellHeight
            
            
        case "itineraryRequest":
            fallthrough
        case "userFollowingResponse":
            fallthrough
        case "journeyReject":

            return currentCellHeight
            
            
        default:
            return 230
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellNotificationData = notifications[indexPath.row]
        
        let notificationType = cellNotificationData["type"].stringValue
        
        switch notificationType {
            
        case "postTag":
            fallthrough            
        case "postLike":
            fallthrough            
        case "postComment":
            fallthrough        
        case "photoComment":
            fallthrough
        case "photoLike":
            fallthrough
        case "journeyAccept":
            fallthrough
        case "journeyMentionComment":
            fallthrough
        case "journeyComment":
            fallthrough
        case "journeyLike":
            fallthrough
        case "itineraryMentionComment":
            fallthrough
        case "itineraryLike":
            fallthrough
        case "itineraryComment":
            fallthrough
        case "postMentionComment":            
            
            if cellNotificationData["data"]["thoughts"].stringValue != "" && canLoadCommentCell(notificationData: cellNotificationData) {
                print("\n CellData: \(cellNotificationData)")
                
                var cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? NotificationCommentCell
                if cell == nil {
                    cell = NotificationCommentCell.init(style: .default, reuseIdentifier: "commentCell", notificationData: cellNotificationData, helper: self) 
                }
                else {
                    cell?.setData(notificationData: cellNotificationData, helper: self)
                }
                
                cell?.backgroundColor = UIColor.clear
                currentCellHeight = (cell?.totalHeight)!
                return cell!                
            }
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as? NotificationPhotoCell
            if cell == nil {
                cell = NotificationPhotoCell.init(style: .default, reuseIdentifier: "photoCell", notificationData: cellNotificationData, helper: self) 
            }
            else {
                cell?.setData(notificationData: cellNotificationData, helper: self)
            }
            cell?.backgroundColor = UIColor.clear
            
            currentCellHeight = (cell?.totalHeight)!            
//            tableView.reloadRows(at: [indexPath], with: .none)            
            return cell!
            
            
            
        case "journeyLeft":
            fallthrough
        case "journeyRequest":
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath) as? NotificationActionCell
            if cell == nil {
                cell = NotificationActionCell.init(style: .default, reuseIdentifier: "actionCell", notificationData: cellNotificationData, helper: self) 
            }
            else {
                cell?.setData(notificationData: cellNotificationData, helper: self)
            }
            cell?.NFPermission.NFLeftButton.tag = indexPath.row
            cell?.NFPermission.NFRightButton.tag = indexPath.row
            
            cell?.backgroundColor = UIColor.clear
            currentCellHeight = (cell?.totalHeight)!
            return cell!
            
            
        case "userFollowing":
            var cell = tableView.dequeueReusableCell(withIdentifier: "followCell", for: indexPath) as? NotificationFollowCell
            if cell == nil {
                cell = NotificationFollowCell.init(style: .default, reuseIdentifier: "followCell", notificationData: cellNotificationData, helper: self) 
            }
            else{
                cell?.setData(notificationData: cellNotificationData, helper: self)
            }
            
            cell?.backgroundColor = UIColor.clear
            currentCellHeight = (cell?.totalHeight)!
            return cell!
            
            
        case "userFollowingRequest":
            var cell = tableView.dequeueReusableCell(withIdentifier: "followRequestCell", for: indexPath) as? NotificationFollowRequestCell
            if cell == nil {
                cell = NotificationFollowRequestCell.init(style: .default, reuseIdentifier: "followRequestCell", notificationData: cellNotificationData, helper: self) 
            }
            else{
                cell?.setData(notificationData: cellNotificationData, helper: self)
            }
            
            cell?.backgroundColor = UIColor.clear
            currentCellHeight = (cell?.totalHeight)!
            return cell!
            
            
        case "itineraryRequest":
            fallthrough        
        case "userFollowingResponse":
            fallthrough
        case "journeyReject":
            var cell = tableView.dequeueReusableCell(withIdentifier: "acknolwdgeCell", for: indexPath) as? NotificationAcknolwdgementCell
            if cell == nil {
                cell = NotificationAcknolwdgementCell.init(style: .default, reuseIdentifier: "acknolwdgeCell", notificationData: cellNotificationData, helper: self) 
            }
            else{
                cell?.setData(notificationData: cellNotificationData, helper: self)
            }
            
            cell?.backgroundColor = UIColor.clear
            currentCellHeight = (cell?.totalHeight)!
            return cell!
            
        default:
            break
        }
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as? NotificationDefaultCell
        if cell == nil {
            cell = NotificationDefaultCell.init(style: .default, reuseIdentifier: "defaultCell", notificationData: cellNotificationData, helper: self) 
        }
        else{
            cell?.setData(notificationData: cellNotificationData, helper: self)
        }
        
        cell?.backgroundColor = UIColor.clear
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellNotificationData = notifications[indexPath.row]
        print("\n Selected Notification of type : \(cellNotificationData["type"].stringValue)")
        print("\n cellData: \(cellNotificationData) \n\n")
        
        gotoActivityFeed()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        let cellHeight = cell.frame.size.height
//        
//        cell.frame = CGRect(x: 0, y: 0, width: 2, height: 2)
//        
//        UIView.animate(withDuration: 0.3) {
//            cell.frame = CGRect(x: 0, y: 0, width: screenWidth, height: cellHeight)            
//        }
        
//        var translation : CATransform3D
//        
//        translation = CATransform3DMakeTranslation(0, 480, 0);
//        
//        //2. Define the initial state (Before the animation)
//        cell.layer.shadowColor = UIColor.black.cgColor
//        cell.layer.shadowOffset = CGSize(width: 10, height: 10)
//        cell.alpha = 0;
//        cell.layer.transform = translation;
//        cell.layer.anchorPoint = CGPoint(x: 0, y: 0.5)        
//        //!!!FIX for issue #1 Cell position wrong------------
//        if(cell.layer.position.x != 0){
//            cell.layer.position = CGPoint(x: 0, y: cell.layer.position.y)
//        }
//        
//        //4. Define the final state (After the animation) and commit the animation
//        UIView.beginAnimations("translation", context: nil)
//        UIView.setAnimationDuration(0.8)
//        cell.layer.transform = CATransform3DIdentity;
//        cell.alpha = 1;
//        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
//        UIView.commitAnimations()
        
        if notifications.count > 0 && indexPath.row == (notifications.count - 1) {
            
            if hasNext {
                Toast(text: "Please wait").show()
            }
//            DispatchQueue.global().async {
//                self.getNotification()                
//            }
        }
    }
    
    //MARK:- Button Action
    
    func journeyAcceptTabbed(_ sender: UIButton) {
        
        print("in the journeyAcceptTabbed indexpath:\n  \(sender.tag)")
        
        let tabbedCellData = notifications[sender.tag]
        
        print("\n tabbedCellData : \(tabbedCellData)")
        
        if tabbedCellData["answeredStatus"].stringValue == "" {
        
            request.acceptJourney(currentUser["_id"].stringValue,
                                  uniqueId: tabbedCellData["data"]["journeyUnique"].stringValue,
                                  notificationId: tabbedCellData["_id"].stringValue,
                                  inMiddle: tabbedCellData["data"]["inMiddle"].boolValue) { (response) in
                                    
                                    print("\n Response : \(response)")
                                    
                                    DispatchQueue.main.async(execute: {
                                        
                                        if response.error != nil {
                                            
                                            print("error: \(response.error!.localizedDescription)")
                                            
                                        }
                                        else if response["value"].bool! {
                                            
                                            Toast(text: response["data"].stringValue).show()                                        
                                            self.gotoOTG()                                        
                                        }
                                        else {
                                            Toast(text: response["error"].stringValue).show()
                                        }
                                        
                                    })
                                    
            }
        }
        
        else{
            Toast(text: (tabbedCellData["answeredStatus"].stringValue == "reject" ? "This request is already rejected " : "This request is already accepted")).show()
        }
        
    }
    
    func journeyDeclineTabbed(_ sender: UIButton) {
        
        print("in the journeyDeclineTabbed indexpath: \(sender.tag)")
        
        let tabbedCellData = notifications[sender.tag]
        
        print("\n tabbedCellData : \(tabbedCellData)")
        
        if tabbedCellData["answeredStatus"].stringValue == "" {
            
            request.declinedJourney(currentUser["_id"].stringValue, 
                                    uniqueId: tabbedCellData["data"]["journeyUnique"].stringValue,
                                    notificationId: tabbedCellData["_id"].stringValue) { (response) in
                                        
                                        print("\n Response : \(response)")
                                        
                                        DispatchQueue.main.async(execute: {
                                            
                                            if response.error != nil {
                                                
                                                print("error: \(response.error!.localizedDescription)")
                                                
                                            }
                                            else if response["value"].bool! {
                                                
                                                Toast(text: response["data"].stringValue).show()
                                                
                                            }
                                            else {
                                                
                                                Toast(text: response["error"].stringValue).show()
                                                
                                            }
                                            
                                            self.notifyTableView.reloadData()
                                        })
                                        
            }
        }
        
        else{
            Toast(text: (tabbedCellData["answeredStatus"].stringValue == "reject" ? "This request is already rejected " : "This request is already accepted")).show()
        }
        
    }
    
    func journeyEndTabbed(_ sender: UIButton) {
        
        print("in the journeyEndTabbed indexpath: \(sender.tag)")
        
        let tabbedCellData = notifications[sender.tag]
        
        print("\n tabbedCellData : \(tabbedCellData)")
        
        gotoEndJourney(journeyID: tabbedCellData["data"]["_id"].stringValue, notificationId: tabbedCellData["_id"].stringValue)
        
    }
    
    func journeyEndDeclined(_ sender: UIButton) {
        
        print("in the journeyEndDeclined indexpath: \(sender.tag)")
        
        let tabbedCellData = notifications[sender.tag]
        
        print("\n tabbedCellData : \(tabbedCellData)")
        
        request.updateNotificationStatus(notificationId: tabbedCellData["_id"].stringValue, answeredStatus: "reject") { (response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    Toast(text: response["data"].stringValue).show()
                    
                }
                else {
                    
                    Toast(text: response["error"].stringValue).show()
                    
                }
                
                self.notifyTableView.reloadData()
            })
        }
        
    }
    
    
    //MARK: - Button Action Helpers
    
    func gotoOTG() {
        
        print(user.getExistingUser())
        
        request.getUser(user.getExistingUser(), completion: {(request) in
            DispatchQueue.main.async {
                currentUser = request["data"]
                let tlVC = (UIStoryboard(name: "Main", bundle: nil)).instantiateViewController(withIdentifier: "newTL") as! NewTLViewController
                tlVC.isJourney = false
                if(currentUser["journeyId"].stringValue == "-1") {
                    isJourneyOngoing = false
                    tlVC.showJourneyOngoing(journey: JSON(""))
                }
                globalNavigationController?.pushViewController(tlVC, animated: false)
            }
        })
        
    }
    
    func gotoEndJourney(journeyID : String, notificationId: String) {
        let end = storyboard!.instantiateViewController(withIdentifier: "endJourney") as! EndJourneyViewController
        end.journeyId = journeyID
        end.notificationID = notificationId
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController!.pushViewController(end, animated: true)
    }
    
    func gotoActivityFeed() {
        
        let tlVC = storyboard!.instantiateViewController(withIdentifier: "activityFeeds") as! ActivityFeedsController
        tlVC.displayData = "activity"
        globalNavigationController?.pushViewController(tlVC, animated: false)
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


/* func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
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
 
 } */

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

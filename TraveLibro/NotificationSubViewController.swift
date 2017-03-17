//
//  NotificationSubViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 25/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class NotificationSubViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    var lastContentOffset = CGFloat(0)
    
    @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
    
    var mainFooter: FooterViewNew!
    var notifications: [JSON] = []
    let refreshControl = UIRefreshControl()
    var currentPageNumber = 0
    var hasNext = true
    var isLoading = false
    var currentCellHeight = CGFloat(10)
    var loader = LoadingOverlay()
    var lastContentOffset: CGFloat!
    var isScrollingDown = true
    
    @IBOutlet weak var notifyTableView: UITableView!
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarItemText("Notifications")
        
        loader.showOverlay(self.view)        
        self.mainFooter = FooterViewNew(frame: CGRect.zero)
        self.mainFooter.layer.zPosition = 5
        self.view.addSubview(self.mainFooter)
        
        getDarkBackGround(self)
        notifyTableView.backgroundColor = UIColor.clear
        notifyTableView.tableFooterView = UIView()

        refreshControl.addTarget(self, action: #selector(NotificationSubViewController.pullToRefreshCalled), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = lightOrangeColor
        notifyTableView.addSubview(refreshControl)
        
        getNotification()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainFooter.frame = CGRect(x: 0, y: self.view.frame.height - 65, width: self.view.frame.width, height: 65)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lastContentOffset = notifyTableView.contentOffset.y
        globalNavigationController = self.navigationController
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Helper
    
    func pullToRefreshCalled() {        
        currentPageNumber = 0
        hasNext = true
        getNotification()
    }
    
    func getNotification() {
        
        if hasNext && !isLoading {
            
            isLoading = true
            
            currentPageNumber += 1
            
            print("\n Fetching data for pageNumber: \(currentPageNumber)")
            
            showBottomLoader(onView: self.notifyTableView)
            
            request.getNotify(currentUser["_id"].string!, pageNumber: currentPageNumber,  completion: {(response) in
                
                let refreshing = self.refreshControl.isRefreshing
                DispatchQueue.main.sync(execute: {
                    
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                    
                })
                
//                DispatchQueue.main.async(execute: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    
                    self.isLoading = false
                    self.loader.hideOverlayView()
                    hideBottomLoader()
                    
                    if response.error != nil {
                        print("error: \(response.error!.localizedDescription)")                        
                    }
                    else if response["value"].bool! {
                        
                        let newResponse = response["data"].array!
                        
                        if newResponse.isEmpty {
                            self.hasNext = false
                        }
                        
                        if self.notifications.isEmpty {
                            if newResponse.isEmpty {                                
                                let errorAlert = UIAlertController(title: "", message: "No notifications for you ", preferredStyle: UIAlertControllerStyle.alert)
                                let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
                                    (result : UIAlertAction) -> Void in
                                    self.popVC(UIButton())
                                }
                                errorAlert.addAction(DestructiveAction)
                                self.navigationController?.present(errorAlert, animated: true, completion: nil)
                            }
                        }
                        else {                        
                            self.notifications.append(contentsOf: newResponse)
                        }
                        
                        if !(newResponse.isEmpty) {
                            var indexx = 0
                            if refreshing || self.notifications.isEmpty {
                                self.notifications = []                                
                                self.notifications = newResponse
                                indexx = 0
                            }
                            else{
                                indexx = (self.notifications.count - 1)
                            }
                            print("\n Reload called \n")
                            self.notifyTableView.reloadData()
                            self.notifyTableView.scrollToRow(at: NSIndexPath.init(row: indexx, section: 0) as IndexPath as IndexPath, at: .none, animated: true)
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { 
//                                self.notifyTableView.reloadData()
//                            })                            
                        }                        
                    }
                    else {
                        print("response error!")
                    }                    
                })
                
            })
        }
        else{
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func canLoadCommentCell(data: JSON) -> Bool {
        
        var shouldLoadCommentCell = true
        if (data["data"]["type"].string == "photo") {
            shouldLoadCommentCell = false
        }
        else if (data["data"]["type"].string == "video") {
            shouldLoadCommentCell = false
        }
        else if ((data["data"]["videos"].array?.count)! > 0) {
            shouldLoadCommentCell = false
        }
        else if ((data["data"]["photos"].array?.count)! > 0) {
            shouldLoadCommentCell = false
        }        
        else if data["data"]["showMap"].boolValue && data["data"]["checkIn"]["location"] != "" {
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
            
        case "postFirstTime":
            fallthrough
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
            
        case "postFirstTime":
            fallthrough
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
            
            if cellNotificationData["data"]["thoughts"].stringValue != "" && canLoadCommentCell(data: cellNotificationData) {
                
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
            
            return cell!
            
            
            
        case "itineraryRequest":
            fallthrough
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
            cell?.NFPermission.NFViewButton.tag = indexPath.row
            
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
            
        case "journeyAccept":
            fallthrough
        case "userFollowing":
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
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellNotificationData = notifications[indexPath.row]
        print("\n Selected Notification of type : \(cellNotificationData["type"].stringValue)")
        gotoActivityFeed()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        let cellHeight = cell.frame.size.height
//        
//        cell.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: 2)
//        cell.alpha = 0
//        
//        UIView.animate(withDuration: 0.3) {
//            cell.frame = CGRect(x: 0, y: 0, width: screenWidth, height: cellHeight)
//            cell.alpha = 1
//        }
        
        if isScrollingDown {
            var translation : CATransform3D
            
            translation = CATransform3DMakeTranslation(0, 480, 0);
            
            //2. Define the initial state (Before the animation)
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 10, height: 10)
            cell.alpha = 0;
            cell.layer.transform = translation;
            cell.layer.anchorPoint = CGPoint(x: 0, y: 0.5)        
            //!!!FIX for issue #1 Cell position wrong------------
            if(cell.layer.position.x != 0){
                cell.layer.position = CGPoint(x: 0, y: cell.layer.position.y)
            }
            
            //4. Define the final state (After the animation) and commit the animation
            UIView.beginAnimations("translation", context: nil)
            UIView.setAnimationDuration(0.6)
            cell.layer.transform = CATransform3DIdentity;
            cell.alpha = 1;
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            UIView.commitAnimations()
        }        
    }
    
    //MARK:- Button Action
    
    func journeyAcceptTabbed(_ sender: UIButton) {
        
        let tabbedCellData = notifications[sender.tag]
        
        if tabbedCellData["answeredStatus"].stringValue == "" {
        
            request.acceptJourney(currentUser["_id"].stringValue,
                                  uniqueId: tabbedCellData["data"]["journeyUnique"].stringValue,
                                  notificationId: tabbedCellData["_id"].stringValue,
                                  inMiddle: tabbedCellData["data"]["inMiddle"].boolValue) { (response) in
                                    
                                    DispatchQueue.main.async(execute: {
                                        
                                        if response.error != nil {
                                            
                                            print("error: \(response.error!.localizedDescription)")
                                            
                                        }
                                        else if response["value"].bool! {
                                            self.loader.showOverlay(self.view)
                                            self.gotoOTG()                                        
                                        }
                                        else {
                                            let errorAlert = UIAlertController(title: "Error", message: response["error"].stringValue, preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
                                            let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
                                                (result : UIAlertAction) -> Void in
                                                //Cancel Action
                                            }
                                            
                                            errorAlert.addAction(DestructiveAction)
                                            self.navigationController?.present(errorAlert, animated: true, completion: nil)
                                        }
                                        
                                    })
                                    
            }
        }        
    }
    
    func journeyDeclineTabbed(_ sender: UIButton) {
        
        let tabbedCellData = notifications[sender.tag]
        
        if tabbedCellData["answeredStatus"].stringValue == "" {
            
            request.declinedJourney(currentUser["_id"].stringValue, 
                                    uniqueId: tabbedCellData["data"]["journeyUnique"].stringValue,
                                    notificationId: tabbedCellData["_id"].stringValue) { (response) in
                                        
                                        DispatchQueue.main.async(execute: {
                                            
                                            if response.error != nil {
                                                
                                                print("error: \(response.error!.localizedDescription)")
                                                
                                            }
                                            else if response["value"].bool! {
                                                self.refreshControl.beginRefreshing()
                                                self.pullToRefreshCalled()
                                                
                                            }
                                            else {
                                                
                                                let errorAlert = UIAlertController(title: "Error", message: response["error"].stringValue, preferredStyle: UIAlertControllerStyle.alert)
                                                let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
                                                    (result : UIAlertAction) -> Void in
                                                    //Cancel Action
                                                }            
                                                errorAlert.addAction(DestructiveAction)
                                                self.navigationController?.present(errorAlert, animated: true, completion: nil)
                                            }
                                        })
                                        
            }
        }        
    }
    
    func journeyEndTabbed(_ sender: UIButton) {
        
        let tabbedCellData = notifications[sender.tag]
        
        gotoEndJourney(journeyID: tabbedCellData["data"]["_id"].stringValue, notificationId: tabbedCellData["_id"].stringValue)
        
    }
    
    func journeyEndDeclined(_ sender: UIButton) {
        
        let tabbedCellData = notifications[sender.tag]
        
        request.updateNotificationStatus(notificationId: tabbedCellData["_id"].stringValue, answeredStatus: "reject") { (response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    self.refreshControl.beginRefreshing()
                    self.pullToRefreshCalled()
                    
                }
                else {
                    let errorAlert = UIAlertController(title: "Error", message: response["error"].stringValue, preferredStyle: UIAlertControllerStyle.alert)
                    let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
                        (result : UIAlertAction) -> Void in
                        //Cancel Action
                    }            
                    errorAlert.addAction(DestructiveAction)
                    self.navigationController?.present(errorAlert, animated: true, completion: nil)
                }
            })
        }
        
    }
    
    func itineraryAcceptTabbed(_ sender: UIButton) {
        
        let tabbedCellData = notifications[sender.tag]
        
        request.respondToItineraryRequest(notificationId: tabbedCellData["_id"].stringValue, itineraryID: tabbedCellData["data"]["_id"].stringValue, answeredStatus: "accept") { (response) in
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    self.refreshControl.beginRefreshing()
                    self.pullToRefreshCalled()
                }
                else {
                    
                    let errorAlert = UIAlertController(title: "Error", message: response["error"].stringValue, preferredStyle: UIAlertControllerStyle.alert)
                    let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
                        (result : UIAlertAction) -> Void in
                        //Cancel Action
                    }            
                    errorAlert.addAction(DestructiveAction)
                    self.navigationController?.present(errorAlert, animated: true, completion: nil)
                    
                }
            })
        }
    }
    
    func itineraryDeclinedTabbed(_ sender: UIButton) {        
        
        let tabbedCellData = notifications[sender.tag]
        
        request.respondToItineraryRequest(notificationId: tabbedCellData["_id"].stringValue, itineraryID: tabbedCellData["data"]["_id"].stringValue, answeredStatus: "reject") { (response) in
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    self.refreshControl.beginRefreshing()
                    self.pullToRefreshCalled()
                }
                else {
                    let errorAlert = UIAlertController(title: "Error", message: response["error"].stringValue, preferredStyle: UIAlertControllerStyle.alert)
                    let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
                        (result : UIAlertAction) -> Void in
                        //Cancel Action
                    }            
                    errorAlert.addAction(DestructiveAction)
                    self.navigationController?.present(errorAlert, animated: true, completion: nil)
                }
            })
        }        
    }    
    
    func itineraryViewTabbed(_ sender: UIButton) {
        
        let tabbedCellData = notifications[sender.tag]
        
        print("\n TabbedCellData : \(tabbedCellData)")
        
        gotoDetailItinerary(itineraryID: tabbedCellData["data"]["_id"].stringValue)
        
    }
    
    
    //MARK: - Button Action Helpers
    
    func gotoOTG() {
        request.getUser(user.getExistingUser(), completion: {(request) in
            DispatchQueue.main.async {
                
                self.loader.hideOverlayView()                
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
    
    func gotoDetailItinerary(itineraryID: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EachItineraryViewController") as! EachItineraryViewController
        controller.fromOutSide = itineraryID        
        globalNavigationController?.setNavigationBarHidden(false, animated: true)
        globalNavigationController?.pushViewController(controller, animated: true)
    }
    
    
    //MARK: - Scroll Delagtes
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {        
        
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            hideHeaderAndFooter(true);
        }
        else{
            hideHeaderAndFooter(false);
        }
        
        if (lastContentOffset > scrollView.contentOffset.y) {
            isScrollingDown = false
        }
        else if (lastContentOffset! < scrollView.contentOffset.y) { 
            isScrollingDown = true
        }
        
        lastContentOffset = scrollView.contentOffset.y
        
        if(notifyTableView.contentOffset.y >= (notifyTableView.contentSize.height - notifyTableView.frame.size.height)) {
            if notifications.count > 0 {            
                if hasNext {
                    self.getNotification()
                }
            }
        }
    }
    
    func hideHeaderAndFooter(_ isShow:Bool) {
        if(isShow) {
//            tableTopConstraint.constant = 0
            
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            
            self.mainFooter.frame.origin.y = self.view.frame.height + 95
        }
        else {
//            tableTopConstraint.constant = (self.navigationController?.navigationBar.frame.size.height)! + 21
            
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
            self.mainFooter.frame.origin.y = self.view.frame.height - 65
            
        }
    }
    
}


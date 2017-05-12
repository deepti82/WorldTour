//
//  TLMainFeedsViewController.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 02/05/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

enum viewType {
    case VIEW_TYPE_ACTIVITY
    case VIEW_TYPE_MY_LIFE
    case VIEW_TYPE_LOCAL_LIFE
    case VIEW_TYPE_POPULAR_JOURNEY
    case VIEW_TYPE_POPULAR_ITINERARY
    case VIEW_TYPE_OTG
}

enum feedCellType {
    case CELL_OTG_TYPE
    case CELL_POST_TYPE
    case CELL_ITINERARY_TYPE    
    case CELL_TRAVEL_LIFE_TYPE
    case CELL_LOCAL_LIFE_TYPE
}

enum feedPostCellType {
    case POST_ONLY_THOUGHT_TYPE
    case POST_ONLY_CHECKIN_TYPE
    case POST_ONLY_IMAGE_TYPE
    case POST_ONLY_VIDEO_TYPE
    case POST_THOUGHT_CHECKIN_TYPE
    case POST_THOUGHT_IMAGE_TYPE
    case POST_THOUGHT_VIDEO_TYPE
}


class TLMainFeedsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TLFooterBasicDelegate {

    @IBOutlet weak var feedsTableView: UITableView!
    
    private let TL_VISIBLE_CELL_TAG = 6789
    
    var mainFooter: FooterViewNew?
    
    var pageType: viewType = viewType.VIEW_TYPE_ACTIVITY
    var currentLocation = ["lat":"0.0", "long":"0.0"]
    var currentCategory = ""
    
    var feedsDataArray: [JSON] = []
    var currentPageNumber = 1
    var hasMorePages = true
    var isLoading = false
    
    let separatorOffset = CGFloat(15.0)
    
    var loader = LoadingOverlay()
    let refreshControl = UIRefreshControl()
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedsDataArray = []
        self.reloadTableData()
        
        getDarkBackGround(self)
        
        feedsTableView.tableFooterView = UIView()
        
        self.setupView()
        
        self.getDataMain()    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        self.mainFooter?.frame = CGRect(x: 0, y: self.view.frame.height - MAIN_FOOTER_HEIGHT, width: self.view.frame.width, height: MAIN_FOOTER_HEIGHT)
        
        if pageType == viewType.VIEW_TYPE_ACTIVITY {
            self.mainFooter?.setHighlightStateForView(tag: 0, color: mainOrangeColor)
            
            var isEmptyScreenPresent = false
            for views in self.view.subviews {
                if views.tag == 46 {
                    isEmptyScreenPresent = true                
                }
            }
            
            if isEmptyScreenPresent && !isLoading {
                getActivityFeedsData(pageNumber: 1)
            }
        }
            
        else if pageType == viewType.VIEW_TYPE_LOCAL_LIFE {            
            self.mainFooter?.setHighlightStateForView(tag: 3, color: mainGreenColor)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        globalNavigationController = self.navigationController
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideHeaderAndFooter(false)        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.mainFooter?.setFooterDefaultState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Setup View 
    
    func setupView() {
        
        feedsTableView.dataSource = self
        feedsTableView.delegate = self
        
        refreshControl.tintColor = mainOrangeColor
        self.feedsTableView.addSubview(refreshControl)
        
        if pageType == viewType.VIEW_TYPE_ACTIVITY {
            
            setNavigationBarItemText("Activity Feed")
            
            self.mainFooter = FooterViewNew(frame: CGRect.zero)
            self.mainFooter?.layer.zPosition = 5
            self.view.addSubview(self.mainFooter!)
            
            self.mainFooter?.setHighlightStateForView(tag: 0, color: mainOrangeColor)
        }
        
        else if pageType == viewType.VIEW_TYPE_POPULAR_JOURNEY {
            setNavigationBarItemText("Popular Journeys")
            
            self.mainFooter = FooterViewNew(frame: CGRect.zero)
            self.mainFooter?.layer.zPosition = 5
            self.view.addSubview(self.mainFooter!)
        }
        
        else if pageType == viewType.VIEW_TYPE_POPULAR_ITINERARY {
            setNavigationBarItemText("Popular Itineraries")
            
            self.mainFooter = FooterViewNew(frame: CGRect.zero)
            self.mainFooter?.layer.zPosition = 5
            self.view.addSubview(self.mainFooter!)
        }
        
        else if pageType == viewType.VIEW_TYPE_LOCAL_LIFE {
            
            refreshControl.tintColor = mainGreenColor
            
            self.mainFooter = FooterViewNew(frame: CGRect.zero)
            self.mainFooter?.layer.zPosition = 5
            self.view.addSubview(self.mainFooter!)
            
            self.mainFooter?.setHighlightStateForView(tag: 3, color: mainGreenColor)
            
            let leftButton = UIButton()
            leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
            leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
            
            let rightButton = UIButton()
            rightButton.frame = CGRect(x: 0, y: 10, width: 15, height: 20)
            rightButton.setImage(UIImage(named: "nearMe"), for: UIControlState())
            rightButton.imageView?.contentMode = .scaleAspectFit
            rightButton.imageView?.clipsToBounds = true
            rightButton.addTarget(self, action: #selector(self.showNearMe(_:)), for: .touchUpInside)
            
            self.title = currentCategory
            
            self.customNavigationBar(left: leftButton, right: rightButton)
        }
    }
    
    
    //MARK: - Refresh Control
    
    func pullToRefreshCalled() {
        print("\n Pull to refresh called \n")
        
        refreshControl.endRefreshing()        
        
        if !isLoading {
            currentPageNumber = 1
            hasMorePages = true
            isLoading = false
            
            self.getDataMain()
        }
    }
    
    
    //MARK: - Fetch Data
    
    func getDataMain() {
        
        print("\n\n Will fetch data for : \(currentPageNumber)")
        
        let i = PostImage()
        i.uploadPhotos()
        
        if feedsDataArray.isEmpty && currentPageNumber == 1 {
            loader.showOverlay(self.view)
        }
        
        switch pageType {
            
        case .VIEW_TYPE_ACTIVITY:
            
//            let i = PostImage()
//            i.uploadPhotos()
            
            self.getActivityFeedsData(pageNumber: currentPageNumber)
            break
            
        case .VIEW_TYPE_MY_LIFE:
            break
            
        case .VIEW_TYPE_LOCAL_LIFE:
            self.getLocalLifePostsData(pageNumber: currentPageNumber)
            break
            
        case .VIEW_TYPE_POPULAR_JOURNEY:
            self.getPopularJoueneyData(pageNumber: currentPageNumber)
            break
            
        case .VIEW_TYPE_POPULAR_ITINERARY:
            self.getPopularItineriesData(pageNumber: currentPageNumber)
            break
            
        case .VIEW_TYPE_OTG:
            break
            
        }
    }
    
    func getActivityFeedsData(pageNumber: Int) {
        
        if pageType == viewType.VIEW_TYPE_ACTIVITY {
            
            request.getActivityFeeds(user.getExistingUser(), pageNumber: pageNumber, completion: { (response, localPostResponse, localQuickItineraryResponse, isFromCache) in                
                DispatchQueue.main.async(execute: {
                    
                    self.removeEmptyScreen()
                    
                    if pageNumber == 1 {
                        self.feedsDataArray = []
                    }
                    
                    if !localPostResponse.isEmpty {
                        self.feedsDataArray.append(contentsOf: localPostResponse)                    
                    }
                    
                    if !localQuickItineraryResponse.isEmpty {
                        self.feedsDataArray.append(contentsOf: localQuickItineraryResponse)                    
                    }
                    
                    if !response["data"].arrayValue.isEmpty {
                        self.feedsDataArray.append(contentsOf: response["data"].arrayValue)                    
                    }
                    else if !isFromCache {
                        self.hasMorePages = false
                    }
                    
                    self.reloadTableData()
                    
                    if !isFromCache {
                        if self.feedsDataArray.isEmpty {
                            self.showActivityFeedEmptyScreen()
                        }
                    }
                })
            })
        }
    }
    
    func getLocalLifePostsData(pageNumber: Int) {
        
        if pageType == viewType.VIEW_TYPE_LOCAL_LIFE {
            
            request.getLocalLife(lat: currentLocation["lat"]!, lng: currentLocation["long"]!, page: pageNumber, category: currentCategory, completion: { (response) in
                DispatchQueue.main.async(execute: { 
                    if pageNumber == 1 {
                        self.feedsDataArray = []
                    }
                    
                    if !response["data"].arrayValue.isEmpty {
                        self.feedsDataArray.append(contentsOf: response["data"].arrayValue)                    
                    }
                    else {
                        self.hasMorePages = false
                    }
                    
                    self.reloadTableData()
                })
            })
        }
    }
    
    func getPopularJoueneyData(pageNumber: Int) {
        
        if pageType == viewType.VIEW_TYPE_POPULAR_JOURNEY {
            request.getPopularJourney(userId: user.getExistingUser(), pagenumber: pageNumber) { (response) in
                DispatchQueue.main.async(execute: { 
                    if pageNumber == 1 {
                        self.feedsDataArray = []
                    }
                    
                    if !response["data"].arrayValue.isEmpty {
                        self.feedsDataArray.append(contentsOf: response["data"].arrayValue)                    
                    }
                    else {
                        self.hasMorePages = false
                    }
                    
                    self.reloadTableData()
                })
            }            
        }
        
    }
    
    func getPopularItineriesData(pageNumber: Int) {
        
        if pageType == viewType.VIEW_TYPE_POPULAR_ITINERARY {            
            request.getPopularItinerary(userId: user.getExistingUser(), pagenumber: pageNumber, completion: { (response) in
                DispatchQueue.main.async(execute: { 
                    if pageNumber == 1 {
                        self.feedsDataArray = []
                    }
                    
                    if !response["data"].arrayValue.isEmpty {
                        self.feedsDataArray.append(contentsOf: response["data"].arrayValue)                    
                    }
                    else {
                        self.hasMorePages = false
                    }
                    
                    self.reloadTableData()
                })
            })
        }
    }
    
    
    //MARK: - Notification
    
    func NCnote(_ notification: Notification) {
        print("\n Notification received")
        if currentUser != nil{
            currentPageNumber = 1
            self.getDataMain()
        }
    }
    
    
    //MARK: - Reload Table
    
    func reloadTableData() {
        
        loader.hideOverlayView()
        
        self.isLoading = false
        self.feedsTableView.reloadData()
    }
    
    
    //MARK: - TableView Datasource and Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isLoading && hasMorePages {
            return (feedsDataArray.count+1)            
        }
        return feedsDataArray.count
    }    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row < feedsDataArray.count) {
            
            var height = separatorOffset
            
            let cellData = self.feedsDataArray[indexPath.row]        
            switch cellData["type"].stringValue {
                
            case "on-the-go-journey":
                fallthrough
            case "ended-journey":
                let displatTextString = getTextHeader(feed: cellData, pageType: pageType)
                var textHeight = (heightOfAttributedText(attributedString: displatTextString, width: (screenWidth-21)) + 10)            
                textHeight = ((cellData["countryVisited"].arrayValue).isEmpty) ? textHeight : max(textHeight, 36)
                height = height + ((pageType == viewType.VIEW_TYPE_MY_LIFE) ? 0 : FEEDS_HEADER_HEIGHT) + textHeight + screenWidth*0.9 + (shouldShowFooterCountView(feed: cellData) ? FEED_FOOTER_HEIGHT : (FEED_FOOTER_HEIGHT-FEED_FOOTER_LOWER_VIEW_HEIGHT)) + (isLocalFeed(feed: cellData) ? FEED_UPLOADING_VIEW_HEIGHT : 0)
                break
                
                
            case "travel-life":
                fallthrough
            case "local-life":
                height = height + ((pageType == viewType.VIEW_TYPE_MY_LIFE) ? 0 : FEEDS_HEADER_HEIGHT) + getHeightForMiddleViewPostType(feed: cellData, pageType: self.pageType) + (shouldShowFooterCountView(feed: cellData) ? FEED_FOOTER_HEIGHT : (FEED_FOOTER_HEIGHT-FEED_FOOTER_LOWER_VIEW_HEIGHT)) + (isLocalFeed(feed: cellData) ? FEED_UPLOADING_VIEW_HEIGHT : 0)                        
                break
                
                
            case "quick-itinerary":
                fallthrough
            case "detail-itinerary":
                let displatTextString = getTextHeader(feed: cellData, pageType: pageType)
                var textHeight = (heightOfAttributedText(attributedString: displatTextString, width: (screenWidth-21)) + 10)            
                textHeight = ((cellData["countryVisited"].arrayValue).isEmpty) ? textHeight : max(textHeight, 36)
                height = height + ((pageType == viewType.VIEW_TYPE_ACTIVITY) ? FEEDS_HEADER_HEIGHT : 0) + textHeight + screenWidth*0.9 + (shouldShowFooterCountView(feed: cellData) ? FEED_FOOTER_HEIGHT : (FEED_FOOTER_HEIGHT-FEED_FOOTER_LOWER_VIEW_HEIGHT)) + (isLocalFeed(feed: cellData) ? FEED_UPLOADING_VIEW_HEIGHT : 0)
                break
                
            default:
                
                print("\n default case : \(cellData["type"].stringValue)")
            }
            
            return height
            
        }
        else {
            return CGFloat(100)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row < feedsDataArray.count) {
            let cellData = self.feedsDataArray[indexPath.row]
            // print("\n CellData [\(indexPath.row)] :: type : \(cellData["type"].stringValue)")
            
            switch cellData["type"].stringValue {
                
            case "on-the-go-journey":
                fallthrough
            case "ended-journey":
                var feedCell = tableView.dequeueReusableCell(withIdentifier: "OTGCell", for: indexPath) as? TLOTGJourneyTableViewCell
                
                if feedCell == nil {
                    feedCell = TLOTGJourneyTableViewCell.init(style: .default, reuseIdentifier: "OTGCell", feedData: cellData, helper: self)
                }
                
                feedCell?.setData(feedData: cellData, helper: self, pageType: pageType, delegate: self)
                feedCell?.FFooterViewBasic.tag = indexPath.row
                return feedCell!
                
                
            case "travel-life":
                fallthrough
            case "local-life":
                var feedCell = tableView.dequeueReusableCell(withIdentifier: "TravelLocalCell", for: indexPath) as? TLTravelLocalLifeTableViewCell
                
                if feedCell == nil {
                    feedCell = TLTravelLocalLifeTableViewCell.init(style: .default, reuseIdentifier: "TravelLocalCell", feedData: cellData, helper: self)
                }
                
                feedCell?.setData(feedData: cellData, helper: self, pageType: pageType, delegate: self)
                feedCell?.FFooterViewBasic.tag = indexPath.row
                feedCell?.tag = TL_VISIBLE_CELL_TAG
                return feedCell!
                
                
            case "quick-itinerary":
                fallthrough
            case "detail-itinerary":
                var feedCell = tableView.dequeueReusableCell(withIdentifier: "ItineraryCell", for: indexPath) as? TLItineraryTableViewCell
                
                if feedCell == nil {
                    feedCell = TLItineraryTableViewCell.init(style: .default, reuseIdentifier: "ItineraryCell", feedData: cellData, helper: self)
                }
                
                feedCell?.setData(feedData: cellData, helper: self, pageType: pageType, delegate: self)
                feedCell?.FFooterViewBasic.tag = indexPath.row            
                return feedCell!            
                
                
            default:
                print("\n default case : \(cellData["type"].stringValue)")
            }
            
            
            let feedCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return feedCell
        }
            
        else {
            var loadingCell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as? TLLoadingTableViewCell
            
            if loadingCell == nil {
                loadingCell = TLLoadingTableViewCell.init(style: .default, reuseIdentifier: "LoadingCell", pageType: self.pageType)
            }
            
            loadingCell?.setData(pageType: self.pageType)                        
            return loadingCell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("\n Row selected at index : \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.row < feedsDataArray.count) {
            
            let cellData = self.feedsDataArray[indexPath.row]
            
            switch cellData["type"].stringValue {
                
            case "on-the-go-journey":
                fallthrough
            case "ended-journey":
                self.showDetailedJourney(feed: cellData)
                break
                
                
            case "travel-life":
                fallthrough
            case "local-life":
                break
                
                
            case "quick-itinerary":
                self.showQuickItinerary(feed: cellData)
                break
                
            case "detail-itinerary":
                self.showDetailedItinerary(feed: cellData)
                break
                
            default:
                print("\n default case : \(cellData["type"].stringValue)")
            }
        }
    }
    
    
    //MARK: - Navigate to otherVC
    
    func showDetailedJourney(feed: JSON) {        
        if currentUser != nil {
            let controller = storyboard?.instantiateViewController(withIdentifier: "newTL") as! NewTLViewController
            controller.fromOutSide = feed["_id"].stringValue
            controller.fromType = feed["type"].stringValue
            self.navigationController?.pushViewController(controller, animated: false)
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
    }
    
    func showQuickItinerary(feed: JSON) {
        if currentUser != nil {
            selectedQuickI = feed["_id"].stringValue
            let profile = storyboard?.instantiateViewController(withIdentifier: "previewQ") as! QuickItineraryPreviewViewController
            self.navigationController?.pushViewController(profile, animated: true)
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
    }
    
    func showDetailedItinerary(feed: JSON) {
        if currentUser != nil {
            let controller = storyboard?.instantiateViewController(withIdentifier: "EachItineraryViewController") as! EachItineraryViewController
            controller.fromOutSide = feed["_id"].stringValue
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else {
            if (feed["itineraryBy"].stringValue.lowercased() != "admin") {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)                
            }
        }
    }
    
    func showNearMe(_ sender:AnyObject) {
        let nearMeListController = storyboard?.instantiateViewController(withIdentifier: "nearMeListVC") as! NearMeListViewController
        nearMeListController.fromLocal = true
        nearMeListController.nearMeType = self.currentCategory
        self.navigationController?.pushViewController(nearMeListController, animated: true)
    }
    
    
    //MARK: - Delegate Actions
    
    func footerLikeCommentCountUpdated(likeDone: Bool, likeCount: Int, commentCount: Int, tag: Int) {
        var cellData = feedsDataArray[tag]        
        cellData["likeCount"] = JSON(String(likeCount))
        cellData["commentCount"] = JSON(String(commentCount))
        cellData["likeDone"] = JSON(Bool(likeDone))        
        feedsDataArray[tag] = cellData
        
        if likeDone {
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut, .beginFromCurrentState], animations: {                
            }) { (true) in
                self.feedsTableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
            }
        }
        else { 
            self.feedsTableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
        }               
    }
    
    func footerRatingUpdated(rating: JSON, tag: Int) {        
        var currentJson = feedsDataArray[tag]            
        currentJson["review"][0] = ["rating":"\(rating["rating"].stringValue)","review":rating["review"].stringValue]            
        if (currentJson["review"].isEmpty){
            currentJson["review"] = [["rating":"\(rating["rating"].stringValue)","review":rating["review"].stringValue]]
        }
        feedsDataArray[tag] = currentJson
        
        self.feedsTableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
    }    
    
    
    
    //MARK: - Scrolling Delegates
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            self.hideHeaderAndFooter(true);
        }
        else{
            self.hideHeaderAndFooter(false);
        }
    }
    
    //for adding more content when scrolled to end of table
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        for visibleCell in feedsTableView.visibleCells {
            if visibleCell.tag == TL_VISIBLE_CELL_TAG {
                let requiredCell = visibleCell as! TLTravelLocalLifeTableViewCell
                requiredCell.videoToPlay(scrollView: scrollView)
            }
        }
        
        if (maximumOffset-currentOffset) <= 0 {
            if hasMorePages && !isLoading {                
                print("\n table scolled to end, fetch more content...")
                self.isLoading = true
                self.feedsTableView.reloadData()
                
                self.currentPageNumber += 1
                self.getDataMain()
            }
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(refreshControl.isRefreshing){
            self.pullToRefreshCalled()
        }
    }
    
    private func hideHeaderAndFooter(_ isShow:Bool) {
        if(isShow) {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.mainFooter?.frame.origin.y = self.view.frame.height + MAIN_FOOTER_HEIGHT
        }
        else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.mainFooter?.frame.origin.y = self.view.frame.height - MAIN_FOOTER_HEIGHT
        }
    }
    
    
    //MARK: - Empty screen
    
    func removeEmptyScreen() {
        for views in self.view.subviews {
            if views.tag == 46 {
                let expectedView = views
                expectedView.removeFromSuperview()                
            }
        }
    }
    
    func showActivityFeedEmptyScreen() {
        
        removeEmptyScreen()
        
        if pageType == viewType.VIEW_TYPE_ACTIVITY {
            let noActivity = activityEmptyView(frame: CGRect(x: 0, y: 0, width: min(screenWidth*0.8, 256)  , height: 200))
            noActivity.headerLabel.text = "Hi \(currentUser["name"].stringValue),"
            noActivity.tag = 46
            noActivity.center = CGPoint(x: screenWidth/2, y: screenHeight/2 - 50)
            
            noActivity.exploreView.isUserInteractionEnabled = true        
            let tlTap = UITapGestureRecognizer(target: self, action: #selector(self.exploreNowClicked))
            noActivity.exploreView.addGestureRecognizer(tlTap)
            
            self.view.addSubview(noActivity)
        }
    }
    
    func exploreNowClicked() {
        print("\n Explore now clicked")
        self.searchTapped(UIButton())
    }
    
}



import UIKit
var globalMyLifeContainerViewController:MyLifeContainerViewController!

class MyLifeContainerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TLFooterBasicDelegate {
    
    @IBOutlet weak var myLifeFeedsTableView: UITableView!
    
    var isInitalLoad = true
    var empty: EmptyScreenView!
    var emptyTravel : MyLifeJourneyTravel!
    var timeTag:TimestampTagViewOnScroll!
    var isViewed:Bool = true
    var onTab:String = "all"    
    var isFromFooter:Bool = true
    
    var pageType: viewType = viewType.VIEW_TYPE_MY_LIFE
    private var feedsDataArray: [JSON] = []
    var currentPageNumber = 1
    var hasMorePages = true
    var isLoading = false
    
    private let TL_VISIBLE_CELL_TAG = 6789
    let separatorOffset = CGFloat(15.0)
    
    var loader = LoadingOverlay()
    let refreshControl = UIRefreshControl()
    
    var parentController: MyLifeViewController!
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        globalMyLifeContainerViewController = self
        
        print("\n ViewControllers : \(self.navigationController?.visibleViewController)")
        
        isEmptyProfile = false
        
        timeTag = TimestampTagViewOnScroll(frame: CGRect(x: 0, y: 100, width: screenWidth + 8, height: 40))
        timeTag.alpha = 0.8        
        self.view.addSubview(timeTag)
        timeTag.isHidden = true
        
        refreshControl.tintColor = mainOrangeColor
        self.myLifeFeedsTableView.addSubview(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Empty Screens
    
    let cnfg = Config()
    
    func showNoData(show:Bool, type:String) {
        if empty != nil {
            self.empty.removeFromSuperview()
            self.emptyTravel.removeFromSuperview()

        }
        if show {
            empty = EmptyScreenView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height + 10))
            empty.parentController = self
            
            emptyTravel = MyLifeJourneyTravel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            emptyTravel.center = self.view.center
            emptyTravel.parentController = self

            switch type {
            case "all":
                empty.frame.size.height = CGFloat(cnfg.getHeight(ht: Double(self.view.frame.height + 10)))
                empty.viewHeading.text = "Your Life in a Snapshot"
                empty.viewBody.text = "Capture your journeys and activities whether local or global, creating a beautiful timeline and relive these treasured experiences of your past."
                empty.setColor(life: "", buttonLabel: "Start a New Journey")
                self.view.addSubview(empty)

                break
            case "travel-life":
                emptyTravel.frame.size.height = CGFloat(cnfg.getHeight(ht: Double(self.view.frame.height + 10)))
                emptyTravel.setView()
                self.view.addSubview(emptyTravel)
                break
            case "local-life":
                                
                empty.frame.size.height = CGFloat(cnfg.getHeight(ht: Double(self.view.frame.height + 10)))
                empty.viewHeading.text = "Life In The City"
                empty.viewBody.text = "Candid, fun moments with friends, happy family get-togethers, some precious ‘me-time’…share your love for your city and inspire others to do the same."
                empty.setColor(life: "locallife", buttonLabel: "Add your first Local Activity")

                self.view.addSubview(empty)

                break
            default:
                break
            }
//            mainView.isHidden = true
        }
    }
    
    func journeyLoader() {
        loader.showOverlay(self.view)
    }
      
    
    //MARK: - Refresh Control
    
    func pullToRefreshCalled() {
        print("\n Pull to refresh called \n")
        
        refreshControl.endRefreshing()        
        
        if !isLoading {
            currentPageNumber = 1
            hasMorePages = true
            isLoading = false
            timeTag.isHidden = true
            
            self.getMyLifePostsData(pageNumber: currentPageNumber, type: onTab)
        }
    }
    
    
    //MARK: - Fetch Data
    
    func loadData(type:String, fromVC: MyLifeViewController?) {
        
        currentPageNumber = 1
        hasMorePages = true
        isLoading = false
        timeTag.isHidden = true
        
        self.feedsDataArray = []
        self.reloadTableData()
        
        if fromVC != nil {
            parentController = fromVC
        }
        
        if feedsDataArray.isEmpty && currentPageNumber == 1 {
            loader.showOverlay(self.view)
        }
        
        self.getMyLifePostsData(pageNumber: currentPageNumber, type: type)
    }
    
    func getMyLifePostsData(pageNumber: Int, type: String){
        
        print("\n\n Will fetch data for : \(currentPageNumber)")
        
        onTab = type
        
        var urlslug = ""
        if isFromFooter {
            selectedUser = []
            urlslug = ""
        }else{
            urlslug = selectedUser["urlSlug"].stringValue
        }
        
        request.getMomentJourney(pageNumber: pageNumber, type: type, urlSlug: urlslug, forTab: onTab, completion: {(response, responseForTab) in
           
            DispatchQueue.main.async(execute: {
                
                if responseForTab == self.onTab {
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
                    
                    if self.feedsDataArray.isEmpty && pageNumber == 1 {
                        self.showNoData(show: true, type: type)
                    }
                    else {
                        self.showNoData(show: false, type: type)
                    }
                }
                else {
                    print("\n\n Mismatch found:::: \n responseForTab:\(responseForTab) \n onTab:\(self.onTab)\n\n")
                }
            })
        })
    }
    
    
    //MARK: - Reload Table
    
    func reloadTableData() {
        
        loader.hideOverlayView()
        
        self.isLoading = false
        self.myLifeFeedsTableView.reloadData()
        
        if !self.feedsDataArray.isEmpty {
            timeTag.isHidden = false
            if currentPageNumber == 1 {
                self.scrollViewDidScroll(self.myLifeFeedsTableView)
            }
        }
    }
    
    func changeDateTag() {
        self.isLoading = true
        currentPageNumber = 1
        self.getMyLifePostsData(pageNumber: currentPageNumber, type: onTab)
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
                height = height + ((pageType == viewType.VIEW_TYPE_MY_LIFE) ? 0 : FEEDS_HEADER_HEIGHT) + getHeightForMiddleViewPostType(feed: cellData, pageType: viewType.VIEW_TYPE_MY_LIFE) + (shouldShowFooterCountView(feed: cellData) ? FEED_FOOTER_HEIGHT : (FEED_FOOTER_HEIGHT-FEED_FOOTER_LOWER_VIEW_HEIGHT)) + (isLocalFeed(feed: cellData) ? FEED_UPLOADING_VIEW_HEIGHT : 0)                        
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
            
            switch cellData["type"].stringValue {
                
            case "on-the-go-journey":
                fallthrough
            case "ended-journey":
                var feedCell = tableView.dequeueReusableCell(withIdentifier: "OTGCell", for: indexPath) as? TLOTGJourneyTableViewCell
                
                if feedCell == nil {
                    feedCell = TLOTGJourneyTableViewCell.init(style: .default, reuseIdentifier: "OTGCell", feedData: cellData, helper: parentController)
                }
                
                feedCell?.setData(feedData: cellData, helper: parentController, pageType: pageType, delegate: self)
                feedCell?.FFooterViewBasic.tag = indexPath.row
                return feedCell!
                
                
            case "travel-life":
                fallthrough
            case "local-life":
                var feedCell = tableView.dequeueReusableCell(withIdentifier: "TravelLocalCell", for: indexPath) as? TLTravelLocalLifeTableViewCell
                
                if feedCell == nil {
                    feedCell = TLTravelLocalLifeTableViewCell.init(style: .default, reuseIdentifier: "TravelLocalCell", feedData: cellData, helper: parentController)
                }
                
                feedCell?.setData(feedData: cellData, helper: parentController, pageType: pageType, delegate: self)
                feedCell?.FFooterViewBasic.tag = indexPath.row
                feedCell?.tag = TL_VISIBLE_CELL_TAG
                return feedCell!
                
                
            case "quick-itinerary":
                fallthrough
            case "detail-itinerary":
                var feedCell = tableView.dequeueReusableCell(withIdentifier: "ItineraryCell", for: indexPath) as? TLItineraryTableViewCell
                
                if feedCell == nil {
                    feedCell = TLItineraryTableViewCell.init(style: .default, reuseIdentifier: "ItineraryCell", feedData: cellData, helper: parentController)
                }
                
                feedCell?.setData(feedData: cellData, helper: parentController, pageType: pageType, delegate: self)
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
                self.myLifeFeedsTableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
            }
        }
        else { 
            self.myLifeFeedsTableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
        }               
    }
    
    func footerRatingUpdated(rating: JSON, tag: Int) {        
        var currentJson = feedsDataArray[tag]            
        currentJson["review"][0] = ["rating":"\(rating["rating"].stringValue)","review":rating["review"].stringValue]            
        if (currentJson["review"].isEmpty){
            currentJson["review"] = [["rating":"\(rating["rating"].stringValue)","review":rating["review"].stringValue]]
        }
        feedsDataArray[tag] = currentJson
        
        self.myLifeFeedsTableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
    }
    
    
    //MARK: - Scrolling Delegates
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            globalMyLifeController.hideHeaderAndFooter(true);
        }
        else{
            globalMyLifeController.hideHeaderAndFooter(false);
        }
        
        for visibleCell in myLifeFeedsTableView.visibleCells {
            let cellStart = visibleCell.frame.origin.y - scrollView.contentOffset.y
            let cellEnd = cellStart + visibleCell.frame.size.height
            
            if((cellStart < self.timeTag.frame.origin.y) && (cellEnd > (self.timeTag.frame.origin.y + self.timeTag.frame.size.height))) {
                if visibleCell.isKind(of: TLOTGJourneyTableViewCell.self) {
                    self.timeTag.changeTime(feed: (visibleCell as! TLOTGJourneyTableViewCell).feeds)                    
                }
                else if visibleCell.isKind(of: TLTravelLocalLifeTableViewCell.self) {
                    self.timeTag.changeTime(feed: (visibleCell as! TLTravelLocalLifeTableViewCell).feeds)                    
                }
                else if visibleCell.isKind(of: TLItineraryTableViewCell.self) {
                    self.timeTag.changeTime(feed: (visibleCell as! TLItineraryTableViewCell).feeds)                    
                }
            }
        }
    }
    
    //for adding more content when scrolled to end of table
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        for visibleCell in myLifeFeedsTableView.visibleCells {
            if visibleCell.tag == TL_VISIBLE_CELL_TAG {
                let requiredCell = visibleCell as! TLTravelLocalLifeTableViewCell
                requiredCell.videoToPlay(scrollView: scrollView)
            }
        }
        
        if (maximumOffset-currentOffset) <= 0 {
            if hasMorePages && !isLoading {                
                print("\n table scolled to end, fetch more content...")
                self.isLoading = true
                self.myLifeFeedsTableView.reloadData()
                
                currentPageNumber += 1
                self.getMyLifePostsData(pageNumber: currentPageNumber, type: self.onTab)                
            }
        }        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(refreshControl.isRefreshing){
            self.pullToRefreshCalled()
        }
    }
    
}

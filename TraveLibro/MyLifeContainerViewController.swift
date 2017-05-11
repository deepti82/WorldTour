

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
    var loader = LoadingOverlay()
    var isFromFooter:Bool = true
    
    var pageType: viewType = viewType.VIEW_TYPE_MY_LIFE
    private var feedsDataArray: [JSON] = []
    var currentPageNumber = 1
    var hasMorePages = true
    var isLoading = false
    
    private let TL_VISIBLE_CELL_TAG = 6789
    let separatorOffset = CGFloat(15.0)
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
            emptyTravel = MyLifeJourneyTravel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            emptyTravel.center = self.view.center

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
      
    
    //MARK: - Fetch Data
    
    func loadData(type:String, pageNumber:Int, fromVC: MyLifeViewController?) {
        
        self.feedsDataArray = []
        self.reloadTableData()
        
        if fromVC != nil {
            parentController = fromVC
        }        
        self.getMyLifePostsData(pageNumber: pageNumber, type: type)
    }
    
    func getMyLifePostsData(pageNumber: Int, type: String){
        
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
                    
                    if self.feedsDataArray.isEmpty {
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
        self.isLoading = false
        self.myLifeFeedsTableView.reloadData()
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
        return feedsDataArray.count
    }    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = separatorOffset
        
        let cellData = self.feedsDataArray[indexPath.row]        
        switch cellData["type"].stringValue {
            
        case "on-the-go-journey":
            fallthrough
        case "ended-journey":
            let displatTextString = getTextHeader(feed: cellData, pageType: pageType)
            var textHeight = (heightOfAttributedText(attributedString: displatTextString, width: (screenWidth-21)) + 10)            
            textHeight = ((cellData["countryVisited"].arrayValue).isEmpty) ? textHeight : max(textHeight, 36)
            height = height + FEEDS_HEADER_HEIGHT + textHeight + screenWidth*0.9 + (shouldShowFooterCountView(feed: cellData) ? FEED_FOOTER_HEIGHT : (FEED_FOOTER_HEIGHT-FEED_FOOTER_LOWER_VIEW_HEIGHT)) + (isLocalFeed(feed: cellData) ? FEED_UPLOADING_VIEW_HEIGHT : 0)
            break
            
            
        case "travel-life":
            fallthrough
        case "local-life":
            height = height + FEEDS_HEADER_HEIGHT + getHeightForMiddleViewPostType(feed: cellData) + (shouldShowFooterCountView(feed: cellData) ? FEED_FOOTER_HEIGHT : (FEED_FOOTER_HEIGHT-FEED_FOOTER_LOWER_VIEW_HEIGHT)) + (isLocalFeed(feed: cellData) ? FEED_UPLOADING_VIEW_HEIGHT : 0)                        
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellData = self.feedsDataArray[indexPath.row]
        self.timeTag.changeTime(feed: cellData)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("\n Row selected at index : \(indexPath.row)")
        
        tableView.deselectRow(at: indexPath, animated: true)
        
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
                currentPageNumber += 1
                self.loadData(type: onTab, pageNumber: currentPageNumber, fromVC: self.parentController)
            }
        }
        
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        
//        
//        for postView in layout.subviews {
//            if(postView is MyLifeActivityFeedsLayout) {
//                let photosOtg = postView as! MyLifeActivityFeedsLayout
//                
//                let min = photosOtg.frame.origin.y - self.TheScrollView.contentOffset.y
//                let max = min + photosOtg.frame.size.height
//                
//                if((min < 100) && (max > 140))
//                {
//                    self.timeTag.changeTime(feed: photosOtg.feeds)
//                }
//            }
//        }
//        
//    }
}

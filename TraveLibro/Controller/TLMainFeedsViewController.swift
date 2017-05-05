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


class TLMainFeedsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var feedsTableView: UITableView!
    var mainFooter: FooterViewNew?
    
    var pageType: viewType = viewType.VIEW_TYPE_ACTIVITY
    
    var feedsDataArray: [JSON] = []
    var currentPageNumber = 1
    
    let separatorOffset = CGFloat(15.0)    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        getDarkBackGround(self)
        
        feedsTableView.tableFooterView = UIView()
        
        self.setupView()
        
        self.getDataMain()    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mainFooter?.frame = CGRect(x: 0, y: self.view.frame.height - MAIN_FOOTER_HEIGHT, width: self.view.frame.width, height: MAIN_FOOTER_HEIGHT)        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        globalNavigationController = self.navigationController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Setup View 
    
    func setupView() {
        
        feedsTableView.dataSource = self
        feedsTableView.delegate = self
        
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
    }
    
    
    //MARK: - Fetch Data
    
    func getDataMain() {
        
        switch pageType {
            
        case .VIEW_TYPE_ACTIVITY:
            self.getActivityFeedsData(pageNumber: currentPageNumber)
            break
            
        case .VIEW_TYPE_MY_LIFE:
            break
            
        case .VIEW_TYPE_LOCAL_LIFE:
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
            
            request.getActivityFeeds(currentUser["_id"].stringValue, pageNumber: pageNumber, completion: { (response, localPostResponse, localQuickItineraryResponse, isFromCache) in
                
                DispatchQueue.main.async(execute: {
                    
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
                    
                    self.reloadTableData()
                })
            })
        }
    }
    
    
    //MARK: - Reload Table
    
    func reloadTableData() {
        self.feedsTableView.reloadData()
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
            var textHeight = (heightOfAttributedText(attributedString: displatTextString, width: screenWidth) + 10)            
            textHeight = ((cellData["countryVisited"].arrayValue).isEmpty) ? textHeight : max(textHeight, 36)
            height = height + FEEDS_HEADER_HEIGHT + textHeight + screenWidth*0.9 + (shouldShowFooterCountView(feed: cellData) ? 90 : 50)
            break
            
            
        case "travel-life":
            height = height + FEEDS_HEADER_HEIGHT + screenWidth*0.9 + (shouldShowFooterCountView(feed: cellData) ? 90 : 50)
            break
            
            
        case "quick-itinerary":
            fallthrough
        case "detail-itinerary":
            let displatTextString = getTextHeader(feed: cellData, pageType: pageType)
            var textHeight = (heightOfAttributedText(attributedString: displatTextString, width: screenWidth) + 10)            
            textHeight = ((cellData["countryVisited"].arrayValue).isEmpty) ? textHeight : max(textHeight, 36)
            height = height + ((pageType == viewType.VIEW_TYPE_ACTIVITY) ? FEEDS_HEADER_HEIGHT : 0) + textHeight + screenWidth*0.9 + (shouldShowFooterCountView(feed: cellData) ? 90 : 50)
            break
            
        default:
            
            print("\n default case : \(cellData["type"].stringValue)")
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
            
            feedCell?.setData(feedData: cellData, helper: self, pageType: pageType)
            return feedCell!
            
        
        case "travel-life":
            var feedCell = tableView.dequeueReusableCell(withIdentifier: "TravelLocalCell", for: indexPath) as? TLTravelLocalLifeTableViewCell
            
            if feedCell == nil {
                feedCell = TLTravelLocalLifeTableViewCell.init(style: .default, reuseIdentifier: "TravelLocalCell", feedData: cellData, helper: self)
            }
            
            feedCell?.setData(feedData: cellData, helper: self, pageType: pageType)
            return feedCell!
            
        
        case "quick-itinerary":
            fallthrough
        case "detail-itinerary":
            var feedCell = tableView.dequeueReusableCell(withIdentifier: "ItineraryCell", for: indexPath) as? TLItineraryTableViewCell
            
            if feedCell == nil {
                feedCell = TLItineraryTableViewCell.init(style: .default, reuseIdentifier: "ItineraryCell", feedData: cellData, helper: self)
            }
            
            feedCell?.setData(feedData: cellData, helper: self, pageType: pageType)
            return feedCell!
            
            
            
        default:
            print("\n default case : \(cellData["type"].stringValue)")
        }
        
                        
        let feedCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return feedCell
    }
    
    
    //MARK: - 
    //MARK: - Actions
    
    //MARK: - Header Action
    
    func toProfile(toUser: JSON) {
        
        if currentUser != nil {
            selectedUser = toUser
            let profile = storyboard?.instantiateViewController(withIdentifier: "TLProfileView") as! TLProfileViewController
            profile.displayData = "search"
            profile.currentSelectedUser = selectedUser
            self.navigationController?.pushViewController(profile, animated: true)
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
    }

}

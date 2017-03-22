//
//  AccordionViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 24/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
var globalAccordionViewController:AccordionViewController!
var cellTable: UITableView!
var allData:[JSON] = []

class AccordionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableMainView: UITableView!
    @IBOutlet weak var accordionTableView: UITableView!
    var labels = ["header", "Mumbai", "Delhi", "Chennai", "Kolkata", "Bengaluru", "Hyderabad","header"]
    var isExpanded = false
    var childCells = 0
    var selectedIndex: Int!
    var allData:[JSON] = []
    var pagenumber:Int = 1
    var empty: EmptyScreenView!
    var loader = LoadingOverlay()
    var whichView = "All"
    var reviewType = "all"
    var country = ""
    var city = ""
    var category = ""
    var countryName = ""
    var cityName = ""
    var selectedView = 1
    var loadStatus:Bool = true
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellTable = self.tableMainView
        self.loader.showOverlay(self.view)
        //        getDarkBackGround(self)
        globalAccordionViewController = self
        setTopNavigation("Reviews")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(loadStatus)
        if loadStatus {
            loadReview(pageno: self.pagenumber, type: reviewType)
        }
    }
    
    
    func getHeaderJSON() -> JSON {
        var returnJson:JSON = []
        if reviewType == "country" {
            
            returnJson = ["name":countryName, "_id":country]
            return returnJson
            
        }else if reviewType == "city" {
            
            returnJson = ["name":cityName, "_id":city]
            return returnJson
            
        }else{
            if country != "" {
                returnJson = ["name":self.cityName, "_id":city]
                return returnJson
            }else{
                returnJson = ["name":self.category, "_id":category]
                return returnJson
            }
            
            
        }
        
    }
    
    func setTopNavigation(_ text: String) {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.goBack(_:)), for: .touchUpInside)
        let rightButton = UIView()
        self.title = text
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]
        
        self.customNavigationBar(left: leftButton, right: rightButton)
    }
    
    func showNoData(show:Bool) {
        if empty != nil {
            self.empty.removeFromSuperview()
        }
        if show {
            empty = EmptyScreenView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
            switch reviewType {
            case "all":
                print("in moments all")
                empty.frame.size.height = 250.0
                empty.viewHeading.text = "Unwind​ B​y Rewinding"
                empty.viewBody.text = "Revisit and reminisce the days gone by through brilliant pictures and videos of your travel and local life."
                break
            case "travel-life":
                print("in moments tl")
                empty.frame.size.height = 350.0
                empty.viewHeading.text = "Travel Becomes A Reason To Take Pictures And Store Them"
                empty.viewBody.text = "Some memories are worth sharing, travel surely tops the list. Your travels will not only inspire you to explore more of the world, you may just move another soul or two!"
                break
            case "local-life":
                print("in moments ll")
                empty.frame.size.height = 275.0
                empty.viewHeading.text = "Suspended In Time"
                empty.viewBody.text = "Beautiful memories created through fabulous pictures and videos of those precious moments shared with family, friends and yourself."
                break
            default:
                break
            }
            self.view.addSubview(empty)
            accordionTableView.isHidden = true
        }
    }
    
    func goBack(_ sender:AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    
    func loadByLocation(location:String, id:String) {
        reviewType = location
        print("GetReviewByLoc")
        request.getReviewByLoc(currentUser["_id"].stringValue, location: location, id: id, completion: {(request) in
            DispatchQueue.main.async {
                self.loader.hideOverlayView()
                self.allData = []
                self.allData.append(self.getHeaderJSON())
                
                for post in request["data"].array! {
                    self.allData.append(post)
                }
                print("in the api load \(self.allData)")
                self.accordionTableView.delegate = self
                self.accordionTableView.dataSource = self
                self.accordionTableView.reloadData()
                if self.allData.count == 0 {
                    self.accordionTableView.isHidden = true
                    self.showNoData(show: true)
                }else{
                    self.showNoData(show: false)
                }
            }
        })
    }
    
    func loadCountryCityReview(pageno:Int, type:String, json:JSON) {
        selectedView = 2
        print(".....\(json)")
        reviewType = "reviewby"
        self.country = ""
        self.city = ""
        self.category = ""
        if type == "country" {
            self.country = json["country"].stringValue
            self.city = json["_id"].stringValue
            self.cityName = json["name"].stringValue
        }else if type == "city" {
            self.city = json["city"].stringValue
            self.category = json["_id"].stringValue
        }
        print("getReview")
        request.getReview(currentUser["_id"].stringValue, country: country, city: city, category: category, pageNumber: pageno, completion: {(request) in
            DispatchQueue.main.async {
                self.loader.hideOverlayView()
                if request["data"].count > 0 {
                    if pageno == 1 {
                        self.allData = []
                        self.allData.append(self.getHeaderJSON())
                        for post in request["data"].array! {
                            self.allData.append(post)
                        }
                        print("in get review city country \(self.allData)")
                    }else{
                        for post in request["data"].array! {
                            self.allData.append(post)
                        }
                    }
                }
                
                self.accordionTableView.reloadData()
                if self.allData.count == 0 {
                    self.accordionTableView.isHidden = true
                    self.showNoData(show: true)
                }else{
                    self.showNoData(show: false)
                }
            }
            
        })
    }
    
    func loadReview(pageno:Int, type:String) {
        selectedView = 1
        reviewType = type
        loadStatus = false
        print("getmylifereview")
        request.getMyLifeReview(currentUser["_id"].stringValue, pageNumber: pageno, type: type, completion: {(request) in
            DispatchQueue.main.async {
                self.loader.hideOverlayView()
                if request["data"].count > 0 {
                    if pageno == 1 {
                        self.allData = request["data"].array!
                    }else{
                        for post in request["data"].array! {
                            self.allData.append(post)
                        }
                    }
                    self.loadStatus = true
                    self.pagenumber = self.pagenumber + 1
                }else{
                    self.loadStatus = false
                }
                
                self.accordionTableView.reloadData()
                if self.allData.count == 0 {
                    self.accordionTableView.isHidden = true
                    self.showNoData(show: true)
                }else{
                    self.showNoData(show: false)
                }
            }
        })
    }
    func setAll() {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch reviewType {
        case "all":
            let cell = tableView.dequeueReusableCell(withIdentifier: "allReviewsCell") as! allReviewsMLTableViewCell
            cell.tag = indexPath.row
            cell.calendarLabel.text = String(format: "%C", faicon["calendar"]!)
            cell.clockLabel.text = String(format: "%C", faicon["clock"]!)
            cell.locationLabel.text = "\(allData[indexPath.row]["checkIn"]["city"].stringValue), \(allData[indexPath.row]["checkIn"]["country"].stringValue)"
            cell.placeTitle.text = allData[indexPath.row]["checkIn"]["location"].stringValue
            cell.setView(feed: allData[indexPath.row])
            setAll()
            
            return cell
            
        case "reviewby":
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! reviewsHeaderCell
                cell.countryTitle.text = allData[indexPath.row]["name"].stringValue
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "allReviewsCell") as! allReviewsMLTableViewCell
                cell.calendarLabel.text = String(format: "%C", faicon["calendar"]!)
                cell.clockLabel.text = String(format: "%C", faicon["clock"]!)
                cell.locationLabel.text = "\(allData[indexPath.row]["checkIn"]["city"].stringValue), \(allData[indexPath.row]["checkIn"]["country"].stringValue)"
                cell.placeTitle.text = allData[indexPath.row]["checkIn"]["location"].stringValue
                cell.setView(feed: allData[indexPath.row])
                
                return cell
                
            }
        default:
            print(reviewType)
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! reviewsHeaderCell
                cell.countryTitle.text = allData[indexPath.row]["name"].stringValue
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! cityLabelTableViewCell
                
                print("............>>>>>>>>>>>>>>>>>> \(reviewType)")
                if reviewType == "city" {
                    cell.nameLabel.text = allData[indexPath.row]["_id"].stringValue
                    cell.seperatorView.backgroundColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
                }else{
                    cell.nameLabel.text = allData[indexPath.row]["name"].stringValue
                    cell.seperatorView.backgroundColor = mainOrangeColor
                }
                return cell
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(allData[indexPath.row])
        if reviewType == "city" {
            self.loadCountryCityReview(pageno:1, type: "city", json: allData[indexPath.row])
        } else if reviewType == "country" {
            self.loadCountryCityReview(pageno:1, type: "country", json: allData[indexPath.row])
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        if reviewType == "all" {
            if allData[indexPath.row]["review"][0]["review"] == nil || allData[indexPath.row]["review"][0]["review"].stringValue == ""  {
                return 115
            }
            return 143
            
        }
            
        else if reviewType == "reviewby" {
            if indexPath.row == 0 {
                return 45
            }else{
                if allData[indexPath.row]["review"][0]["review"] == nil || allData[indexPath.row]["review"][0]["review"].stringValue == ""  {
                    return 115
                }
                return 143
            }
        }
        
        return 45
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allData.count
        
    }
    
}

class cityLabelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var seperatorView: UIView!
    
}

class cityExploreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeTitle: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var placeIcon: UIImageView!
    @IBOutlet weak var placeReviewDescription: UILabel!
    
}

class allReviewsMLTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var placeTitle: UILabel!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var review: UILabel!
    @IBOutlet weak var calendarDate: UILabel!
    @IBOutlet weak var clockTime: UILabel!
    @IBOutlet weak var ratingStack: UIStackView!
    @IBOutlet var starImageArray: [UIImageView]!
    var backgroundReview: UIView!
    var postTop:JSON = []
    var newRating:JSON = []
    
    let categories: [JSON] = [["title": "Transportation", "image": "planetrans"], ["title": "Hotels & Accomodations", "image": "hotels-1"], ["title": "Restaurants & Bars", "image": "restaurantsandbars"], ["title": "Nature & Parks", "image": "leaftrans"], ["title": "Sights & Landmarks", "image": "sightstrans"], ["title": "Museums & Galleries", "image": "museumstrans"], ["title": "Religious", "image": "regli"], ["title": "Shopping", "image": "shopping"], ["title": "Zoo & Aquariums", "image": "zootrans"], ["title": "Cinema & Theatres", "image": "cinematrans"], ["title": "City", "image": "city_icon"], ["title": "Health & Beauty", "image": "health_beauty"], ["title": "Rentals", "image": "rentals"], ["title": "Entertainment", "image": "entertainment"], ["title": "Essentials", "image": "essential"], ["title": "Emergency", "image": "emergency"], ["title": "Others", "image": "othersdottrans"]]
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    //    @IBAction func ratingButtonClicked(_ sender: UIButton) {
    //        print("in clicked")
    //        openRating()
    //    }
    func checkMyRating(_ sender: UIButton) {
        
        print("check i im the creator")
        openRating()
    }
    func checkMyRatingStar(_ sender: UITapGestureRecognizer) {
        print("in footer tap out")
        openRating()
        
    }
    
    func getCategory(type:String) -> String {
        var returnValue = ""
        for item in categories {
            if item["title"].stringValue == type {
                returnValue = item["image"].stringValue
            }
        }
        return returnValue
    }
    
    func reviewTapOut(_ sender: UITapGestureRecognizer) {
        print("in footer tap out")
        backgroundReview.removeFromSuperview()
        
    }
    
    func openRating() {
        let tapout = UITapGestureRecognizer(target: self, action: #selector(self.reviewTapOut(_:)))
        backgroundReview = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: (globalNavigationController.topViewController?.view.frame.size.height)!))
        backgroundReview.addGestureRecognizer(tapout)
        backgroundReview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        globalNavigationController.topViewController?.view.addSubview(backgroundReview)
        globalNavigationController.topViewController?.view.bringSubview(toFront: backgroundReview)
        
        let rating = AddRating(frame: CGRect(x: 0, y: 0, width: width - 40, height: 335))
        rating.activityJson = postTop
        
        if postTop["type"].stringValue == "travel-life" {
            rating.whichView = "otg"
            rating.switchSmily()
        }else{
            rating.whichView = ""
            rating.switchSmily()
        }
        
        rating.accordianCell = self
        rating.checkView = "accordian"
        
        
        if postTop["review"][0]["rating"] != nil  && postTop["review"].count != 0 {
            print("step one")
            if newRating != nil {
                print("in two if")
                rating.starCount = newRating["rating"].intValue
                rating.ratingDisplay(newRating)
            }else{
                print("in two else")
                rating.starCount = postTop["review"][0]["rating"].intValue
                rating.ratingDisplay(postTop["review"][0])
            }
        }else{
            
            if newRating != nil && newRating["rating"] != nil {
                print("in three if")
                rating.starCount = newRating["rating"].intValue
                rating.ratingDisplay(newRating)
                
            }else{
                print("in three else")
                rating.starCount = 1
            }
        }
        
        rating.center = backgroundReview.center
        rating.layer.cornerRadius = 5
        rating.clipsToBounds = true
        rating.navController = globalNavigationController
        backgroundReview.addSubview(rating)
    }
    
    func setView(feed:JSON) {
        self.review.isHidden = true
        postTop = feed
        var cl = self
        ratingButton.addTarget(self, action: #selector(self.checkMyRating(_:)), for: .touchUpInside)
        let tapout = UITapGestureRecognizer(target: self, action: #selector(self.checkMyRatingStar(_:)))
        ratingStack.addGestureRecognizer(tapout)
        categoryImage.image = UIImage(named: getCategory(type: feed["checkIn"]["category"].stringValue))
        categoryImage.tintColor = mainBlueColor
        
        if postTop["type"].stringValue == "travel-life" {
            ratingButton.setTitleColor(mainOrangeColor, for: .normal)
        }else{
            ratingButton.setTitleColor(endJourneyColor, for: .normal)

        }
        
        if feed["review"][0] != nil && feed["review"].count > 0 {
            ratingStack.isHidden = false
            ratingButton.isHidden = true
            if feed["review"][0]["review"].stringValue != "" {
                self.review.text = feed["review"][0]["review"].stringValue
                self.review.sizeToFit()
            }
            afterRating(starCnt: feed["review"][0]["rating"].intValue, review: feed["review"][0]["review"].stringValue, type:feed["type"].stringValue)
        }else{
            if feed["checkIn"] != nil && feed["checkIn"]["category"].stringValue != "" {
                ratingStack.isHidden = true
                ratingButton.isHidden = false
                
            }else{
                ratingStack.isHidden = true
                ratingButton.isHidden = true
            }
        }
        
    }
    
    func afterRating(starCnt:Int, review:String, type:String) {
        print(starCnt)
        if starCnt != 0 {
            print("start rating \(self.tag)")
            for rat in starImageArray {
                if rat.tag > starCnt {
                    rat.image = UIImage(named: "star_uncheck")
                }else{
                    rat.image = UIImage(named: "star_check")
                    if type == "travel-life" {
                        rat.tintColor = mainOrangeColor
                    }else{
                        rat.tintColor = endJourneyColor
                    }
                }
            }
            
            if review != "" {
                self.review.isHidden = false
                self.review.text = review
                allData[self.tag]["review"][0]["review"].string = review
            }
//            self.rel
            newRating = ["rating":"\(starCnt)","review":review]
            ratingStack.isHidden = false
            ratingButton.isHidden = true
            
            cellTable.reloadRows(at: [NSIndexPath(row:self.tag, section:0) as IndexPath], with: .automatic)
            
        }
        
    }
    
    
}

class reviewsHeaderCell: UITableViewCell {
    
    @IBOutlet weak var countryTitle: UILabel!
    
}

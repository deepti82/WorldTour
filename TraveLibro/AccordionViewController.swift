//
//  AccordionViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 24/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
var globalAccordionViewController:AccordionViewController!
var allData:[JSON] = []

class AccordionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableMainView: UITableView!
    @IBOutlet weak var accordionTableView: UITableView!
    var labels = ["header", "Mumbai", "Delhi", "Chennai", "Kolkata", "Bengaluru", "Hyderabad","header"]
    var isExpanded = false
    var childCells = 0
    var selectedIndex: Int!
    var pagenumber:Int = 1
    var empty: EmptyScreenView!
    var whichView = "All"
    var reviewType = "all"
    var country = ""
    var city = ""
    var category = ""
    var countryName = ""
    var cityName = ""
    var selectedView = 1
    var loadStatus:Bool = true
    var isViewed:Bool = true
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allData = []
        globalAccordionViewController = self
        setTopNavigation("Reviews")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
        setNavigationBarItemText(text)
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]
        
        self.customNavigationBar(left: leftButton, right: rightButton)
    }
    
    let cnfg = Config()
    
    func showNoData(show:Bool) {
        if empty != nil {
            self.empty.removeFromSuperview()
        }
        if show {
            empty = EmptyScreenView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
            switch reviewType {
            case "all":
                empty.frame.size.height = CGFloat(cnfg.getHeight(ht: 350))
                empty.viewHeading.text = "Relive Y​our Experiences"
                empty.viewBody.text = "Rate the hotels, restaurants, theatres, parks, museums, and more, when you check-in and review your experiences there."
                empty.setColor(life: "", buttonLabel: "Start a New Journey")

                break
            case "travel-life":
                empty.frame.size.height = CGFloat(cnfg.getHeight(ht: 350))
                empty.viewHeading.text = "The World I​s Your Oyster"
                empty.viewBody.text = "A five star or a four star? What does that historical monument qualify for? Rate it and write a review. Help others with your rating and review."
                empty.setColor(life: "", buttonLabel: "Add a Travel Journey")

                break
            case "local-life":
                empty.frame.size.height = CGFloat(cnfg.getHeight(ht: 350))
                empty.viewHeading.text = "A Touch Of Your Daily Dose"
                empty.viewBody.text = "Now how about rating and writing a super review for that newly-opened restaurant in your town? Wherever you go, click on a star and pen down your experiences."
                empty.setColor(life: "locallife", buttonLabel: "Add your first Local Activity")

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
    
        loader.showOverlay(self.view)
        reviewType = location
        request.getReviewByLoc(user.getExistingUser(), location: location, id: id, urlSlug:selectedUser["urlSlug"].stringValue, completion: {(request) in
            DispatchQueue.main.async {
                loader.hideOverlayView()
                allData = []
                allData.append(self.getHeaderJSON())
                
                for post in request["data"].array! {
                    allData.append(post)
                }
                self.accordionTableView.delegate = self
                self.accordionTableView.dataSource = self
                self.accordionTableView.reloadData()
                if allData.count == 0 {
                    self.accordionTableView.isHidden = true
                    self.showNoData(show: true)
                }else{
                    self.showNoData(show: false)
                }
            }
        })
        
    }
    
    func loadCountryCityReview(pageno:Int, type:String, json:JSON) {
        if pageno == 1 {
        loader.showOverlay(self.view)
            allData = []
        }
        selectedView = 2
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
        request.getReview(user.getExistingUser(), country: country, city: city, category: category, pageNumber: pageno, urlSlug: selectedUser["urlSlug"].stringValue, completion: {(request) in
            DispatchQueue.main.async {
                loader.hideOverlayView()
                if request["data"].count > 0 {
                    if pageno == 1 {
                        allData = []
                        allData.append(self.getHeaderJSON())
                        for post in request["data"].array! {
                            allData.append(post)
                        }
                    }else{
                        for post in request["data"].array! {
                            allData.append(post)
                        }
                    }
                }
                
                self.accordionTableView.reloadData()
                if allData.count == 0 {
                    self.accordionTableView.isHidden = true
                    self.showNoData(show: true)
                }else{
                    self.showNoData(show: false)
                }
            }
            
        })
    }
    
    func loadReview(pageno:Int, type:String) {
        if pageno == 1 {
        loader.showOverlay(self.view)
            allData = []
        }
        selectedView = 1
        reviewType = type
        loadStatus = false
        request.getMyLifeReview(user.getExistingUser(), pageNumber: pageno, type: type, urlSlug: selectedUser["urlSlug"].stringValue, completion: {(request) in
            DispatchQueue.main.async {
                loader.hideOverlayView()
                if request["data"].count > 0 {
                    if pageno == 1 {
                        allData = request["data"].array!
                    }else{
                        for post in request["data"].array! {
                            allData.append(post)
                        }
                    }
                    self.loadStatus = true
                    self.pagenumber = self.pagenumber + 1
                }else{
                    self.loadStatus = false
                }
                
                self.accordionTableView.reloadData()
                if allData.count == 0 {
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
            cell.helper = self
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
                //cell.countryButton.tintColor = mainGreenColor
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "allReviewsCell") as! allReviewsMLTableViewCell
                cell.helper = self
                cell.tag = indexPath.row
                cell.calendarLabel.text = String(format: "%C", faicon["calendar"]!)
                cell.clockLabel.text = String(format: "%C", faicon["clock"]!)
                cell.locationLabel.text = "\(allData[indexPath.row]["checkIn"]["city"].stringValue), \(allData[indexPath.row]["checkIn"]["country"].stringValue)"
                cell.placeTitle.text = allData[indexPath.row]["checkIn"]["location"].stringValue
                cell.setView(feed: allData[indexPath.row])
                
                return cell
                
            }
        default:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! reviewsHeaderCell
                cell.countryTitle.text = allData[indexPath.row]["name"].stringValue
                
                if reviewType == "city" {
                    cell.countryButton.tintColor = mainGreenColor
                    cell.countryTitle.textColor = mainGreenColor
                }else{
                    cell.countryButton.tintColor = mainOrangeColor
                    cell.countryTitle.textColor = mainOrangeColor
                }
                
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! cityLabelTableViewCell
                
                if reviewType == "city" {
                    cell.nameLabel.text = allData[indexPath.row]["_id"].stringValue
                    cell.seperatorView.backgroundColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
                    cell.buttonLabel.tintColor = mainGreenColor
                }else{
                    cell.nameLabel.text = allData[indexPath.row]["name"].stringValue
                    cell.seperatorView.backgroundColor = mainOrangeColor
                    cell.buttonLabel.tintColor = mainOrangeColor
                }
                return cell
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        if reviewType == "all" || (reviewType == "reviewby" && indexPath.row != 0) {
            return false            
        }
        
        return true
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
    var helper : AccordionViewController!
    
    let categories: [JSON] = [["title": "Transportation", "image": "planetrans"], ["title": "Hotels & Accomodations", "image": "hotels-1"], ["title": "Restaurants & Bars", "image": "restaurantsandbars"], ["title": "Nature & Parks", "image": "leaftrans"], ["title": "Sights & Landmarks", "image": "sightstrans"], ["title": "Museums & Galleries", "image": "museumstrans"], ["title": "Religious", "image": "regli"], ["title": "Shopping", "image": "shopping"], ["title": "Zoo & Aquariums", "image": "zootrans"], ["title": "Cinema & Theatres", "image": "cinematrans"], ["title": "City", "image": "city_icon"], ["title": "Health & Beauty", "image": "health_beauty"], ["title": "Rentals", "image": "rentals"], ["title": "Entertainment", "image": "entertainment"], ["title": "Essentials", "image": "essential"], ["title": "Emergency", "image": "emergency"], ["title": "Others", "image": "othersdottrans"]]
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    func checkMyRating(_ sender: UIButton) {
        
        openRating()
    }
    func checkMyRatingStar(_ sender: UITapGestureRecognizer) {
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
        rating.activityJson = allData[self.tag]
        
        if rating.activityJson["type"].stringValue == "travel-life" {
            rating.whichView = "otg"
        }else{
            rating.whichView = ""            
        }
        rating.switchSmily()
        rating.accordianCell = self
        rating.checkView = "accordian"
        
        
        if rating.activityJson["review"][0]["rating"] != nil  && rating.activityJson["review"].count != 0 {
            rating.starCount = rating.activityJson["review"][0]["rating"].intValue
            rating.ratingDisplay(rating.activityJson["review"][0])
        }else{
            rating.starCount = 1
        }
        
        rating.center = backgroundReview.center
        rating.layer.cornerRadius = 5
        rating.clipsToBounds = true
        rating.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil))

        rating.navController = globalNavigationController
        backgroundReview.addSubview(rating)
    }
    
    func setView(feed:JSON) {
        self.review.isHidden = true
        self.ratingButton.isHidden = false
        self.ratingButton.setTitle("Rate this now", for: .normal)
        
        ratingButton.removeTarget(self, action: #selector(self.checkMyRating(_:)), for: .touchUpInside)       
        ratingStack.isUserInteractionEnabled = false
        
        if isSelfUser(otherUserID: currentUser["_id"].stringValue) {
            ratingButton.addTarget(self, action: #selector(self.checkMyRating(_:)), for: .touchUpInside)
            
            let tapout = UITapGestureRecognizer(target: self, action: #selector(self.checkMyRatingStar(_:)))
            ratingStack.addGestureRecognizer(tapout)
            ratingStack.isUserInteractionEnabled = true
        }
        else {
            self.review.text = ""
            self.review.isHidden = true
        }
        
        categoryImage.image = UIImage(named: getCategory(type: feed["checkIn"]["category"].stringValue))
        categoryImage.tintColor = mainBlueColor
        
        calendarDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd-MM-yyyy", date: feed["UTCModified"].stringValue, isDate: true)
        clockTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["UTCModified"].stringValue, isDate: false)

        
        if feed["type"].stringValue == "travel-life" {
            ratingButton.setTitleColor(mainOrangeColor, for: .normal)
        }else{
            ratingButton.setTitleColor(endJourneyColor, for: .normal)

        }
        
        if feed["review"][0] != nil && feed["review"].count > 0 {
            ratingStack.isHidden = false
            ratingButton.isHidden = true
            if feed["review"][0]["review"].stringValue != "" {                
                if isSelfUser(otherUserID: currentUser["_id"].stringValue) {
                    self.review.text = feed["review"][0]["review"].stringValue
                    self.review.sizeToFit()
                }
                else{
                    self.review.text = ""
                    self.review.isHidden = true
                }
            }
            afterRating(starCnt: feed["review"][0]["rating"].intValue, review: feed["review"][0]["review"].stringValue, type:feed["type"].stringValue, shouldReload: false)
        }else{
            if feed["checkIn"] != nil && feed["checkIn"]["category"].stringValue != "" {
                ratingStack.isHidden = true
                self.ratingButton.setTitle( (isSelfUser(otherUserID: currentUser["_id"].stringValue)) ? "Rate this now" : "Not reviewed yet", for: .normal)
                
            }else{
                ratingStack.isHidden = true
                ratingButton.isHidden = true
            }
        }
        
    }
    
    func afterRating(starCnt:Int, review:String, type:String, shouldReload:Bool) {
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
            }
            
            ratingStack.isHidden = false
            ratingButton.isHidden = true
        }
        
        if shouldReload {
            var currentJson = allData[self.tag]            
            currentJson["review"][0] = ["rating":"\(starCnt)","review":review]            
            if (currentJson["review"].isEmpty){
                currentJson["review"] = [["rating":"\(starCnt)","review":review]]
            }
            allData[self.tag] = currentJson
            helper.tableMainView.reloadRows(at: [(NSIndexPath(row: self.tag, section: 0) as IndexPath)], with: .automatic)
        }
    }
    
    
}

class reviewsHeaderCell: UITableViewCell {

    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var countryTitle: UILabel!
        @IBAction func reviewPrev(_ sender: UIButton) {
            if ATL == "travel-life" {
                globalMyLifeViewController.travelLifeRadioCheckExtention()

            }else{
                globalMyLifeViewController.localLifeRadioCheckExtention()

            }

    }
    
}

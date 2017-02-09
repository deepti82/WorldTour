//
//  AccordionViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 24/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
var globalAccordionViewController:AccordionViewController!


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
    
    var whichView = "All"
    var reviewType = "all"
    var country = ""
    var city = ""
    var category = ""
    var countryName = ""
    var cityName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        getDarkBackGround(self)
        globalAccordionViewController = self
        setTopNavigation("Reviews")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        request.getReviewByLoc(currentUser["_id"].stringValue, location: location, id: id, completion: {(request) in
            DispatchQueue.main.async {
                self.allData = []
                self.allData.append(self.getHeaderJSON())
                
                for post in request["data"].array! {
                    self.allData.append(post)
                }
                print("in the api load \(self.allData)")
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
        request.getReview(currentUser["_id"].stringValue, country: country, city: city, category: category, pageNumber: pageno, completion: {(request) in
            DispatchQueue.main.async {
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
        reviewType = type
        request.getMyLifeReview(currentUser["_id"].stringValue, pageNumber: pageno, type: type, completion: {(request) in
            DispatchQueue.main.async {
                if pageno == 1 {
                    self.allData = request["data"].array!
                }else{
                    for post in request["data"].array! {
                        self.allData.append(post)
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch reviewType {
        case "all":
            let cell = tableView.dequeueReusableCell(withIdentifier: "allReviewsCell") as! allReviewsMLTableViewCell
            cell.calendarLabel.text = String(format: "%C", faicon["calendar"]!)
            cell.clockLabel.text = String(format: "%C", faicon["clock"]!)
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
            
            return 125

        }
            
        else if reviewType == "reviewby" {
            if indexPath.row == 0 {
                return 45
            }else{
                return 125
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
    
    
}

class reviewsHeaderCell: UITableViewCell {
    
    @IBOutlet weak var countryTitle: UILabel!
    
}

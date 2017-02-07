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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGround(self)
        globalAccordionViewController = self
        setTopNavigation("Reviews")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
//        print("labels: \(labels[indexPath.item])")
//        print("label index: \(labels.endIndex)")
        
        switch reviewType {
        case "all":
            let cell = tableView.dequeueReusableCell(withIdentifier: "allReviewsCell") as! allReviewsMLTableViewCell
            cell.calendarLabel.text = String(format: "%C", faicon["calendar"]!)
            cell.clockLabel.text = String(format: "%C", faicon["clock"]!)
            return cell
        default:
            break
        }
        
        if whichView == "Reviews LL" || whichView == "Reviews TL" {
            
            print("into if level 1")
            
            if labels[(indexPath as NSIndexPath).row] == "header" {
                
                print("into if level 2")
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! reviewsHeaderCell
                return cell
                
            }
        }
        
        if(labels[(indexPath as NSIndexPath).item] == "childCells") {
            
            if (indexPath as NSIndexPath).row % 2 == 0 {
                
                print("into if level 3")
                let cell = tableView.dequeueReusableCell(withIdentifier: "childCell") as! cityExploreTableViewCell
                cell.calendarLabel.text = String(format: "%C", faicon["calendar"]!)
                cell.clockLabel.text = String(format: "%C", faicon["clock"]!)
                return cell
                
            }
            
            else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "allReviewsCell") as! allReviewsMLTableViewCell
                cell.calendarLabel.text = String(format: "%C", faicon["calendar"]!)
                cell.clockLabel.text = String(format: "%C", faicon["clock"]!)
                return cell
                
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! cityLabelTableViewCell
        cell.nameLabel.text = labels[(indexPath as NSIndexPath).item]
        if (isExpanded == true && selectedIndex == (indexPath as NSIndexPath).item) {
            cell.buttonLabel.setTitle("-", for: UIControlState())
        }
        else {
            cell.buttonLabel.setTitle("+", for: UIControlState())
        }
        if whichView == "Reviews LL" {
            cell.seperatorView.backgroundColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (isExpanded == true) {
            if(selectedIndex == (indexPath as NSIndexPath).item) {
                
                isExpanded = false
                print("in if statement 1")
                expandParent(isExpanded, index: selectedIndex)
                
            }
            
            else {
                let prevIndex = selectedIndex
                expandParent(false, index: selectedIndex)
                isExpanded = true
                if(prevIndex! < (indexPath as NSIndexPath).item) {
                    selectedIndex = (indexPath as NSIndexPath).item - childCells
                    print("in if statement 2")
                } else {
                    selectedIndex = (indexPath as NSIndexPath).item
                    print("in if statement 4")
                }
                
                expandParent(isExpanded, index: selectedIndex)
                
            }
            
            
        }
            
        else if whichView == "All" {
            
            
        }
        
        else {
                isExpanded = true
                selectedIndex = (indexPath as NSIndexPath).item
                print("in if statement 3")
                expandParent(isExpanded, index: (indexPath as NSIndexPath).item)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(labels[(indexPath as NSIndexPath).item] == "childCells") {

            if (indexPath as NSIndexPath).row % 2 == 0 {
                
                return 175
                
            }
                
            else {
                
                return 125
                
            }
        }
        
        else if reviewType == "all" {
            
            return 125
        }
        
        else if (reviewType == "Reviews TL" || reviewType == "Reviews LL") && labels[(indexPath as NSIndexPath).row] == "header" {
            
            return 50
        }
        
        return 45
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allData.count
        
    }
    
    func expandParent(_ isExpanded: Bool, index: Int) -> Void {
        
        if(isExpanded == true) {
            
            switch index {
            case 0:
                childCells = 1
                for j in 0 ..< childCells {
                    labels.insert("childCells", at: index + 1 + j)
                }
                accordionTableView.reloadData()
                break
            
            case 1:
                childCells = 2
                for j in 0 ..< childCells {
                    labels.insert("childCells", at: index + 1 + j)
                }
                accordionTableView.reloadData()
                break
                
            case 2:
                childCells = 3
                for j in 0 ..< childCells {
                    labels.insert("childCells", at: index + 1 + j)
                }
                accordionTableView.reloadData()
                break
                
            case 3:
                childCells = 4
                for j in 0 ..< childCells {
                    labels.insert("childCells", at: index + 1 + j)
                }
                accordionTableView.reloadData()
                break
            
            case 4:
                childCells = 5
                for j in 0 ..< childCells {
                    labels.insert("childCells", at: index + 1 + j)
                }
                accordionTableView.reloadData()
                break
            
            case 5:
                childCells = 6
                for _ in 0 ..< childCells {
                    labels.append("childCells")
                }
                accordionTableView.reloadData()
                break
                
            default:
                break
            }
            
            
        }
        
        else if(isExpanded == false) {
            
            for _ in 0 ..< childCells {
                labels.remove(at: index+1)
            }
            accordionTableView.reloadData()
            
        }
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

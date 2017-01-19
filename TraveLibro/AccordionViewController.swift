//
//  AccordionViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 24/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class AccordionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableMainView: UITableView!
    @IBOutlet weak var accordionTableView: UITableView!
    var labels = ["header", "Mumbai", "Delhi", "Chennai", "Kolkata", "Bengaluru", "Hyderabad"]
    var isExpanded = false
    var childCells = 0
    var selectedIndex: Int!
    
    var whichView = "All"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    setTopNavigation("Reviews")
//        if isEmptyProfile {
//            
//            let myLifeVC = self.parentViewController as! MyLifeViewController
//            myLifeVC.whatTab = "Reviews"
//            myLifeVC.collectionContainer.alpha = 0
//            myLifeVC.tableContainer.alpha = 0
//            myLifeVC.journeysContainerView.alpha = 1
//            myLifeVC.view.setNeedsDisplay()
//            
//        }
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
        self.customNavigationBar(left: leftButton, right: rightButton)
    }
    
    
    func goBack(_ sender:AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        print("labels: \(labels[indexPath.item])")
//        print("label index: \(labels.endIndex)")
        
        switch whichView {
        case "All":
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
        
        else if whichView == "All" {
            
            return 125
        }
        
        else if (whichView == "Reviews TL" || whichView == "Reviews LL") && labels[(indexPath as NSIndexPath).row] == "header" {
            
            return 50
        }
        
        return 45
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return labels.count
        
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

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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        print("labels: \(labels[indexPath.item])")
//        print("label index: \(labels.endIndex)")
        
        switch whichView {
        case "All":
            let cell = tableView.dequeueReusableCellWithIdentifier("allReviewsCell") as! allReviewsMLTableViewCell
            cell.calendarLabel.text = String(format: "%C", faicon["calendar"]!)
            cell.clockLabel.text = String(format: "%C", faicon["clock"]!)
            return cell
        default:
            break
        }
        
        if whichView == "Reviews LL" || whichView == "Reviews TL" {
            
            print("into if level 1")
            
            if labels[indexPath.row] == "header" {
                
                print("into if level 2")
                let cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! reviewsHeaderCell
                return cell
                
            }
        }
        
        if(labels[indexPath.item] == "childCells") {
            
            if indexPath.row % 2 == 0 {
                
                print("into if level 3")
                let cell = tableView.dequeueReusableCellWithIdentifier("childCell") as! cityExploreTableViewCell
                cell.calendarLabel.text = String(format: "%C", faicon["calendar"]!)
                cell.clockLabel.text = String(format: "%C", faicon["clock"]!)
                return cell
                
            }
            
            else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("allReviewsCell") as! allReviewsMLTableViewCell
                cell.calendarLabel.text = String(format: "%C", faicon["calendar"]!)
                cell.clockLabel.text = String(format: "%C", faicon["clock"]!)
                return cell
                
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! cityLabelTableViewCell
        cell.nameLabel.text = labels[indexPath.item]
        if (isExpanded == true && selectedIndex == indexPath.item) {
            cell.buttonLabel.setTitle("-", forState: .Normal)
        }
        else {
            cell.buttonLabel.setTitle("+", forState: .Normal)
        }
        if whichView == "Reviews LL" {
            cell.seperatorView.backgroundColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (isExpanded == true) {
            if(selectedIndex == indexPath.item) {
                
                isExpanded = false
                print("in if statement 1")
                expandParent(isExpanded, index: selectedIndex)
                
            }
            
            else {
                let prevIndex = selectedIndex
                expandParent(false, index: selectedIndex)
                isExpanded = true
                if(prevIndex < indexPath.item) {
                    selectedIndex = indexPath.item - childCells
                    print("in if statement 2")
                } else {
                    selectedIndex = indexPath.item
                    print("in if statement 4")
                }
                
                expandParent(isExpanded, index: selectedIndex)
                
            }
            
            
        }
            
        else if whichView == "All" {
            
            
        }
        
        else {
                isExpanded = true
                selectedIndex = indexPath.item
                print("in if statement 3")
                expandParent(isExpanded, index: indexPath.item)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(labels[indexPath.item] == "childCells") {

            if indexPath.row % 2 == 0 {
                
                return 175
                
            }
                
            else {
                
                return 125
                
            }
        }
        
        else if whichView == "All" {
            
            return 125
        }
        
        else if (whichView == "Reviews TL" || whichView == "Reviews LL") && labels[indexPath.row] == "header" {
            
            return 50
        }
        
        return 45
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return labels.count
        
    }
    
    func expandParent(isExpanded: Bool, index: Int) -> Void {
        
        if(isExpanded == true) {
            
            switch index {
            case 0:
                childCells = 1
                for j in 0 ..< childCells {
                    labels.insert("childCells", atIndex: index + 1 + j)
                }
                accordionTableView.reloadData()
                break
            
            case 1:
                childCells = 2
                for j in 0 ..< childCells {
                    labels.insert("childCells", atIndex: index + 1 + j)
                }
                accordionTableView.reloadData()
                break
                
            case 2:
                childCells = 3
                for j in 0 ..< childCells {
                    labels.insert("childCells", atIndex: index + 1 + j)
                }
                accordionTableView.reloadData()
                break
                
            case 3:
                childCells = 4
                for j in 0 ..< childCells {
                    labels.insert("childCells", atIndex: index + 1 + j)
                }
                accordionTableView.reloadData()
                break
            
            case 4:
                childCells = 5
                for j in 0 ..< childCells {
                    labels.insert("childCells", atIndex: index + 1 + j)
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
                labels.removeAtIndex(index+1)
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

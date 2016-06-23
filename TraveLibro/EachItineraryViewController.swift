//
//  EachItineraryViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 11/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class EachItineraryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var prevSelectedTab: UIButton?
    
    
    @IBOutlet weak var tabSeven: UIButton!
    @IBOutlet weak var tabSix: UIButton!
    @IBOutlet weak var tabFive: UIButton!
    @IBOutlet weak var TabThree: UIButton!
    @IBOutlet weak var tabTwo: UIButton!
    @IBOutlet weak var tabOne: UIButton!
    @IBOutlet weak var theTableView: UITableView!
    @IBAction func TapPhotos(sender: AnyObject) {
        
        let modalContent = self.storyboard?.instantiateViewControllerWithIdentifier("MomentsVC") as! MomentsEachViewController
        
        modalContent.modalPresentationStyle = .FullScreen
        let modal = modalContent.popoverPresentationController
        
        self.presentViewController(modalContent, animated: true, completion: nil)
        
        
    }
    
    @IBAction func panOnButton(sender: AnyObject) {
        
        let modalContent = self.storyboard?.instantiateViewControllerWithIdentifier("MomentsVC") as! MomentsEachViewController
        
        modalContent.modalPresentationStyle = .FullScreen
        let modal = modalContent.popoverPresentationController
        
        self.presentViewController(modalContent, animated: true, completion: nil)
        
    }

    @IBAction func tabTap(sender: UIButton) {
       
        prevSelectedTab?.backgroundColor = mainBlueColor
        sender.backgroundColor = mainOrangeColor
        prevSelectedTab = sender
        
    }
    
    var cityLabels = ["", "Mumbai", "Pune", "Nagpur", "Nashik", "Aurangabad"]
    var dayLabels = ["", "Day 1 to Day 3", "Day 3 to Day 5", "Day 5 to Day 7", "Day 8 to Day 9", "Day 9 to Day 10"]
    var isSelectedIndex: Int?
    var isExpanded = false
    let childCells = 4
    let childCellArray = ["Stayed At", "Ate At", "Must Do", "little more"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeTabs(tabSeven)
        makeTabs(tabSix)
        makeTabs(tabFive)
        makeTabs(TabThree)
        makeTabs(tabTwo)
        makeTabs(tabOne)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cityLabels.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let firstPostCell = tableView.dequeueReusableCellWithIdentifier("firstPost") as! EachItineraryPostTableViewCell
            
            let itineraryView = Itineraries(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 400))
            itineraryView.feedbackStack.removeFromSuperview()
            itineraryView.reviewStack.removeFromSuperview()
            itineraryView.likeStack.removeFromSuperview()
            itineraryView.separatorView.removeFromSuperview()
            itineraryView.options.removeFromSuperview()
            firstPostCell.myView.addSubview(itineraryView)
            firstPostCell.selectionStyle = .None
            return firstPostCell
            
        }
        
        else if cityLabels[indexPath.row] == "Stayed At" ||  cityLabels[indexPath.row] == "Ate At" || cityLabels[indexPath.row] == "Must Do" {
            
            let childCell = tableView.dequeueReusableCellWithIdentifier("childCellOne") as! ItineraryAccordionChildCellTableViewCell
//            childCell.selectionStyle = .None
            return childCell
            
        }
        
        else if cityLabels[indexPath.row] == "little more" {
            
            let childCellTwo = tableView.dequeueReusableCellWithIdentifier("childCellTwo") as! ItineraryAccordionChildCellDescriptionTableViewCell
            let sub = MoreAboutTrip(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
            let subTwo = MoreAboutTrip(frame: CGRect(x: 0, y: 300, width: self.view.frame.width, height: 300))
            childCellTwo.descriptionCell.addSubview(subTwo)
            childCellTwo.descriptionCell.addSubview(sub)
            subTwo.mainTitle.removeFromSuperview()
            childCellTwo.selectionStyle = .None
            return childCellTwo
            
        }
        
        
        let parentCell = tableView.dequeueReusableCellWithIdentifier("parentCell") as!
        ItineraryAccordionParentCellTableViewCell
        parentCell.cityName.text = cityLabels[indexPath.row]
        parentCell.dayLabel.text = dayLabels[indexPath.row]
        return parentCell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 400
            
        }
            
        else if cityLabels[indexPath.row] == "Stayed At" ||  cityLabels[indexPath.row] == "Ate At" || cityLabels[indexPath.row] == "Must Do" {
            
            return 60
        }
        
        else if cityLabels[indexPath.row] == "little more" {
            
            return 300 * 2
        }
        
        return 45
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
        if indexPath.row != 0 && cityLabels[indexPath.row] != "little more" && cityLabels[indexPath.row] != "Ate At" && cityLabels[indexPath.row] != "Stayed At" && cityLabels[indexPath.row] != "Must Do" {
            
            if (isExpanded == true) {
                if(isSelectedIndex == indexPath.row) {
                    
                    isExpanded = false
                    print("in if statement 1")
                    expandParent(isExpanded, index: isSelectedIndex!)
                    
                }
                    
                else {
                    let prevIndex = isSelectedIndex
                    expandParent(false, index: isSelectedIndex!)
                    isExpanded = true
                    if(prevIndex < indexPath.row) {
                        isSelectedIndex = indexPath.row - childCells
                        print("in if statement 2")
                    } else {
                        isSelectedIndex = indexPath.row
                        print("in if statement 4")
                    }
                    
                    expandParent(isExpanded, index: isSelectedIndex!)
                    
                }
                
                
            }
                
        else {
            isExpanded = true
            isSelectedIndex = indexPath.item
            print("in if statement 3")
            expandParent(isExpanded, index: indexPath.item)
        }
            
        }
        
        if cityLabels[indexPath.row] == "Ate At" || cityLabels[indexPath.row] == "Stayed At" || cityLabels[indexPath.row] == "Must Do" {
            
            let exploreHotelsVC = storyboard?.instantiateViewControllerWithIdentifier("ExploreHotelsVC") as! ExploreHotelsViewController
            self.navigationController?.pushViewController(exploreHotelsVC, animated: true)
            
            
        }
        
        
    }
    
    func expandParent(isExpanded: Bool, index: Int) -> Void {
        
        if(isExpanded == true) {
            
            for j in 0 ..< childCells {
                cityLabels.insert(childCellArray[j], atIndex: index + 1 + j)
                dayLabels.insert(childCellArray[j], atIndex: index + 1 + j)
            }
            print("city labels: \(cityLabels)")
            print("day labels: \(dayLabels)")
            theTableView.reloadData()
            
            
        }
            
        else if(isExpanded == false) {
            
            for _ in 0 ..< childCells {
                if index ==  cityLabels.count {
                    
                    cityLabels.removeAtIndex(index)
                    dayLabels.removeAtIndex(index)
                }
                
                else {
                    
                    cityLabels.removeAtIndex(index+1)
                    dayLabels.removeAtIndex(index+1)
                }
                
            }
            theTableView.reloadData()
            
        }
    }
    

    func makeTabs(myTab: UIButton) -> Void {
        
        myTab.layer.cornerRadius = 7
        self.view.bringSubviewToFront(myTab)
        
    }

}


class ItineraryAccordionParentCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var buttonLabel: UIButton!
    
    @IBAction func buttonTap(sender: AnyObject) {
    
        sender.setTitle("-", forState: .Selected)
        
    }
    
}

class ItineraryAccordionChildCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleIcon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UILabel!
    
    
}

class ItineraryAccordionChildCellDescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionCell: UIView!
    
    
}

class EachItineraryPostTableViewCell : UITableViewCell {
    
    @IBOutlet weak var myView: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print("In the cell init function \(myView)")
        
        
    }
    
}
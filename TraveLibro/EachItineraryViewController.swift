//
//  EachItineraryViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 11/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class EachItineraryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var prevSelectedTab: UIButton?
    
    
    @IBOutlet weak var tabSeven: UIButton!
    @IBOutlet weak var tabSix: UIButton!
    @IBOutlet weak var tabFive: UIButton!
    @IBOutlet weak var TabThree: UIButton!
    @IBOutlet weak var tabTwo: UIButton!
    @IBOutlet weak var tabOne: UIButton!
    @IBOutlet weak var theTableView: UITableView!
    
    @IBAction func TapPhotos(_ sender: AnyObject) {
        
        let modalContent = self.storyboard?.instantiateViewController(withIdentifier: "itineraryPhotos") as! EachItineraryPhotosViewController
        
        modalContent.modalPresentationStyle = .fullScreen
        _ = modalContent.popoverPresentationController
        
        self.present(modalContent, animated: true, completion: nil)
        
        
    }
    
    @IBAction func panOnButton(_ sender: AnyObject) {
        
        let modalContent = self.storyboard?.instantiateViewController(withIdentifier: "MomentsVC") as! MomentsEachViewController
        
        modalContent.modalPresentationStyle = .fullScreen
        _ = modalContent.popoverPresentationController
        
        self.present(modalContent, animated: true, completion: nil)
        
    }

    @IBAction func tabTap(_ sender: UIButton) {
       
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
        
        tabSeven.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cityLabels.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).row == 0 {
            
            let firstPostCell = tableView.dequeueReusableCell(withIdentifier: "firstPost") as! EachItineraryPostTableViewCell
            
            let itineraryView = Itineraries(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 400))
            itineraryView.feedbackStack.removeFromSuperview()
            itineraryView.reviewStack.removeFromSuperview()
            itineraryView.likeStack.removeFromSuperview()
            itineraryView.separatorView.removeFromSuperview()
            itineraryView.options.removeFromSuperview()
            firstPostCell.myView.addSubview(itineraryView)
            firstPostCell.selectionStyle = .none
            return firstPostCell
            
        }
        
        else if cityLabels[(indexPath as NSIndexPath).row] == "Stayed At" ||  cityLabels[(indexPath as NSIndexPath).row] == "Ate At" || cityLabels[(indexPath as NSIndexPath).row] == "Must Do" {
            
            let childCell = tableView.dequeueReusableCell(withIdentifier: "childCellOne") as! ItineraryAccordionChildCellTableViewCell
            switch cityLabels[(indexPath as NSIndexPath).row] {
            case "Stayed At":
                childCell.titleIcon.image = UIImage(named: "stayed_at")
                childCell.title.text = "Stayed At"
                childCell.value.text = "Astoria Hotel"
                break
                
            case "Ate At":
                childCell.titleIcon.image = UIImage(named: "ate_at")
                childCell.title.text = "Ate At"
                childCell.value.text = "Gulmarg Shalimar | Jewel of India | Moshes Pizza"
                break
                
            case "Must Do":
                childCell.titleIcon.image = UIImage(named: "must_do")
                childCell.title.text = "Must Do's"
                childCell.value.text = "1. Marine Drive 2. Gatewat of India 3. The Taj Mahal"
                break
                
            default:
                break
            }
            return childCell
            
        }
        
        else if cityLabels[(indexPath as NSIndexPath).row] == "little more" {
            
            let childCellTwo = tableView.dequeueReusableCell(withIdentifier: "childCellTwo") as! ItineraryAccordionChildCellDescriptionTableViewCell
            let sub = MoreAboutTrip(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
            let subTwo = MoreAboutTrip(frame: CGRect(x: 0, y: 300, width: self.view.frame.width, height: 300))
            childCellTwo.descriptionCell.addSubview(subTwo)
            childCellTwo.descriptionCell.addSubview(sub)
            subTwo.mainTitle.removeFromSuperview()
            childCellTwo.selectionStyle = .none
            return childCellTwo
            
        }
        
        
        let parentCell = tableView.dequeueReusableCell(withIdentifier: "parentCell") as!
        ItineraryAccordionParentCellTableViewCell
        parentCell.cityName.text = cityLabels[(indexPath as NSIndexPath).row]
        parentCell.dayLabel.text = dayLabels[(indexPath as NSIndexPath).row]
        return parentCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath as NSIndexPath).row == 0 {
            
            return 400
            
        }
            
        else if cityLabels[(indexPath as NSIndexPath).row] == "Stayed At" ||  cityLabels[(indexPath as NSIndexPath).row] == "Ate At" || cityLabels[(indexPath as NSIndexPath).row] == "Must Do" {
            
            return 60
        }
        
        else if cityLabels[(indexPath as NSIndexPath).row] == "little more" {
            
            return 300 * 2
        }
        
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        if (indexPath as NSIndexPath).row != 0 && cityLabels[(indexPath as NSIndexPath).row] != "little more" && cityLabels[(indexPath as NSIndexPath).row] != "Ate At" && cityLabels[(indexPath as NSIndexPath).row] != "Stayed At" && cityLabels[(indexPath as NSIndexPath).row] != "Must Do" {
            
            if (isExpanded == true) {
                if(isSelectedIndex == (indexPath as NSIndexPath).row) {
                    
                    isExpanded = false
                    print("in if statement 1")
                    expandParent(isExpanded, index: isSelectedIndex!)
                    
                }
                    
                else {
                    let prevIndex = isSelectedIndex
                    expandParent(false, index: isSelectedIndex!)
                    isExpanded = true
                    if(prevIndex < (indexPath as NSIndexPath).row) {
                        isSelectedIndex = (indexPath as NSIndexPath).row - childCells
                        print("in if statement 2")
                    } else {
                        isSelectedIndex = (indexPath as NSIndexPath).row
                        print("in if statement 4")
                    }
                    
                    expandParent(isExpanded, index: isSelectedIndex!)
                    
                }
                
                
            }
                
        else {
            isExpanded = true
            isSelectedIndex = (indexPath as NSIndexPath).item
            print("in if statement 3")
            expandParent(isExpanded, index: (indexPath as NSIndexPath).item)
        }
            
        }
        
        if cityLabels[(indexPath as NSIndexPath).row] == "Ate At" || cityLabels[(indexPath as NSIndexPath).row] == "Stayed At" || cityLabels[(indexPath as NSIndexPath).row] == "Must Do" {
            
            let exploreHotelsVC = storyboard?.instantiateViewController(withIdentifier: "eachCityPagerStripVC") as! EachCityPagerViewController
            exploreHotelsVC.whichView = cityLabels[(indexPath as NSIndexPath).row]
            self.navigationController?.pushViewController(exploreHotelsVC, animated: true)
            
        }
        
        
    }
    
    func expandParent(_ isExpanded: Bool, index: Int) -> Void {
        
        if(isExpanded == true) {
            
            for j in 0 ..< childCells {
                cityLabels.insert(childCellArray[j], at: index + 1 + j)
                dayLabels.insert(childCellArray[j], at: index + 1 + j)
            }
            print("city labels: \(cityLabels)")
            print("day labels: \(dayLabels)")
            theTableView.reloadData()
            
            
        }
            
        else if(isExpanded == false) {
            
            for _ in 0 ..< childCells {
                if index ==  cityLabels.count {
                    
                    cityLabels.remove(at: index)
                    dayLabels.remove(at: index)
                }
                
                else {
                    
                    cityLabels.remove(at: index+1)
                    dayLabels.remove(at: index+1)
                }
                
            }
            theTableView.reloadData()
            
        }
    }
    

    func makeTabs(_ myTab: UIButton) -> Void {
        
        myTab.layer.cornerRadius = 7
        self.view.bringSubview(toFront: myTab)
        
    }

}


class ItineraryAccordionParentCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var buttonLabel: UIButton!
    
    @IBAction func buttonTap(_ sender: AnyObject) {
    
        sender.setTitle("-", for: .selected)
        
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

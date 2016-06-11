//
//  EachItineraryViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 11/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class EachItineraryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tabSeven: UIButton!
    @IBOutlet weak var tabSix: UIButton!
    @IBOutlet weak var tabFive: UIButton!
    @IBOutlet weak var tabFour: UIButton!
    @IBOutlet weak var TabThree: UIButton!
    @IBOutlet weak var tabTwo: UIButton!
    @IBOutlet weak var tabOne: UIButton!
    
    let cityLabels = ["", "Mumbai", "", "", "Pune", "Nagpur", "Nashik", "Aurangabad"]
    let dayLabels = ["", "Day 1 to Day 3", "", "", "Day 3 to Day 5", "Day 5 to Day 7", "Day 8 to Day 9", "Day 9 to Day 10"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeTabs(tabSeven)
        makeTabs(tabSix)
        makeTabs(tabFive)
        makeTabs(tabFour)
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
            
            return firstPostCell
            
        }
        
        else if indexPath.row == 2 {
            
            let childCell = tableView.dequeueReusableCellWithIdentifier("childCellOne") as! ItineraryAccordionChildCellTableViewCell
            return childCell
            
        }
        
        else if indexPath.row == 3 {
            
            let childCellTwo = tableView.dequeueReusableCellWithIdentifier("childCellTwo") as! ItineraryAccordionChildCellDescriptionTableViewCell
            let sub = MoreAboutTrip(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 500))
            childCellTwo.addSubview(sub)
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
            
        else if indexPath.row == 2 {
            
            return 60
        }
        
        else if indexPath.row == 3 {
            
            return 500
        }
        
        return 45
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
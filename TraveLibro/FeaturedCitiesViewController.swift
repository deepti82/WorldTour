//
//  FeaturedCitiesViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 09/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class FeaturedCitiesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var navigationCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    var isSelected: NSIndexPath?
    var flag: Bool?
    var gradientFlag: [Int] = []
    var cityNames = ["Agra", "", "Amritsar", ""]
    let navigationNames = ["Featured Cities", "Must Do's", "Itineraries", "Journeys", "Popular Agents"]
    var pass = 0
//    let tablePictures = ["", ""]
    
    var whichView = "noView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flag = true
        let allSubviews = containerView.subviews
        print("All subviews: \(self.view.subviews)")
        
        let toSelectItinerary = UITapGestureRecognizer(target: self, action: #selector(self.itineraryTap(_:)))
        
        if pass > 0 {

            for eachSubview in allSubviews {

                if !(eachSubview is UICollectionView) {

                    print("Each subview: \(eachSubview)")
                    eachSubview.removeFromSuperview()

                }
                
            }
        }
        
        
        switch whichView {
        case "Must Do View":
            cityNames = ["#1 Shree SiddhiVinayak", "", "#2 Golden Temple", ""]
            contentTableView.reloadData()
        case "Itinerary View":
            if (contentTableView != nil) {
                
                contentTableView.hidden = true
                
            }
            let itineraryView = Itineraries(frame: CGRect(x: 0, y: 10, width: self.view.frame.width, height: 500))
            containerView.addSubview(itineraryView)
//            toSelectItinerary.delegate = itineraryView.toTapView
            itineraryView.toTapView.addGestureRecognizer(toSelectItinerary)
            
        case "Journey View":
            if (contentTableView != nil) {
                
                contentTableView.hidden = true
                
            }
            let popJourneyView = PopularJourneyView(frame: CGRect(x: 0, y: 10, width: self.view.frame.width, height: 600))
            containerView.addSubview(popJourneyView)
        
        case "Popular Agents View":
            if (contentTableView != nil) {
                
                contentTableView.hidden = true
                
            }
            let popAgentsView = PopularAgents(frame: CGRect(x: 0, y: 10, width: self.view.frame.width, height: 250))
            containerView.addSubview(popAgentsView)
            
        default: break
            
            
        }
        
        
//
//        let filterItineraries = FilterItineraries(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//        filterItineraries.layer.zPosition = 100
//        self.view.addSubview(filterItineraries)
        
//        let agentView = PopularAgents(frame: CGRect(x: 0, y: 80, width: self.view.frame.width, height: 250))
//        self.view.addSubview(agentView)
        
        for _ in 0 ..< cityNames.count {
            
            gradientFlag.append(0)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cityNames.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! FeaturedCitiesTableViewCell
            cell.cityLabel.text = cityNames[indexPath.item]
            
            if gradientFlag[indexPath.row] == 0 {
             
                let gradient = CAGradientLayer()
                
                let blackColour = UIColor.blackColor().colorWithAlphaComponent(0.8).CGColor as CGColorRef
                let transparent = UIColor.clearColor().CGColor as CGColorRef
                
                gradient.frame = cell.cityLabelView.bounds
                gradient.frame.size.width = cell.cityLabelView.frame.width + 100
                gradient.colors = [transparent, blackColour]
                gradient.locations = [0.0, 0.75]
                
                cell.cityLabelView.layer.addSublayer(gradient)
                
                gradientFlag[indexPath.row] = 1
                
            }
            
            cell.cityLabel.layer.zPosition = 10
            
            return cell
            
            
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("noViewCell") as! NoViewTableViewCell
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return navigationNames.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! FeaturedCitiesCollectionViewCell
        cell.navBarTitle.text = navigationNames[indexPath.item]
        
        print("In loading cell: \(indexPath.item), \(navigationNames[indexPath.item])")
//        print("isSelected: \(isSelected)")
        if indexPath.item == 0  && flag == true {
            
            isSelected = indexPath
            cell.navBarUnderline.backgroundColor = mainOrangeColor
            flag = false
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row % 2 == 0 {
            
            return 300
        }
        
        return 3
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
//        print("index path: \(indexPath.item)")
//        print("isSelected: \(isSelected)")
        
//        isSelected = indexPath.item
//        flag = false
        
//        if (isSelected != indexPath) {
//            
//            print("isSelected: \(isSelected)")
//            
//            let prevCell = collectionView.cellForItemAtIndexPath(isSelected!) as! FeaturedCitiesCollectionViewCell
//            prevCell.navBarUnderline.backgroundColor = UIColor.whiteColor()
//        }
        
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FeaturedCitiesCollectionViewCell
        cell.navBarUnderline.backgroundColor = mainOrangeColor
        
        switch indexPath.item {
        case 1: whichView = "Must Do View"
                pass += 1
                self.viewDidLoad()
            
        case 2:
            if contentTableView != nil {
                contentTableView.removeFromSuperview()
            }
            whichView = "Itinerary View"
            pass += 1
            self.viewDidLoad()
            
        case 3:
            if contentTableView != nil {
                contentTableView.removeFromSuperview()
            }
            whichView = "Journey View"
            pass += 1
            self.viewDidLoad()
            
        case 4:
            if contentTableView != nil {
                contentTableView.removeFromSuperview()
            }
            whichView = "Popular Agents View"
            pass += 1
            self.viewDidLoad()
        
        default: break
        }
        
        self.viewDidLoad()
//        for i in Range(0 ... navigationNames.count) {
//            
//            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FeaturedCitiesCollectionViewCell
//            
//        }
        
//        tableView(contentTableView, cellForRowAtIndexPath: contentTableView.indexPathForSelectedRow!)
//        switch indexPath.item {
//        case 1:
//            cityNames = ["#1 Shree Siddhivinayak", "", "#2 Golden Temple", ""]
////            tableView(contentTableView, cellForRowAtIndexPath: contentTableView.indexPathForSelectedRow!)
//            break
//            
//        default:
//            break
//        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FeaturedCitiesCollectionViewCell
        cell.navBarUnderline.backgroundColor = UIColor.whiteColor()
        self.viewDidLoad()
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidAppear(animated: Bool) {
        
        navigationCollectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: true, scrollPosition: .None)
//        navigationCollectionView.reloadItemsAtIndexPaths(NSIndexPath(forItem: 0, inSection: 0))
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if whichView == "Must Do View" {
            
            let descriptionVC = storyboard?.instantiateViewControllerWithIdentifier("EachMustDoViewController") as! TrialViewController
            self.navigationController?.pushViewController(descriptionVC, animated: true)
            
        }
    }
    
    func itineraryTap (sender: UITapGestureRecognizer? = nil) {
        
        let eachItineraryController = storyboard!.instantiateViewControllerWithIdentifier("EachItineraryViewController") as! EachItineraryViewController
        self.navigationController?.pushViewController(eachItineraryController, animated: true)
        
    }
    
}

class FeaturedCitiesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var cityLabelView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    
    
}

class FeaturedCitiesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var navBarTitle: UILabel!
    @IBOutlet weak var navBarUnderline: UIView!
    
}
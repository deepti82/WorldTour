//
//  FeaturedCitiesViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 09/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class FeaturedCitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    var isSelected: NSIndexPath?
    var flag: Bool?
    var gradientFlag: [Int] = []
    var cityNames = ["Agra", "", "Amritsar", ""]
    var cityImages = ["taj_mahal", "", "amritsar", ""]
    let navigationNames = ["Featured Cities", "Must Do's", "Itineraries", "Journeys", "Popular Agents"]
    var pass = 0
//    let tablePictures = ["", ""]
    
    var whichView = "noView"
//    var itemInfo = IndicatorInfo(title: "View")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flag = true
        let allSubviews = containerView.subviews
//        print("All subviews: \(self.view.subviews)")
        
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
        case "MD":
            cityNames = ["#1 Shree Siddhivinayak", "", "#2 Golden Temple", ""]
            cityImages = ["siddhivinayak", "", "amritsar", ""]
            contentTableView.reloadData()
            containerView.alpha = 0
        case "It":
            if (contentTableView != nil) {
                
                contentTableView.hidden = true
                
            }
            let itineraryView = Itineraries(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 500))
            containerView.addSubview(itineraryView)
//            toSelectItinerary.delegate = itineraryView.toTapView
            itineraryView.toTapView.addGestureRecognizer(toSelectItinerary)
            
            let filter = UIButton(frame: CGRect(x: containerView.frame.width - 5, y: containerView.frame.height - 50, width: 50, height: 50))
            filter.setImage(UIImage(named: "filter_icon"), forState: .Normal)
            filter.layer.zPosition = 1000
            filter.addTarget(self, action: #selector(FeaturedCitiesViewController.showItineraryFilters(_:)), forControlEvents: .TouchUpInside)
            containerView.addSubview(filter)
            
        case "Jo":
            if (contentTableView != nil) {
                
                contentTableView.hidden = true
                
            }
            let popJourneyView = PopularJourneyView(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 550))
            containerView.addSubview(popJourneyView)
        
        case "Pop":
            if (contentTableView != nil) {
                
                contentTableView.hidden = true
                
            }
            let popAgentsView = PopularAgents(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 250))
            containerView.addSubview(popAgentsView)
            
        default:
            containerView.alpha = 0
            break
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
    
//    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
//        
////        switch whichView {
////        case "Must Do View":
////            return IndicatorInfo(title: "Must Do's")
////        case "Itinerary View":
////            return IndicatorInfo(title: "Itineraries")
////            
////        case "Journey View":
////            return IndicatorInfo(title: "Journeys")
////            
////        case "Popular Agents View":
////            return IndicatorInfo(title: "Popular Agents")
////            
////        default: break
////        }
//        
//        return itemInfo
//    }
    
    var filterView: FilterItineraries!
    var scroll: UIScrollView!
    
    func showItineraryFilters(sender: UIButton) {
        
        scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        scroll.layer.zPosition = 1001
        self.view.addSubview(scroll)
        
        filterView = FilterItineraries(frame: CGRect(x: 0, y: 0, width: scroll.frame.width, height: 835)) 
        filterView.layer.opacity = 0.0
        scroll.addSubview(filterView)
        
        scroll.contentSize.height = filterView.frame.height
        
        filterView.doneButton.addTarget(self, action: #selector(FeaturedCitiesViewController.filtersApply(_:)), forControlEvents: .TouchUpInside)
        
        filterView.animation.makeOpacity(1.0).animate(0.5)
        
        for button in filterView.placeButtons {
            
            button.addTarget(self, action: #selector(FeaturedCitiesViewController.checkPlace(_:)), forControlEvents: .TouchUpInside)
            
        }
        
        for button in filterView.stackButtons {
            
            button.addTarget(self, action: #selector(FeaturedCitiesViewController.checkTypes(_:)), forControlEvents: .TouchUpInside)
            
        }
        
        for button in filterView.categoryButtons {
            
            button.addTarget(self, action: #selector(FeaturedCitiesViewController.checkCategories(_:)), forControlEvents: .TouchUpInside)
            
        }
    }
    
    func filtersApply(sender: UIButton) {
        
//        let subview = self.view.subviews.last
//        
//        let subsubview = subview?.subviews.last
        print("In done button target")
        filterView.animation.makeOpacity(0.0).animate(0.5)
        scroll.animation.makeOpacity(0.0).animate(0.5)
        
    }
    
    func checkPlace(sender: UIButton) {
        
        let subviews = sender.titleLabel?.subviews
        
        if sender.tag == 0 {
            
            let checked = UIImageView(frame: CGRect(x: -25, y: 0, width: 20, height: 20))
            checked.image = UIImage(named: "checkbox_fill")
            sender.titleLabel?.addSubview(checked)
            checked.tag = 2
            sender.tag = 1
            
        }
        
        for subview in subviews! {
            
            if subview.tag == 1 && !sender.selected {
                
                subview.hidden = true
                sender.selected = true
                
            }
            
            else if subview.tag == 1 && sender.selected {
                
                sender.selected = false
                subview.hidden = false
                
            }
            
            if subview.tag == 2 && sender.selected {
                
                subview.hidden = false
                
            }
            
            else if subview.tag == 2 && !sender.selected {
                
                subview.hidden = true
                
            }
            
        }
        
        
    }
    
    func checkTypes(sender: UIButton) {
        
        if sender.tag == 0 {
            
            sender.setBackgroundImage(UIImage(named: "orangebox"), forState: .Normal)
            sender.tag = 1
            
        }
        
        else {
         
            sender.setBackgroundImage(UIImage(named: "bluebox"), forState: .Normal)
            sender.tag = 0
            
        }
        
    }
    
    
    func checkCategories (sender: UIButton) {
        
        if sender.tag == 0 {
            
            sender.backgroundColor = UIColor(red: 252/255, green: 80/255, blue: 71/255, alpha: 1)
            sender.tag = 1
            
        }
            
        else {
            
            sender.backgroundColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
            sender.tag = 0
            
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
            cell.cityLabel.text = cityNames[indexPath.row]
            cell.cityImage.image = UIImage(named: cityImages[indexPath.row])
            
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
    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        return navigationNames.count
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! FeaturedCitiesCollectionViewCell
//        cell.navBarTitle.text = navigationNames[indexPath.item]
//        
//        print("In loading cell: \(indexPath.item), \(navigationNames[indexPath.item])")
////        print("isSelected: \(isSelected)")
//        if indexPath.item == 0  && flag == true {
//            
//            isSelected = indexPath
//            cell.navBarUnderline.backgroundColor = mainOrangeColor
//            flag = false
//        }
//        
//        return cell
//        
//    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row % 2 == 0 {
            
            return 300
        }
        
        return 3
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
        
    }
    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        
////        print("index path: \(indexPath.item)")
////        print("isSelected: \(isSelected)")
//        
////        isSelected = indexPath.item
////        flag = false
//        
////        if (isSelected != indexPath) {
////            
////            print("isSelected: \(isSelected)")
////            
////            let prevCell = collectionView.cellForItemAtIndexPath(isSelected!) as! FeaturedCitiesCollectionViewCell
////            prevCell.navBarUnderline.backgroundColor = UIColor.whiteColor()
////        }
//        
//        
////        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FeaturedCitiesCollectionViewCell
////        cell.navBarUnderline.backgroundColor = mainOrangeColor
//        
//        switch indexPath.item {
//        case 1: whichView = "Must Do View"
//                pass += 1
//                self.viewDidLoad()
//            
//        case 2:
//            if contentTableView != nil {
//                contentTableView.removeFromSuperview()
//            }
//            whichView = "Itinerary View"
//            pass += 1
//            self.viewDidLoad()
//            
//        case 3:
//            if contentTableView != nil {
//                contentTableView.removeFromSuperview()
//            }
//            whichView = "Journey View"
//            pass += 1
//            self.viewDidLoad()
//            
//        case 4:
//            if contentTableView != nil {
//                contentTableView.removeFromSuperview()
//            }
//            whichView = "Popular Agents View"
//            pass += 1
//            self.viewDidLoad()
//        
//        default: break
//        }
//        
////        self.viewDidLoad()
////        for i in Range(0 ... navigationNames.count) {
////            
////            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FeaturedCitiesCollectionViewCell
////            
////        }
//        
////        tableView(contentTableView, cellForRowAtIndexPath: contentTableView.indexPathForSelectedRow!)
////        switch indexPath.item {
////        case 1:
////            cityNames = ["#1 Shree Siddhivinayak", "", "#2 Golden Temple", ""]
//////            tableView(contentTableView, cellForRowAtIndexPath: contentTableView.indexPathForSelectedRow!)
////            break
////            
////        default:
////            break
////        }
//        
//    }
    
//    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
//        
//        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FeaturedCitiesCollectionViewCell
//        cell.navBarUnderline.backgroundColor = UIColor.whiteColor()
//        self.viewDidLoad()
//        
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidAppear(animated: Bool) {
        
//        navigationCollectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: true, scrollPosition: .None)
//        navigationCollectionView.reloadItemsAtIndexPaths(NSIndexPath(forItem: 0, inSection: 0))
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("Selected table")
            
        let descriptionVC = storyboard?.instantiateViewControllerWithIdentifier("EachMustDoViewController") as! TrialViewController
        self.navigationController?.pushViewController(descriptionVC, animated: true)
        
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
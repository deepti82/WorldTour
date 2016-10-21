//
//  FeaturedCitiesNewViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 14/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class FeaturedCitiesNewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var whichView: String!
    var isGradientOne: [Bool] = []
    var isGradientTwo: [Bool] = []
    let cities = ["Agra", "Amritsar"]
    let places = ["Shree Siddhivinayak", "Golden Temple"]
//    var itemInfo = IndicatorInfo(title: "View")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        
        for _ in 0 ..< cities.count {
            
            isGradientOne.append(false)
        }
        
        for _ in 0 ..< places.count {
            
            isGradientTwo.append(false)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch whichView {
        case "FC":
            let cell = tableView.dequeueReusableCell(withIdentifier: "fcCell") as!
            FeaturedCitiesNewTableViewCell
            cell.CellLabel.text = cities[(indexPath as NSIndexPath).row]
            return cell
        case "MD":
            let cell = tableView.dequeueReusableCell(withIdentifier: "fcCell") as!
            FeaturedCitiesNewTableViewCell
            cell.CellLabel.text = places[(indexPath as NSIndexPath).row]
            return cell
        case "It":
            let cell = tableView.dequeueReusableCell(withIdentifier: "itinerariesETC") as!
            ItinerariesETCTableViewCell
            let itinerary = Itineraries(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 450))
            cell.addSubview(itinerary)
            return cell
        case "Jo":
            let cell = tableView.dequeueReusableCell(withIdentifier: "itinerariesETC") as!
            ItinerariesETCTableViewCell
            let pjo = PopularJourneyView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 550))
            cell.addSubview(pjo)
            return cell
        default:
            break
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itinerariesETC") as!
        ItinerariesETCTableViewCell
        let pa = PopularAgents(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
        cell.addSubview(pa)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch whichView {
        case "FC":
           return 400
        case "MD":
            return 400
        case "It":
            return 450
        case "Jo":
            return 500
        default:
            break
        }
        
        return 250
        
    }
    
//    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
//        
//        return itemInfo
//    }
    

}

class FeaturedCitiesNewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var CellLabel: UILabel!
    
}

class ItinerariesETCTableViewCell: UITableViewCell {
    
    
    
}

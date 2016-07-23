//
//  FeaturedCitiesNewTwoViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class FeaturedCitiesNewTwoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var whichView: String!
    let cityNames = ["Agra", "Amritsar"]
    let cityImages = ["taj_mahal", "amritsar"]
    let placesNames = ["Shree Siddhivinayak", "Golden Temple"]
    let placesImages = ["siddhivinayak", "amritsar"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("which view in table: \(whichView)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("fcCell") as! FCTableViewCell
        
        if whichView == "FC" {
                
            cell.cityName.text = cityNames[indexPath.row]
            cell.cityPicture.image = UIImage(named: cityImages[indexPath.row])
//            print("cell, nvc: \(self.navigationController)")
            
        }
        
        else {
            
            cell.cityName.text = placesNames[indexPath.row]
            cell.cityPicture.image = UIImage(named: placesImages[indexPath.row])
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("in did select, nvc: \(self.parentViewController)")
        
        let descriptionVC = storyboard?.instantiateViewControllerWithIdentifier("EachMustDoViewController") as! TrialViewController
//        let controllerThree = storyboard!.instantiateViewControllerWithIdentifier("featuredRest") as! FeaturedCitiesRestViewController
//        controllerThree.whichView = "IT"
        segueFromPagerStrip(nvcTwo, nextVC: descriptionVC)
        
    }

}

class FCTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityPicture: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    
}
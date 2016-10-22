//
//  FeaturedCitiesNewTwoViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftyJSON

class FeaturedCitiesNewTwoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var featuredCityTableView: UITableView!
    
    var whichView: String!
    let cityNames = ["Agra", "Amritsar"]
    let cityImages = ["taj_mahal", "amritsar"]
    let placesNames = ["Shree Siddhivinayak", "Golden Temple"]
    let placesImages = ["siddhivinayak", "amritsar"]
    var city = ""
    var allMustDos: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMustDo()
        print("which view in table: \(whichView)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if whichView == "FC" {
            return 2
        } else {
            return allMustDos.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fcCell") as! FCTableViewCell
        
        if whichView == "FC" {
                
            cell.cityName.text = cityNames[(indexPath as NSIndexPath).row]
            cell.cityPicture.image = UIImage(named: cityImages[(indexPath as NSIndexPath).row])
//            print("cell, nvc: \(self.navigationController)")
            
        }
        
        else {
            
            cell.cityName.text = "#\((indexPath as NSIndexPath).row + 1) \(allMustDos[(indexPath as NSIndexPath).row]["name"].string!)"
            cell.cityPicture.image = UIImage(data: try! Data(contentsOf: URL(string: allMustDos[(indexPath as NSIndexPath).row]["mainPhoto"].string!)!))
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("in did select, nvc: \(self.parent)")
        
        let descriptionVC = storyboard?.instantiateViewController(withIdentifier: "EachMustDoViewController") as! TrialViewController
        descriptionVC.singleMustDo = allMustDos[(indexPath as NSIndexPath).row]
//        let controllerThree = storyboard!.instantiateViewControllerWithIdentifier("featuredRest") as! FeaturedCitiesRestViewController
//        controllerThree.whichView = "IT"
        segueFromPagerStrip(nvcTwo, nextVC: descriptionVC)
        
    }
    
    func getMustDo() {
        
        request.cityTypeData("mustDos", city: city, completion: {(response) in
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    print("error: \(response.error!.localizedDescription)")
                }
                else if let abc = response["value"].string {
                    self.allMustDos = response["data"]["mustDo"].array!
                    self.featuredCityTableView.reloadData()
                }
                else {
                    print("response error")
                }
                
            })
            
        })
        
    }

}

class FCTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityPicture: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    
}

//
//  BucketListTableViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 31/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftyJSON

class BucketListTableViewController: UITableViewController  {
    
    var whichView: String!
    var bucket: [JSON] = []
    var result: [JSON] = []
//    var countriesVisited: [JSON] = []
    
    var isComingFromEmptyPages = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.gotoProfile(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "add_fa_icon"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(BucketListTableViewController.addCountriesVisited(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        
        self.customNavigationBar(leftButton, right: rightButton)
        
        if whichView == "BucketList" {
            
            self.title = "Bucket List"
            getBucketList()
            
        }
        
        if whichView == "CountriesVisited" {
            
            self.title = "Countries Visited"
            getCountriesVisited()
            
//            request.getCountriesVisited(currentUser["_id"].string!, completion: {(response) in
//                
//                dispatch_async(dispatch_get_main_queue(), {
//                    
//                    if response.error != nil {
//                        
//                        print("error - \(response.error!.code): \(response.error!.localizedDescription)")
//                    }
//                    else if let abc = response["value"].string {
//                        
////                        self.bucket = response["data"]["countriesVisited"].array!
////                        self.tableView.reloadData()
//                        
//                    }
//                    else {
//                        
//                        print("response error: \(response["data"])")
//                        
//                    }
//                })
//                
//                
//            })
            
            
        }
        
        tableView.separatorColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isComingFromEmptyPages {
            
            print("has come here")
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotoProfile(_ sender: UIButton) {
        
        for vc in self.navigationController!.viewControllers {
            
            if vc.isKind(of: ProfileViewController.self) {
                
                print("inside if statement bucket list")
                self.navigationController!.popToViewController(vc, animated: true)
                
            }
            
        }
        
//        let profile = storyboard?.instantiateViewControllerWithIdentifier("ProfileVC") as! ProfileViewController
//        self.navigationController?.pushViewController(profile, animated: false)
//        (ProfileViewController(), animated: true)
        
//        if ((self.navigationController?.viewControllers.contains(profile)) != nil) {
//            
//            let arrayOfVCs = self.navigationController!.viewControllers as Array
//            
//            let index = arrayOfVCs.indexOf(profile)
//            print("index: \(index)")
//            print("inside contains")
//            
//        }

//        for container in self.navigationController!.viewControllers {
//            
//            if container.isEqual(profile) {
//                
//                print("contains")
//                
//            }
//            
//        }
        
        
//        self.navigationController?.popToRootViewControllerAnimated(true)
//        self.navigationController?.popToViewController(, animated: true)
        
    }
    
    func getBucketList() {
        
            request.getBucketList(currentUser["_id"].string!, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    
                    if response.error != nil {
                        
                        print("error - \(response.error?.code): \(response.error?.localizedDescription)")
                    }
                    else if let abc = response["value"].string {
                        
//                        let profile = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2] as! ProfileViewController
//                        profile.setCount()
//                        profile.getCount()
                        
                        self.bucket = response["data"]["bucketList"].array!
                        if self.bucket.count == 0 {
                            
                            print("bucket list is empty")
                            let emptyBucket = self.storyboard?.instantiateViewController(withIdentifier: "emptyPages") as! EmptyPagesViewController
                            emptyBucket.whichView = self.whichView
                            self.navigationController?.pushViewController(emptyBucket, animated: false)
                            
                        }
                        self.tableView.reloadData()
                        
                    }
                    else {
                        
                        print("response error: \(response["data"])")
                        
                    }
                })
                
            })
            
            
//        }
        
    }
    
    func getCountriesVisited() {
        
        request.getCountriesVisited(currentUser["_id"].string!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error - \(response.error?.code): \(response.error?.localizedDescription)")
                }
                else if let abc = response["value"].string {
                    
                    //                        let profile = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2] as! ProfileViewController
                    //                        profile.setCount()
                    //                        profile.getCount()
                    
                    self.result = response["data"]["countriesVisited"].array!
                    getCountries = self.result
//                    for res in self.result {
//                        
//                        let temp = res["countries"].array!
//                        for t in temp {
//                            
//                            self.bucket.append(t)
//                            
//                        }
//                        
//                    }
                    
//                    print("bucket: \(self.bucket)")
                    
                    if self.result.count == 0 {
                        
                        print("bucket list is empty")
                        let emptyBucket = self.storyboard?.instantiateViewController(withIdentifier: "emptyPages") as! EmptyPagesViewController
                        emptyBucket.whichView = "CountriesVisited"
                        self.navigationController?.pushViewController(emptyBucket, animated: false)
                        
                    }
                    self.tableView.reloadData()
                    
                }
                else {
                    
                    print("response error: \(response["data"])")
                    
                }
            })
            
        })
        
        
        //        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if whichView == "BucketList" {
            
            return 1
            
        }
        
        else if whichView == "CountriesVisited" {
            
            return self.result.count
            
        }

        
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if whichView == "BucketList" {
            
            return self.bucket.count
            
        }
            
        else if whichView == "CountriesVisited" {
            
//            let countries = 
            return self.result[section]["countries"].array!.count
            
        }
        
        
        return 0
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if whichView == "BucketList" {
            
//            if indexPath.row % 2 == 0 {
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BucketListTableViewCell
                cell.countryName.text = bucket[(indexPath as NSIndexPath).row]["name"].string!
                cell.yearOfVisit.isHidden = true
                return cell
                
//            }
//            
//            let cell = tableView.dequeueReusableCellWithIdentifier("SeperatorCell", forIndexPath: indexPath) as! NoViewTableViewCell
//            return cell
            
        }
        
        else if whichView == "CountriesVisited" {
            
            //            if indexPath.row % 2 == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BucketListTableViewCell
//            print("bucket: \(bucket[indexPath.row]["countries"][0])")
            cell.countryName.text = self.result[(indexPath as NSIndexPath).section]["countries"][(indexPath as NSIndexPath).row]["countryId"]["name"].string!
            cell.yearOfVisit.text = "\(self.result[(indexPath as NSIndexPath).section]["countries"][(indexPath as NSIndexPath).row]["year"])"
            return cell
            
            //            }
            //
            //            let cell = tableView.dequeueReusableCellWithIdentifier("SeperatorCell", forIndexPath: indexPath) as! NoViewTableViewCell
            //            return cell
            
        }
        
//        if indexPath.row % 2 == 0 {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BucketListTableViewCell
            return cell
            
//        }
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("SeperatorCell", forIndexPath: indexPath) as! NoViewTableViewCell
//        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        if indexPath.row % 2 == 0 {
        
            return 72
//        }
//        
//        return 3
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
//        if whichView == "BucketList" {
//            let delete = UITableViewRowAction(style: UITableViewRowActionStyle(), title: "             ") { (action, indexPath) in
//                
////                print("bucket list removal: \(self.bucket[indexPath.row]["_id"])")
//                
//                request.removeBucketList(currentUser["_id"].string!, country: self.bucket[(indexPath as NSIndexPath).row]["_id"].string!, completion: {(response) in
//                    
//                    DispatchQueue.main.async(execute: {
//                        
//                        if response.error != nil {
//                            
//                            print("error- \(response.error?.code): \(response.error?.localizedDescription)")
//                            
//                        }
//                        else if let abc = response["value"].string {
//                            
////                            tableView.reloadData()
//                            self.getBucketList()
//                            
//                        }
//                        else {
//                            
//                            print("response error: \(response["error"])")
//                            
//                        }
//                    })
//                })
//                
//            }
//            delete.backgroundColor = UIColor(patternImage: UIImage(named: "trash")!)
//            return [delete]
//        }
//        
//        else if whichView == "CountriesVisited" {
//            let delete = UITableViewRowAction(style: UITableViewRowActionStyle(), title: "             ") { (action, indexPath) in
//                
//                print("countries visited removal: \(self.result[(indexPath as NSIndexPath).section]["countries"][(indexPath as NSIndexPath).row]["countryId"]["_id"].string!)")
//                
//                request.removeCountriesVisited(currentUser["_id"].string!, countryId: self.result[(indexPath as NSIndexPath).section]["countries"][(indexPath as NSIndexPath).row]["countryId"]["_id"].string!, year: self.result[(indexPath as NSIndexPath).section]["countries"][(indexPath as NSIndexPath).row]["year"].int!, completion: {(response) in
//                    
//                    DispatchQueue.main.async(execute: {
//                        
//                        if response.error != nil {
//                            
//                            print("error- \(response.error?.code): \(response.error?.localizedDescription)")
//                            
//                        }
//                        else if let abc = response["value"].string {
//                            
//                            //                            tableView.reloadData()
//                            self.getCountriesVisited()
//                            
//                        }
//                        else {
//                            
//                            print("response error: \(response["error"])")
//                            
//                        }
//                    })
//                })
//                
//            }
//            delete.backgroundColor = UIColor(patternImage: UIImage(named: "trash")!)
//            return [delete]
//        }
        
        let delete = UITableViewRowAction(style: .normal, title: "") { (action, indexPath) in
            // delete item at indexPath
        }
        
//        let share = UITableViewRowAction(style: .Normal, title: "Disable") { (action, indexPath) in
//            // share item at indexPath
//        }
//        
//        share.backgroundColor = UIColor.blueColor()
        
        return [delete]
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if whichView == "BucketList" {
            
            return 0
        }
        
        return 35
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if whichView == "CountriesVisited" {
            
            return "\(self.result[section]["year"])"
        }
        
        return nil
    }
    
    func addCountriesVisited(_ sender: UIButton) {
        
        if whichView == "BucketList" {
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "SelectCountryVC") as! SelectCountryViewController
            nextVC.whichView = "BucketList"
            print("bucket list \(bucket)")
            nextVC.alreadySelected = bucket
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        else {
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "SelectCountryVC") as! SelectCountryViewController
            nextVC.whichView = "CountriesVisited"
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
    }

}

class BucketListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryPicture: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var yearOfVisit: UILabel!
    
}

class NoViewTableViewCell: UITableViewCell {
    
    
    
}

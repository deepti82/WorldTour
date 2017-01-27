//
//  BucketListTableViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 31/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit


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
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        if whichView == "BucketList" {
            self.title = "Bucket List"
            getBucketList()
        }
        
        if whichView == "CountriesVisited" {
            self.title = "Countries Visited"
            getCountriesVisited()
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
    func goBack(_ sender:AnyObject) {
        
    }
    func gotoProfile(_ sender: UIButton) {
        
//        for vc in self.navigationController!.viewControllers {
//            
//            if vc.isKind(of: ProfileViewController.self) {
//                
//                print("inside if statement bucket list")
//                self.navigationController!.popToViewController(vc, animated: true)
//                
//            }
//            
//        }
        self.navigationController!.popViewController(animated: true)
    }
    
    func getBucketList() {
        
        request.getBucketList(currentUser["_id"].string!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error - \(response.error?.code): \(response.error?.localizedDescription)")
                }
                else if response["value"].bool! {
                    
                    self.bucket = response["data"]["bucketList"].array!
                    print(self.bucket);
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
                else if response["value"].bool! {
                    
                    self.result = response["data"]["countriesVisited"].array!
                    getCountries = self.result
                    
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
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BucketListTableViewCell
            cell.countryName.layer.zPosition = 100
            cell.yearOfVisit.layer.zPosition = 100
            cell.countryName.text = bucket[(indexPath as NSIndexPath).row]["name"].string!
            cell.countryPicture.hnk_setImageFromURL(getImageURL(bucket[indexPath.row]["countryCoverPhoto"].stringValue,width: 500))
            cell.countryPicture.alpha = 1
            cell.yearOfVisit.isHidden = true
            cell.tintView.isUserInteractionEnabled = true
            cell.countryPicture.isUserInteractionEnabled = false
            return cell
            
            
            
        }
            
        else if whichView == "CountriesVisited" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BucketListTableViewCell
            cell.countryName.layer.zPosition = 100
            cell.yearOfVisit.layer.zPosition = 100
            cell.countryName.text = self.result[(indexPath as NSIndexPath).section]["countries"][(indexPath as NSIndexPath).row]["countryId"]["name"].string!
            cell.yearOfVisit.text = "\(self.result[(indexPath as NSIndexPath).section]["countries"][(indexPath as NSIndexPath).row]["year"])"
            cell.countryPicture.hnk_setImageFromURL(getImageURL(self.result[indexPath.section]["countries"][indexPath.row]["countryId"]["countryCoverPhoto"].stringValue,width: 500))
            cell.countryPicture.alpha = 1
            cell.tintView.isUserInteractionEnabled = true
            cell.countryPicture.isUserInteractionEnabled = false

            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BucketListTableViewCell
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let delete = UITableViewRowAction(style: .destructive , title: "Delete") { (action, indexPath) in
            if self.whichView == "BucketList" {
                print("DELETE Bucket List");
            } else if self.whichView == "CountriesVisited" {
                print("DELETE Countries Visited");
            }
        }
        
        
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
            self.title = "Countries Visited"
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
    @IBOutlet weak var tintView: UIView!
    
}

class NoViewTableViewCell: UITableViewCell {
    
    
    
}

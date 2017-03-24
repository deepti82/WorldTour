//
//  SearchTableViewController.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 14/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
import DKChainableAnimationKit
var globalSearchTableViewController: SearchTableViewController!
class SearchTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var hashTagSlide: UIView!
    @IBOutlet weak var hashtagsSearch: UIButton!
    @IBOutlet weak var peopleSearch: UIButton!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet var noTravellersStrip: UILabel!
    @IBOutlet var selectStrip: UIView!
    var loadStatus: Bool = true
    var searchTextGlob: String = ""
    var selectedStatus: String = "people"
    var allData:[JSON] = []
    var page = 1
    
    var newSearch:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTable.tableFooterView = UIView()
        
        globalSearchTableViewController = self
        print(newSearch)
//        transparentCardWhite(selectStrip)
        transparentCardWhite(noTravellersStrip)
        //transparentCardWhite(searchTable)
        sliderView.isHidden = false
        hashTagSlide.isHidden = true
//        getDarkBackGround(self)
        noTravellersStrip.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedStatus != "people" {
            selectedHash = allData[indexPath.row]["title"].stringValue
            let tlVC = storyboard!.instantiateViewController(withIdentifier: "activityFeeds") as! ActivityFeedsController
            tlVC.displayData = "hashtags"
            globalNavigationController?.pushViewController(tlVC, animated: false)
        }else{
            selectedPeople = allData[indexPath.row]["_id"].stringValue
            selectedUser = allData[indexPath.row]
            let profile = self.storyboard!.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
            profile.displayData = "search"
            self.navigationController!.pushViewController(profile, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "search", for: indexPath) as! searchPeople
        if selectedStatus == "people" {
            transparentCardWhite(cell.contentView)
            cell.hashText.isHidden = true
            cell.peopleHashtagsImage.image = UIImage(named: "logo-default")
            cell.peopleHashtagsImage.hnk_setImageFromURL(getImageURL(allData[indexPath.row]["profilePicture"].stringValue, width: 200))
            noColor(cell.peopleHashtagsImage)
            cell.nameHashtagsLabel.text = allData[indexPath.row]["name"].stringValue
            cell.slurgHashtimesLabel.text = allData[indexPath.row]["urlSlug"].stringValue
        }else{
            cell.hashText.isHidden = false
            cell.peopleHashtagsImage.image = UIImage()
            cell.peopleHashtagsImage.image = UIImage(named: "graybox")
            noColor(cell.peopleHashtagsImage)
            cell.nameHashtagsLabel.text = allData[indexPath.row]["title"].stringValue
            cell.slurgHashtimesLabel.text = "\(allData[indexPath.row]["count"].stringValue) Times"
        }
        return cell
    }
    
    func refreshUI() {
        self.searchTable.reloadData()
    }
    
    func searchPeople(search: String) {
        self.searchTextGlob = search
        loadStatus = false
        if search != "" {
            
            request.getPeopleSearch(currentUser["_id"].stringValue, search: search, pageNumber: self.page, completion:{(request) in
                DispatchQueue.main.async(execute: {
                    
                    if request["data"].count > 0 {
                        
                        if self.page == 1 {
                            self.allData = []
                            self.allData = request["data"].array!
                        }else{
                            
                            for city in request["data"].array! {
                                if !(self.allData.contains(value: city)) {
                                    self.allData.append(city)
                                }
                            }
                        }
                        self.page = self.page + 1
                        self.loadStatus = true
                        self.refreshUI()
                        
                    }else{
                        
                        self.loadStatus = false
                    }
                    if self.allData.count == 0 {
                        self.searchTable.isHidden = true
                        self.noTravellersStrip.text = "No Traveller Found"
                        self.noTravellersStrip.isHidden = false
                    }else{
                        self.searchTable.isHidden = false
                        self.noTravellersStrip.isHidden = true
                    }
                })
            })
            
        }
    }
  
    
    func searchHashtags(search: String) {
       
        loadStatus = false
        if search != "" {
            request.getHashtagSearch(search, pageNumber: page, completion:{(request) in
                DispatchQueue.main.async(execute: {

                if request["data"].count > 0 {
                    
                    if self.page == 1 {
                        self.allData = []
                        self.allData = request["data"].array!
                    }else{
                        
                        for city in request["data"].array! {
                            self.allData.append(city)
                            
                        }
                    }
                    self.page = self.page + 1
                    self.loadStatus = true
                    self.refreshUI()
                }else{
                    
                    self.loadStatus = false
                }
                    
                    if self.allData.count == 0 {
                        self.searchTable.isHidden = true
                        self.noTravellersStrip.text = "No Hashtags Found"

                        self.noTravellersStrip.isHidden = false
                    }else{
                        self.searchTable.isHidden = false
                        self.noTravellersStrip.isHidden = true
                    }
                    
                })
            })
        }
        
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("in loading")
        print(page)
        print(loadStatus)
        if loadStatus {
            if selectedStatus == "people" {
                self.searchPeople(search: searchTextGlob)
            }else{
                self.searchHashtags(search: searchTextGlob)
            }
        }
        
    }
    
    
    @IBAction func people(_ sender: Any) {
        sliderView.isHidden = false
        hashTagSlide.isHidden = true
        selectedStatus = "people"
        allData = []
        refreshUI()
        searchTable.isHidden = true
        page = 1
        searchPeople(search: searchTextGlob)
    }
    
    @IBAction func hashtags(_ sender: UIButton) {
        hashTagSlide.isHidden = false
        sliderView.isHidden = true
        selectedStatus = "hashtags"
        allData = []
        refreshUI()
        searchTable.isHidden = true
        page = 1
        searchHashtags(search: searchTextGlob)
        
    }
    
    
}

class searchPeople: UITableViewCell{
    
    @IBOutlet weak var peopleHashtagsImage: UIImageView!
    @IBOutlet weak var nameHashtagsLabel: UILabel!
    @IBOutlet weak var slurgHashtimesLabel: UILabel!
    
    @IBOutlet weak var hashText: UILabel!
}

//
//  SearchTableViewController.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 14/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
import DKChainableAnimationKit

class SearchTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    var searchController: UISearchController!
    @IBOutlet weak var hashtagsTable: UITableView!
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
        print(newSearch)
        transparentCardWhite(selectStrip)
        sliderView.isHidden = false
        hashTagSlide.isHidden = true
        getDarkBackGround(self)
        noTravellersStrip.isHidden = true
        configureSearchController()
        setTopNavigation("Search")
        
        searchController.searchBar.text = self.newSearch
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "search", for: indexPath) as! searchPeople
        if selectedStatus == "people" {
            cell.hashText.isHidden = true
            cell.peopleHashtagsImage.hnk_setImageFromURL(getImageURL(allData[indexPath.row]["profilePicture"].stringValue, width: 200))
            noColor(cell.peopleHashtagsImage)
            cell.nameHashtagsLabel.text = allData[indexPath.row]["name"].stringValue
            cell.slurgHashtimesLabel.text = allData[indexPath.row]["email"].stringValue
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
        DispatchQueue.main.async {
            self.searchTable.reloadData()
            //        self.searchController.searchResultsController?.reloadInputViews()
            //        self.searchController.searchResultsTableView.reloadData()
        }}
    
    func searchPeople(search: String) {
        loadStatus = false
        if search != "" {
            request.getPeopleSearch(currentUser["_id"].stringValue, search: search, pageNumber: self.page, completion:{(request) in
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
            })
            
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // code here
        
    }
    
    func searchHashtags(search: String) {
        loadStatus = false
        if search != "" {
            request.getHashtagSearch(search, pageNumber: page, completion:{(request) in
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
            })
        }
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextGlob = searchText
        self.page = 1
        print(searchText)
        if selectedStatus == "people" {
            self.searchPeople(search: searchText)
        } else {
            self.searchHashtags(search: searchText)
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
        self.refreshUI()
        page = 1
    }
    
    @IBAction func hashtags(_ sender: UIButton) {
        
        hashTagSlide.isHidden = false
        sliderView.isHidden = true
        selectedStatus = "hashtags"
        allData = []
        self.refreshUI()
        page = 1
        
    }
    
    func configureSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchTable.tableHeaderView = searchController.searchBar
        
    }
    
    
    func setTopNavigation(_ text: String) {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.goBack(_:)), for: .touchUpInside)
        let rightButton = UIView()
        self.title = text
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]
        
        self.customNavigationBar(left: leftButton, right: rightButton)
    }
    
    
    
    func goBack(_ sender:AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    
    
}

class searchPeople: UITableViewCell{
    
    @IBOutlet weak var peopleHashtagsImage: UIImageView!
    @IBOutlet weak var nameHashtagsLabel: UILabel!
    @IBOutlet weak var slurgHashtimesLabel: UILabel!
    
    @IBOutlet weak var hashText: UILabel!
}

//
//  QuickIteneraryTableViewController.swift
//  TraveLibro
//
//  Created by Jagruti  on 13/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickIteneraryTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var countries: JSON = []
    var countriesSearchResults: JSON = []
    var searchCity: String = ""
    var isSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(SelectGenderViewController.gotoDP(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        
        self.customNavigationBar(left: leftButton, right: nil)
        if selectedStatus == "country" {
            request.getAllCountries({(request) in
                self.countries = request["data"]
                self.tableView.reloadData()
            })
        }else {
//            request.getAllCityC(searchCity, country: selectedCountry["_id"].stringValue, completion:{(request) in
//                self.countries = request["data"]
//                self.tableView.reloadData()
//            })
        }
    }
    
    func searchCityFun(search: String) {
        request.getAllCityC(search, country: selectedCountry["_id"].stringValue, completion:{(request) in
            DispatchQueue.main.async(execute: {
                if (request["data"].count != 0){
                self.countriesSearchResults = request["data"]
                self.tableView.reloadData()
                }
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return countriesSearchResults.count
        }else{
            return countries.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if isSearch {
            cell.textLabel?.text = countriesSearchResults[indexPath.row]["name"].stringValue
        }else{
            cell.textLabel?.text = countries[indexPath.row]["name"].stringValue
        }
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSearch {
            let c:JSON = countriesSearchResults[indexPath.row]
            selectedCity.arrayObject?.append(c.object)
        }else{
            if selectedStatus == "country" {
                selectedCountry = countries[indexPath.row]
            }else{
                selectedCity = countries[indexPath.row]
            }        }
        let next = self.storyboard?.instantiateViewController(withIdentifier: "qiPVC") as! QIViewController
        next.selectedView = true
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        isSearch = true
        self.searchCityFun(search: searchText)
        
    }
    
}

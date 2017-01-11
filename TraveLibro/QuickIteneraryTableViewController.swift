//
//  QuickIteneraryTableViewController.swift
//  TraveLibro
//
//  Created by Jagruti  on 13/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Toaster

class QuickIteneraryTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var countries: [JSON] = []
    var countriesSearchResults: [JSON] = []
    var searchCity: String = ""
    var isSearch = false
    var searchTextGlob: String = ""
    var countriesArr: [JSON] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedStatus == "country" {
            request.getAllCountries({(request) in
                DispatchQueue.main.async(execute: {
                    self.countries = request["data"].array!
                    self.countriesArr = request["data"].array!
                    self.tableView.reloadData()
                })
            })
        }else {
            //            request.getAllCityC(searchCity, country: selectedCountry["_id"].stringValue, completion:{(request) in
            //                self.countries = request["data"]
            //                self.tableView.reloadData()
            //            })
        }
        
        
        UIApplication.shared.isStatusBarHidden = true
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        UIApplication.shared.isStatusBarHidden = false
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print(searchTextGlob)
        searchCityFun(search: searchTextGlob)
    }
    
    func closeMe(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchCityFun(search: String) {
        print(selectedCountry)
        var contid = selectedCountry["_id"].stringValue
        if selectedCountry["country"] != nil {
            contid = selectedCountry["country"].stringValue
        }else{
            contid = selectedCountry["_id"].stringValue
        }
        
        request.getAllCityC(search, country: contid, completion:{(request) in
            self.countriesSearchResults = []
            print(request["data"])
            for city in request["data"].array! {
                self.countriesSearchResults.append(city)
            }
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        })
    }
    func searchCountryFun(search: String) {
        print(selectedCountry)
        self.countriesSearchResults = []
        for country in self.countriesArr {
            var str = String(country["name"].stringValue)
            if(str?.localizedCaseInsensitiveContains(search))! {
                self.countriesSearchResults.append(country)
            }
        }
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
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
            if selectedStatus == "country" {
                if selectedStatus == "country" {
                    selectedCountry = countriesSearchResults[indexPath.row]
                    selectedCity = []
                }else{
                    selectedCity = countriesSearchResults[indexPath.row]
                }
            }
            else {
                let c:JSON = countriesSearchResults[indexPath.row]
                print(c)
                if !selectedCity.contains(where: {$0.1["placeId"] == c["placeId"]}) {
                    
                    selectedCity.arrayObject?.append(c.object)
                }else{
                    let tstr = Toast(text: "City already exist")
                    tstr.show()
                }
            }
            
        } else {
            if selectedStatus == "country" {
                selectedCountry = countries[indexPath.row]
                selectedCity = []
            }else{
                selectedCity = countries[indexPath.row]
            }
        }
        UIApplication.shared.isStatusBarHidden = false
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search");
        isSearch = true
        searchTextGlob = searchText
        if selectedStatus == "country" {
            self.searchCountryFun(search: searchText)
        } else {
            self.searchCityFun(search: searchText)
        }
    }
    
}

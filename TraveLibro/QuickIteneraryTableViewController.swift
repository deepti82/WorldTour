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
//        let leftButton = UIButton()
//        leftButton.setTitle("Done", for: .normal)
//        leftButton.addTarget(self, action: #selector(self.closeMe(_:)), for: .touchUpInside)
//        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

//        let rightButton = UIButton()
//        rightButton.setTitle("Done", for: .normal)
//        rightButton.addTarget(self, action: #selector(self.closeMe(_:)), for: .touchUpInside)
//        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)

//        self.customNavigationBar(left: leftButton, right: nil)
        print(selectedStatus)
        
        if selectedStatus == "country" {
            request.getAllCountries({(request) in
                DispatchQueue.main.async(execute: {
                self.countries = request["data"]
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
    
    func closeMe(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
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
                selectedCity = []
            }else{
                selectedCity = countries[indexPath.row]
            }
        }
        UIApplication.shared.isStatusBarHidden = false
        self.dismiss(animated: true, completion: nil)
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "qiPVC") as! QIViewController
//        next.selectedView = true
//        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        isSearch = true
        self.searchCityFun(search: searchText)
        
    }
    
}

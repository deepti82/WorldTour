//
//  AddYearsCountriesVisitedTableViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 07/09/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftyJSON

var trialVariable: [JSON] = []
var getCountries: [JSON]!

class AddYearsCountriesVisitedTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var years = ["2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009", "2008", "2007", "2006", "2005", "2004", "2003", "2002", "2001", "2000", "1999", "1998", "1997", "1996", "1995", "1994", "1993", "1992", "1991", "1990", "1989", "1988", "1987", "1986", "1985", "1984", "1983", "1982", "1981", "1980", "1979", "1978", "1977", "1976", "1975", "1974", "1973", "1972", "1971", "1970", "1969", "1968", "1967", "1966", "1965", "1964", "1963", "1962", "1961", "1960", "1959", "1958", "1957", "1956", "1955", "1954", "1953", "1952", "1951", "1950", "1949", "1948", "1947", "1946", "1945", "1944", "1943", "1942", "1941", "1940"]
    
    var selectedCountry: String!
    
    var searchController: UISearchController!
    
    var filteredArray: [String]!
    
    var shouldShowSearchResults = false
    
    var selectedYears: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trialVariable = []
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: -10, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setTitle("Save", for: UIControlState())
        rightButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 15)
        rightButton.addTarget(self, action: #selector(SelectCountryViewController.saveCountriesVisited(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 10, y: 0, width: 70, height: 30)
        self.customNavigationBar(leftButton, right: rightButton)
        
        self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        configureSearchController()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchController.dimsBackgroundDuringPresentation = true
        shouldShowSearchResults = true
        tableView.reloadData()
        
    }
    
    func configureSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        shouldShowSearchResults = false
        tableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !shouldShowSearchResults {
            
            shouldShowSearchResults = true
            tableView.reloadData()
            
        }
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        searchController.dimsBackgroundDuringPresentation = false
        let searchString = searchController.searchBar.text
        
        // Filter the data array and get only those countries that match the search text.
        filteredArray = years.filter({(year) -> Bool in
            
            //            print("country: \(country["name"])")
            
            let yearText: NSString = year as NSString
            
            print("country: \(yearText.range(of: searchString!, options: .caseInsensitive).location)")
            
            return (yearText.range(of: searchString!, options: .caseInsensitive).location) != NSNotFound
        })
        
        //        filteredArray = countries.filter{$0["name"].string! == searchString}
        
        print("filtered array: \(filteredArray)")
        
        // Reload the tableview.
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if shouldShowSearchResults && filteredArray != nil {
            
            return filteredArray.count
            
        }
        return years.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "yearCells", for: indexPath) as! AddYearsTableViewCell
        
        if shouldShowSearchResults && filteredArray != nil {
            
            cell.yearLabel.text = filteredArray[(indexPath as NSIndexPath).row]
            
        }
        else {
            
            cell.yearLabel.text = years[(indexPath as NSIndexPath).row]
        }
        
//        cell.addQty.addTarget(self, action: #selector(AddYearsCountriesVisitedTableViewController.addQuantity(_:)), forControlEvents: .TouchUpInside)
//        cell.removeQty.addTarget(self, action: #selector(AddYearsCountriesVisitedTableViewController.removeQuantity(_:)), forControlEvents: .TouchUpInside)
        cell.selectionStyle = .none
        cell.accessoryType = .checkmark
        
        if (indexPath as NSIndexPath).row % 2 == 0 {
            
            cell.backgroundColor = mainOrangeColor.withAlphaComponent(0.1)
            
        }
            
        else {
            
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.6)
            
        }
        
        if selectedYears.contains(years[(indexPath as NSIndexPath).row]) {
            
            cell.tintColor = mainOrangeColor
            cell.cartView.isHidden = false
            
//            for i in 0 ..< years.count {
//                
//                for j in 0 ..< trialVariable.count {
//                    
//                    if years[i] == trialVariable[j]["country"].string! {
//                        
//                        cell.qtyField.text = trialVariable[j]["quantity"].string!
//                        
//                    }
//                    
//                    
//                }
//                
//            }
            
        }
        
        else {
            
            cell.tintColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
            cell.cartView.isHidden = true
        }
        
//        if filteredArray != nil && filteredArray.count > 0 && s electedCountries.contains(filteredArray[indexPath.row]["_id"].string!) {
//            
//            if indexPath.row == 0 {
//                
//                print("in here \(filteredArray[indexPath.row]["_id"].string!)")
//                
//            }
//            
//            cell.tintColor = mainOrangeColor
//            
//        }
        
//        if alreadySelected != nil && alreadySelected.contains(years[indexPath.row]) && filteredArray != nil && filteredArray.count == 0 {
//            
//            print("already selected contains \(years[indexPath.row])")
//            cell.tintColor = mainOrangeColor
//        }
//            
//        else if selectedYears.contains(years[indexPath.row]["_id"].string!) && filteredArray != nil && filteredArray.count == 0 {
//            
//            cell.tintColor = mainOrangeColor
//            
//        }
        
//        else {
//            
//            cell.tintColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
//            
//        }

        return cell
    }
    
    var latestIndexPath: IndexPath!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCountry = tableView.cellForRow(at: indexPath) as! AddYearsTableViewCell
        searchBarSearchButtonClicked(searchController.searchBar)
        
        if selectedCountry.tag == 0 {
            
            selectedCountry.tintColor = mainOrangeColor
            selectedCountry.cartView.isHidden = false
            selectedCountry.tag = 1
            
            if shouldShowSearchResults && filteredArray != nil {
                
                selectedYears.append(filteredArray[(indexPath as NSIndexPath).row])
                trialVariable.append(["country": filteredArray[(indexPath as NSIndexPath).row], "quantity": 1])
                
            }
            else {
                
                selectedYears.append(years[(indexPath as NSIndexPath).row])
                trialVariable.append(["country": years[(indexPath as NSIndexPath).row], "quantity": 1])
            }
            
        }
        
        else {
            
            selectedCountry.tag = 0
            selectedCountry.tintColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
            selectedCountry.cartView.isHidden = true
            
            if shouldShowSearchResults && filteredArray != nil {
                
                selectedYears = selectedYears.filter{$0 != filteredArray[(indexPath as NSIndexPath).row]}
                trialVariable = trialVariable.filter({$0["country"].string! != filteredArray[(indexPath as NSIndexPath).row]})
            }
            else {
                
                selectedYears = selectedYears.filter{$0 != years[(indexPath as NSIndexPath).row]}
                trialVariable = trialVariable.filter({$0["country"].string! != years[(indexPath as NSIndexPath).row]})
            }
            
        }
        
    }
    
    func saveCountriesVisited(_ sender: UIButton) {
        
        print("save countries visited: \(selectedCountry), \(selectedYears)")
        
        var listFormat: JSON!
        var temp: [JSON] = []
        var list: JSON = ["year": "2016", "times": 0]
        
//        var test: JSON = ["id": "id", "year": "2016", "times": 0]
//        var testAggregate: [JSON] = []
        
        
//        for i in 0 ..< getCountries.count {
//            
//            for j in getCountries[i]["countries"].array! {
//                
//                test["id"] = j["countryId"]["_id"]
//                test["year"] = j["year"]
//                test["times"] = 1
//                
//                for k in getCountries[i]["countries"].array! {
//                    
//                    if j["_id"] == k["_id"] {
//                        
//                        test["times"].int = test["times"].int! + 1
//                        
//                    }
//                    
//                    
//                }
//               
//                print("test: \(test)")
//                
//            }
//            
//            testAggregate.append(test)
//        }
//        
//        print("test aggregate: \(testAggregate)")
        
        for i in 0 ..< trialVariable.count {
            
            var flag = 0
            list["year"].string = trialVariable[i]["country"].string!
            //            list["countryId"] = JSON(selectedYear)
//            for j in 0 ..< testAggregate.count {
//                
//                if "\(testAggregate[j]["year"])" == list["year"].string! {
//                    
//                    list["times"].int = trialVariable[i]["quantity"].int! + testAggregate[j]["times"].int!
//                    
//                }
//                
//            }
            list["times"].int = trialVariable[i]["quantity"].int!
            //            print("list: \(list)")
            temp.append(list)
            
        }
        print("previous countries: \(getCountries)")
        listFormat = JSON(temp)
        print("list format: \(listFormat)")
        
        request.addCountriesVisited(currentUser["_id"].string!, list: listFormat, countryVisited: selectedCountry, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error- \(response.error!.code): \(response.error!.localizedDescription)")
                }
                    
                else if response["value"] {
                    
                    print("response arrived")
                    //                    let total = self.navigationController?.viewControllers
                    let prevVC = self.storyboard?.instantiateViewController(withIdentifier: "bucketList") as! BucketListTableViewController
                    prevVC.whichView = "CountriesVisited"
                    //                    prevVC.tableView.reloadData()
                    self.navigationController?.pushViewController(prevVC, animated: false)
                    
                }
                    
                else {
                    
                    print("response error: \(response["data"])")
                    
                }
            })
        })
        
    }

}

class AddYearsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var addQty: UIButton!
    @IBOutlet weak var removeQty: UIButton!
    @IBOutlet weak var qtyField: UITextField!
    
    var quantity: Int!
    var currentYear: String!
    var flag = 0
    
    @IBAction func addQuantity(_ sender: AnyObject) {
        
        print("in add quantity")
        currentYear = yearLabel.text
        quantity = Int(qtyField.text!)!
        quantity = quantity+1
        qtyField.text = "\(quantity)"
        
        for i in 0 ..< trialVariable.count {
            
            if currentYear == trialVariable[i]["country"].string! {
                
                trialVariable[i]["quantity"].int! = quantity
                flag = 1
            }
            
        }
        
        if flag == 0 {
            
            trialVariable.append(["country": currentYear, "quantity": quantity])
            
        }
        
        print("trial variable: \(trialVariable)")
    }
    
    @IBAction func removeQuantity(_ sender: AnyObject) {
        
        print("in remove quantity")
        currentYear = yearLabel.text
        quantity = Int(qtyField.text!)!
        
        if quantity > 1 {
            
            quantity = quantity-1
            qtyField.text = "\(quantity)"
            
            for i in 0 ..< trialVariable.count {
                
                if currentYear == trialVariable[i]["country"].string! {
                    
                    trialVariable[i]["quantity"].int! = quantity
                    flag = 1
                }
                
            }
            
            if flag == 0 {
                
                trialVariable.append(["country": currentYear, "quantity": quantity])
                
            }
            
            print("trial variable: \(trialVariable)")
        }
        
    }

    
}

//
//  AddYearsCountriesVisitedTableViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 07/09/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit


var trialVariable: [JSON] = []
var getCountries: [JSON]!

class AddYearsCountriesVisitedTableViewController: UITableViewController {
    
    var years: [String] = []
    var date = NSDate()
    var selectedCountry: String!
    
    var searchController: UISearchController!
    
    var filteredArray: [String]!
    
    var shouldShowSearchResults = false
    var loader = LoadingOverlay()
    var selectedYears: [String] = []
    var currentYear: Int = 0
    var previousYear: Int = 1960
    override func viewDidLoad() {
        super.viewDidLoad()
        //loader.showOverlay(self.view)
        getDarkBackGround(self)
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "darkBgNew")!)
        trialVariable = []
        let dateFormatter = DateFormatter()        
        dateFormatter.dateFormat = "yyyy"
        currentYear = Int(dateFormatter.string(from: date as Date))!
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: -10, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setTitle("Save", for: UIControlState())
        rightButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 15)
        rightButton.addTarget(self, action: #selector(SelectCountryViewController.saveCountriesVisited(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        self.customNavigationTextBar(left: leftButton, right: rightButton, text: "Countries Visited")
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]

        
        self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
//        configureSearchController()
        for i in previousYear...currentYear{
            years.append("\(currentYear)")
            currentYear -= 1
        }

    }
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        
//        searchController.dimsBackgroundDuringPresentation = true
//        shouldShowSearchResults = true
//        tableView.reloadData()
//        
//    }
    
//    func configureSearchController() {
//        
//        searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = true
//        searchController.searchBar.delegate = self
//        searchController.searchBar.sizeToFit()
//        tableView.tableHeaderView = searchController.searchBar
//        
//    }
    
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        
//        shouldShowSearchResults = false
//        tableView.reloadData()
//        
//    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        
//        if !shouldShowSearchResults {
//            
//            shouldShowSearchResults = true
//            tableView.reloadData()
//            
//        }
//        
//        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchBar.resignFirstResponder()
//    }
    
//    func updateSearchResults(for searchController: UISearchController) {
//        
//        searchController.dimsBackgroundDuringPresentation = false
//        let searchString = searchController.searchBar.text
//        
//        // Filter the data array and get only those countries that match the search text.
//        filteredArray = years.filter({(year) -> Bool in
//            
//            //            print("country: \(country["name"])")
//            
//            let yearText: NSString = year as NSString
//            
//            print("country: \(yearText.range(of: searchString!, options: .caseInsensitive).location)")
//            
//            return (yearText.range(of: searchString!, options: .caseInsensitive).location) != NSNotFound
//        })
//        
//        //        filteredArray = countries.filter{$0["name"].string! == searchString}
//        
//        print("filtered array: \(filteredArray)")
//        
//        // Reload the tableview.
//        tableView.reloadData()
//    }
    
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
        

        cell.selectionStyle = .none
        cell.accessoryType = .checkmark
        
        if (indexPath as NSIndexPath).row % 2 == 0 {
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.6)
//            cell.backgroundColor = mainOrangeColor.withAlphaComponent(0.1)
            
        }
            
        else {
            
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.6)
            
        }
        
        if selectedYears.contains(years[(indexPath as NSIndexPath).row]) {
            cell.tintColor = mainOrangeColor
            cell.cartView.isHidden = false
        }
        
        else {
            
            cell.tintColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
            cell.cartView.isHidden = true
        }

        return cell
    }
    
    var latestIndexPath: IndexPath!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCountry = tableView.cellForRow(at: indexPath) as! AddYearsTableViewCell
//        searchBarSearchButtonClicked(searchController.searchBar)
        
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
                self.loader.hideOverlayView()
                if response.error != nil {
                    
                    print("error- \(response.error!.code): \(response.error!.localizedDescription)")
                }
                    
                 else if response["value"].bool! {
                    
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
    
    var quantity = 1
    var currentYear: String!
    var flag = 0
    
    @IBAction func addQuantity(_ sender: AnyObject) {
        
        print("in add quantity")
        currentYear = yearLabel.text
        quantity = quantity + 1
        
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

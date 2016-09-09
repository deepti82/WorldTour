import UIKit
import SwiftyJSON

class SelectCountryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var searchView: UIView!
//    var countries = ["India", "Kuwait", "Mumbai", "Australia", "Switzerland", "Hong Kong", "Malaysia", "Singapore", "Mauritius"]
    
    var countries: [JSON]!
    
    var selectedCountries: [String] = []
    
//    var years = ["2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009", "2008", "2007", "2006", "2005", "2004", "2003", "2002", "2001", "2000", "1999", "1998", "1997", "1996", "1995", "1994", "1993", "1992", "1991", "1990", "1989", "1988", "1987", "1986", "1985", "1984", "1983", "1982", "1981", "1980", "1979", "1978", "1977", "1976", "1975", "1974", "1973", "1972", "1971", "1970", "1969", "1968", "1967", "1966", "1965", "1964", "1963", "1962", "1961", "1960", "1959", "1958", "1957", "1956", "1955", "1954", "1953", "1952", "1951", "1950", "1949", "1948", "1947", "1946", "1945", "1944", "1943", "1942", "1941", "1940"]
    
    var selectedIndex: NSIndexPath = NSIndexPath()
    var isSelected: Bool = false
    var signUpCityVC: UIViewController!
    var searchFieldView: SearchFieldView!
    var selectedYear: String!
    var alreadySelected: [JSON]!
    
    internal var whichView: String!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var selectedNationality: String!
    
    var searchController: UISearchController!
    
    var filteredArray: [JSON]!
    
    var shouldShowSearchResults = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        
        let rightButton = UIButton()
        
        mainTableView.sectionIndexBackgroundColor = UIColor.clearColor()
        mainTableView.sectionIndexTrackingBackgroundColor = UIColor.clearColor()
        
        if whichView == "CountriesVisited" {
            
            rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
            rightButton.addTarget(self, action: #selector(SelectCountryViewController.addYear(_:)), forControlEvents: .TouchUpInside)
            rightButton.frame = CGRectMake(0, 8, 30, 30)
            
            self.customNavigationBar(leftButton, right: rightButton)
            
        }
        
        else if whichView == "BucketList" {
            
            self.title = "Bucket List"
            
//            rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
            rightButton.setTitle("Save", forState: .Normal)
            rightButton.titleLabel?.font = avenirFont
            rightButton.addTarget(self, action: #selector(SelectCountryViewController.saveNPop(_:)), forControlEvents: .TouchUpInside)
            rightButton.frame = CGRectMake(0, 10, 50, 30)
            
            self.customNavigationBar(leftButton, right: rightButton)
            
            self.view.backgroundColor = UIColor.whiteColor()
            
            print("already selected: \(alreadySelected)")
            
        }
        
        else if whichView == "selectNationality" {
            
            getDarkBackGroundBlur(self)
            rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
            rightButton.addTarget(self, action: #selector(SelectCountryViewController.chooseCity(_:)), forControlEvents: .TouchUpInside)
            rightButton.frame = CGRectMake(0, 0, 30, 30)
            
            self.customNavigationBar(leftButton, right: rightButton)
            
            
        }
        
        else if whichView == "addYear" {
            
//            getDarkBackGroundBlur(self)
            rightButton.setTitle("Save", forState: .Normal)
            rightButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 15)
            rightButton.addTarget(self, action: #selector(SelectCountryViewController.saveCountriesVisited(_:)), forControlEvents: .TouchUpInside)
            rightButton.frame = CGRectMake(0, 0, 70, 30)
            self.customNavigationBar(leftButton, right: rightButton)
            
            
        }
        
        searchFieldView = SearchFieldView(frame: CGRect(x: 10, y: 0, width: searchView.frame.width + 25, height: searchView.frame.height))
        searchFieldView.leftLine.backgroundColor = mainOrangeColor
        searchFieldView.rightLine.backgroundColor = mainOrangeColor
        searchFieldView.bottomLine.backgroundColor = mainOrangeColor
        searchFieldView.searchButton.tintColor = mainOrangeColor
        searchView.addSubview(searchFieldView)
        searchView.clipsToBounds = true
        searchView.backgroundColor = UIColor.clearColor()
        searchFieldView.searchField.returnKeyType = .Done
        searchFieldView.searchButton.addTarget(self, action: #selector(SelectCountryViewController.searchPlace(_:)), forControlEvents: .TouchUpInside)
        searchFieldView.searchField.delegate = self
        
        
        if whichView == "BucketList" {
            
//            print("currentUser: \(currentUser)")
//            if currentUser["homeCountry"] != nil {
//                searchFieldView.searchField.text = currentUser["homeCountry"].string!
//            }
//            else {
//                searchFieldView.searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
//            }
            
            request.getAllCountries({(response) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if response.error != nil {
                        
                        print("error: \(response.error?.localizedDescription)")
                        
                    }
                    
                    else {
                        
                        if response["value"] {
                            
                            self.countries = response["data"].array!
                            self.mainTableView.reloadData()
                            
                        }
                        else {
                            
                            print("error: \(response["data"])")
                        }
                        
                    }
                    
                    
                })
                
            })
            
        }
            
        if whichView == "CountriesVisited" {
            
            getCountries()
            
        }
            
        else {
            
            searchFieldView.searchField.placeholder = "Search"
            
        }
        
        configureSearchController()
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        print("search begin editing")
        searchController.dimsBackgroundDuringPresentation = true
        shouldShowSearchResults = true
        mainTableView.reloadData()
        
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        print("search cancelled")
        shouldShowSearchResults = false
        print("\(shouldShowSearchResults)")
        mainTableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        print("search button clicked")
        
        if !shouldShowSearchResults {
            
            shouldShowSearchResults = true
            mainTableView.reloadData()
            
        }
        
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        searchController.dimsBackgroundDuringPresentation = false
        let searchString = searchController.searchBar.text
        
        // Filter the data array and get only those countries that match the search text.
        filteredArray = countries.filter({(country) -> Bool in
            
//            print("country: \(country["name"])")
            
            let countryText: NSString = country["name"].string!
            
            print("country: \(countryText.rangeOfString(searchString!, options: .CaseInsensitiveSearch).location)")
            
            return (countryText.rangeOfString(searchString!, options: .CaseInsensitiveSearch).location) != NSNotFound
        })
        
//        filteredArray = countries.filter{$0["name"].string! == searchString}
        
        print("filtered array: \(filteredArray)")
        
        // Reload the tableview.
        mainTableView.reloadData()
    }
    
    func getCountries() {
        
        request.getAllCountries({(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error?.localizedDescription)")
                    
                }
                    
                else {
                    
                    if response["value"] {
                        
                        self.countries = response["data"].array!
                        self.mainTableView.reloadData()
                        
                    }
                    else {
                        
                        print("error: \(response["data"])")
                    }
                    
                }
                
                
            })
            
        })
        
    }
    
    func configureSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        mainTableView.tableHeaderView = searchController.searchBar
        
    }
    
    func saveCountriesVisited(sender: UIButton) {
        
        print("save countries visited: \(selectedCountries), \(selectedYear)")
        
        var listFormat: JSON = ["1", "2", "3"]
        var list: JSON = ["year": "2016", "times": 0]
        
        for i in 0 ..< selectedCountries.count {
            
            list["year"].string = selectedCountries[i]
//            list["countryId"] = JSON(selectedYear)
            list["times"] = 1
            print("list: \(list)")
            listFormat[i] = list
            
        }
        print("list format: \(listFormat)")
        
        request.addCountriesVisited(currentUser["_id"].string!, list: listFormat, countryVisited: selectedYear, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error- \(response.error!.code): \(response.error!.localizedDescription)")
                }
                    
                else if response["value"] {
                    
                    print("response arrived")
//                    let total = self.navigationController?.viewControllers
                    let prevVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileVC") as! ProfileViewController
//                    prevVC.tableView.reloadData()
                    self.navigationController?.pushViewController(prevVC, animated: false)
                    
                }
                    
                else {
                    
                    print("response error: \(response["data"])")
                    
                }
            })
        })
        
    }
    
    func saveNPop(sender: UIButton) {
        
        var prevBucketCount = 0
        if alreadySelected != nil {
            
            prevBucketCount = 1
            
        }
        
        request.updateBucketList(currentUser["_id"].string!, list: selectedCountries, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error- \(response.error!.code): \(response.error!.localizedDescription)")
                }
                    
                else if response["value"] {
                    
                    print("response arrived")
                    let total = self.navigationController?.viewControllers
                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("bucketList") as! BucketListTableViewController
                    if prevBucketCount == 0 {
                        
//                        print("to pop: \(total![total!.count - 2])")
//                        print("vc: \(BucketListTableViewController())")
                        vc.whichView = "BucketList"
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    else {
                        
                        print("coming")
                        let prevVC = total![total!.count - 2] as! BucketListTableViewController
                        prevVC.whichView = "BucketList"
                        prevVC.getBucketList()
                        prevVC.tableView.reloadData()
                        self.navigationController?.popViewControllerAnimated(true)
                        
                    }
                    
                }
                    
                else {
                    
                    print("response error: \(response["data"])")
                    
                }
            })
        })
    }
    
    func searchPlace(sender: UIButton) {
        
        print("in search button target")
        searchFieldView.searchField.resignFirstResponder()
        
    }
    
    func chooseCity(sender: UIButton) {
        
        //Add did select functionality
        
//        request.editUser(currentUser["_id"].string!, editField: "homeCountry", editFieldValue: selectedNationality, completion: {(response) in
//            
//            dispatch_async(dispatch_get_main_queue(), {
//                
//                if response.error != nil {
//                    
//                    print("error: \(response.error?.localizedDescription)")
//                }
//                else if response["value"] == false {
//                    
//                    ("error: \(response["data"])")
//                    
//                }
//                else {
//                    
//                    self.signUpCityVC = self.storyboard?.instantiateViewControllerWithIdentifier("chooseCity") as! ChooseCityViewController
//                    self.navigationController?.pushViewController(self.signUpCityVC, animated: true)
//                }
//                
//            })
//        })
        
        self.signUpCityVC = self.storyboard?.instantiateViewControllerWithIdentifier("chooseCity") as! ChooseCityViewController
        self.navigationController?.pushViewController(self.signUpCityVC, animated: true)
        
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        textField.resignFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCountry = tableView.cellForRowAtIndexPath(indexPath) as! CountriesTableViewCell
        //searchBarSearchButtonClicked(searchController.searchBar)
        
        if whichView == "addYear" {
            
            if selectedCountry.tintColor == mainOrangeColor {
                
                selectedCountry.tintColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
                
                if shouldShowSearchResults && filteredArray != nil {
                    
//                    selectedCountries = selectedCountries.filter{$0 != filteredArray[indexPath.row]["_id"].string!}
                }
                else {
                    
//                    selectedCountries = selectedCountries.filter{$0 != years[indexPath.row]}
                }
                
                print("selected countries: \(selectedCountries)")
//                print("selected countries: \(countries[indexPath.row]["_id"].string!)")
                
            }
                
            else {
                
                selectedCountry.tintColor = mainOrangeColor
                
                if shouldShowSearchResults && filteredArray != nil {
                    
//                    selectedCountries.append(filteredArray[indexPath.row])
                }
                else {
                    
//                    selectedCountries.append(years[indexPath.row])
                }
                
//                print("selected countries: \(selectedCountries)")
//                print("selected countries: \(countries[indexPath.row]["_id"].string!)")
                
            }
            
        }
        
        else if whichView == "BucketList" {
            
//            searchBarCancelButtonClicked(searchController.searchBar)
            
            if selectedCountry.tintColor == mainOrangeColor && !alreadySelected.contains(countries[indexPath.row]) {
                
                selectedCountry.tintColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
                
                if shouldShowSearchResults && filteredArray != nil {
                    
                    selectedCountries = selectedCountries.filter{$0 != filteredArray[indexPath.row]["_id"].string!}
                }
                else {
                    
                    selectedCountries = selectedCountries.filter{$0 != countries[indexPath.row]["_id"].string!}
                }
                
                print("selected countries: \(selectedCountries)")
                print("selected countries: \(countries[indexPath.row]["_id"].string!)")
                
            }
                
            else {
                
                selectedCountry.tintColor = mainOrangeColor
                
                print("search: \(shouldShowSearchResults), \(filteredArray)")
                
                if shouldShowSearchResults && filteredArray != nil {
                    
                    print("in the filter array")
                    selectedCountries.append(filteredArray[indexPath.row]["_id"].string!)
                }
                else {
                    
                    selectedCountries.append(countries[indexPath.row]["_id"].string!)
                }
                
            }
            
        }
            
//        else  {
//            
//            if selectedCountry.tintColor == UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1) {
//                
//                selectedCountry.tintColor = mainOrangeColor
//                selectedYear = years[indexPath.row]
//                
//            }
//            
//        }
        
        else if whichView == "CountriesVisited" {
            
//            if selectedCountry.tintColor == mainOrangeColor {
//                
//                selectedCountry.tintColor = UIColor.lightGrayColor()
//                selectedYear = ""
//                isSelected = false
//                
//            }
            
            if isSelected == true {
                
                let prevSelected = tableView.cellForRowAtIndexPath(selectedIndex) as! CountriesTableViewCell
                //            prevSelected?.backgroundColor = UIColor.lightGrayColor()
                prevSelected.tintColor = UIColor.lightGrayColor()
                
                selectedCountry.tintColor = mainOrangeColor
//                selectedNationality = selectedCountry.countryName.text
                if shouldShowSearchResults && filteredArray != nil {
                    
                    selectedYear = filteredArray[indexPath.row]["_id"].string!
                }
                else {
                    
                    selectedYear = countries[indexPath.row]["_id"].string!
                }
                
                print("selected countries \(selectedYear)")
                selectedIndex = indexPath
            }
                
            else {
                
                selectedCountry.tintColor = mainOrangeColor
                selectedIndex = indexPath
                isSelected = true
                if shouldShowSearchResults && filteredArray != nil {
                    
                    selectedYear = filteredArray[indexPath.row]["_id"].string!
                }
                else {
                    
                    selectedYear = countries[indexPath.row]["_id"].string!
                }
                
                
                print("selected countries \(selectedYear)")
//                selectedNationality = selectedCountry.countryName.text
                
            }
            
            addYear(nil)
        }
        
    }
    
    func addYear(sender: UIButton?) {
        
//        let nextVC = storyboard?.instantiateViewControllerWithIdentifier("SelectCountryVC") as! SelectCountryViewController
//        nextVC.whichView = "addYear"
//        nextVC.selectedYear = selectedYear
//        self.navigationController?.pushViewController(nextVC, animated: true)
        
        let nextVC = storyboard?.instantiateViewControllerWithIdentifier("addYears") as! AddYearsCountriesVisitedTableViewController
        nextVC.selectedCountry = selectedYear
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! CountriesTableViewCell
//        cell.flagImage.image = UIImage(named: "indian_flag")
        
//        if whichView == "addYear" {
//            
//            cell.flagImage.hidden = true
//            cell.countryName.text = years[indexPath.row]
//            
//        }
        
        if countries != nil {
            
            if shouldShowSearchResults && filteredArray != nil {
                
                cell.countryName.text = filteredArray[indexPath.row]["name"].string!
                
            }
            
            else {
                
                cell.countryName.text = countries[indexPath.row]["name"].string!
                
            }
            
//            print("filtered array: \(filteredArray)")
            
//            if shouldShowSearchResults && filteredArray != nil {
//                
//                if selectedCountries.contains(filteredArray[indexPath.row]["_id"].string!) {
//                    
//                    cell.tintColor = mainOrangeColor
//                    
//                }
//                
//                else if alreadySelected.contains(filteredArray[indexPath.row]) {
//                    
//                    cell.tintColor = mainOrangeColor
//                    
//                }
//                
//            }
            
//            else if alreadySelected.contains(filteredArray[indexPath.row]["_id"].string!) && (shouldShowSearchResults && filteredArray != nil) {
//                
//                cell.tintColor = mainOrangeColor
//                
//            }
            
//            else if selectedCountries.contains(filteredArray[indexPath.row]["_id"].string!) {
//                
//                if indexPath.row == 0 {
//                    
//                    print("in here \(filteredArray[indexPath.row]["_id"].string!)")
//                    
//                }
//                
//                cell.tintColor = mainOrangeColor
//                
//            }
            
            if alreadySelected != nil && alreadySelected.contains(countries[indexPath.row]) && !shouldShowSearchResults {
                
                print("already selected contains \(countries[indexPath.row])")
                cell.tintColor = mainOrangeColor
            }
            
            else if selectedCountries.contains(countries[indexPath.row]["_id"].string!) && !shouldShowSearchResults {
                
                cell.tintColor = mainOrangeColor
                
            }
            
            else {
                
                cell.tintColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
                
            }
        }

        
        cell.accessoryType = .Checkmark
        if indexPath.row % 2 == 0 {
            
            if whichView == "selectNationality" {
                
                cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.4)
                
            }
            
            else {
                
                cell.backgroundColor = mainOrangeColor.colorWithAlphaComponent(0.1)
            }
            
        }
        
        else {
            
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if countries != nil  {
            
            if shouldShowSearchResults && filteredArray != nil {
                
                return filteredArray.count
            }
            
            return countries.count
            
        }
//        else if whichView == "addYear" {
//            
//            return years.count
//            
//        }
        
        return 0
        
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        
//        let indexLetters =
//        let indexOfLetters = indexLetters.componentsSeparatedByString(" ")
        
        if whichView == "addYear" {
            return nil
        }
        
        var indexOfLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "X", "Y", "Z"]
        
        if countries != nil {
            for country in countries {
                
                indexOfLetters.append(String(country["name"].string!.characters.first!))
                
            }
            
            indexOfLetters = Array(Set(indexOfLetters))
            indexOfLetters = indexOfLetters.sort()
        }
        return indexOfLetters
        
    }

}

class CountriesTableViewCell: UITableViewCell {

    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var countryName: UILabel!
//    @IBOutlet weak var checkboxImage: UIButton!

}


import UIKit


class SelectCountryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var searchView: UIView!
//    var countries = ["India", "Kuwait", "Mumbai", "Australia", "Switzerland", "Hong Kong", "Malaysia", "Singapore", "Mauritius"]
    
    var countries: [JSON]!
    
    var selectedCountries: [String] = []

    var selectedIndex: IndexPath = IndexPath()
    var isSelected: Bool = false
    var signUpCityVC: UIViewController!
    var searchFieldView: SearchFieldView!
    var selectedYear: String!
    var alreadySelected: [JSON]!
    var loader = LoadingOverlay()
    internal var whichView: String!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var selectedNationality: String!
    
    var searchController: UISearchController!
    
    var filteredArray: [JSON]!
    
    var shouldShowSearchResults = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.showOverlay(self.view)
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        
        mainTableView.sectionIndexBackgroundColor = UIColor.clear
        mainTableView.sectionIndexTrackingBackgroundColor = UIColor.clear
        
        if whichView == "CountriesVisited" {
             self.title = "Countries Visited"
            self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]

            rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
            rightButton.addTarget(self, action: #selector(SelectCountryViewController.addYear(_:)), for: .touchUpInside)
            rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
            
            self.customNavigationBar(left: leftButton, right: rightButton)
            
        }
        
        else if whichView == "BucketList" {
            
            self.title = "Bucket List"
            self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]

//            rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
            rightButton.setTitle("Save", for: UIControlState())
            rightButton.titleLabel?.font = avenirFont
            rightButton.addTarget(self, action: #selector(SelectCountryViewController.saveNPop(_:)), for: .touchUpInside)
            rightButton.frame = CGRect(x: 0, y: 10, width: 50, height: 30)
            
            self.customNavigationBar(left: leftButton, right: rightButton)
            
            self.view.backgroundColor = UIColor.white
            
            print("already selected: \(alreadySelected)")
            
        }
        
        else if whichView == "selectNationality" {
             self.title = "Countries Visited"
            self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]

            getDarkBackGroundBlur(self)
            rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
            rightButton.addTarget(self, action: #selector(SelectCountryViewController.chooseCity(_:)), for: .touchUpInside)
            rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            
            self.customNavigationBar(left: leftButton, right: rightButton)
            
            
        }
        
        else if whichView == "addYear" {
            
//            getDarkBackGroundBlur(self)
            rightButton.setTitle("Save", for: UIControlState())
            rightButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 15)
            rightButton.addTarget(self, action: #selector(SelectCountryViewController.saveCountriesVisited(_:)), for: .touchUpInside)
            rightButton.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
            self.customNavigationBar(left: leftButton, right: rightButton)
            
            
        }
        
        searchFieldView = SearchFieldView(frame: CGRect(x: 10, y: 0, width: searchView.frame.width + 25, height: searchView.frame.height))
        searchFieldView.leftLine.backgroundColor = mainOrangeColor
        searchFieldView.rightLine.backgroundColor = mainOrangeColor
        searchFieldView.bottomLine.backgroundColor = mainOrangeColor
        searchFieldView.searchButton.tintColor = mainOrangeColor
        searchView.addSubview(searchFieldView)
        searchView.clipsToBounds = true
        searchView.backgroundColor = UIColor.clear
        searchFieldView.searchField.returnKeyType = .done
        searchFieldView.searchButton.addTarget(self, action: #selector(SelectCountryViewController.searchPlace(_:)), for: .touchUpInside)
        searchFieldView.searchField.delegate = self
        
        
        if whichView == "BucketList" {
            
            request.getAllCountries({(response) in
                
                DispatchQueue.main.async(execute: {
                    self.loader.hideOverlayView()
                    if response.error != nil {
                        
                        print("error: \(response.error?.localizedDescription)")
                        
                    }
                    
                    else {
                        
                        if response["value"].bool! {
                            
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        print("search begin editing")
        searchController.dimsBackgroundDuringPresentation = true
        shouldShowSearchResults = true
        mainTableView.reloadData()
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        print("search cancelled")
        shouldShowSearchResults = false
        print("\(shouldShowSearchResults)")
        mainTableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print("search button clicked")
        
        if !shouldShowSearchResults {
            
            shouldShowSearchResults = true
            mainTableView.reloadData()
            
        }
        
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        searchController.dimsBackgroundDuringPresentation = false
        let searchString = searchController.searchBar.text
            filteredArray = countries.filter({(country) -> Bool in
            let countryText: NSString = country["name"].string! as NSString
            return (countryText.range(of: searchString!, options: .caseInsensitive).location) != NSNotFound
        })
        
        print("filtered array: \(filteredArray)")
        
        mainTableView.reloadData()
    }
    
    func getCountries() {
        
        request.getAllCountries({(response) in
            
            DispatchQueue.main.async(execute: {
                self.loader.hideOverlayView()
                if response.error != nil {
                    
                    print("error: \(response.error?.localizedDescription)")
                    
                }
                    
                else {
                    
                    if response["value"].bool! {
                        
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
    
    func saveCountriesVisited(_ sender: UIButton) {
        
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
            
            DispatchQueue.main.async(execute: {
                self.loader.hideOverlayView()
                if response.error != nil {
                    
                    print("error- \(response.error!.code): \(response.error!.localizedDescription)")
                }
                    
                else if response["value"].bool! {
                    
                    print("response arrived")
//                    let total = self.navigationController?.viewControllers
                    let prevVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
//                    prevVC.tableView.reloadData()
                    self.navigationController?.pushViewController(prevVC, animated: false)
                    
                }
                    
                else {
                    
                    print("response error: \(response["data"])")
                    
                }
            })
        })
        
    }
    
    func saveNPop(_ sender: UIButton) {
        
        var prevBucketCount = 0
        if alreadySelected != nil {
            
            prevBucketCount = 1
            
        }
        
        request.updateBucketList(currentUser["_id"].string!, list: selectedCountries, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                self.loader.hideOverlayView()
                if response.error != nil {
                    
                    print("error- \(response.error!.code): \(response.error!.localizedDescription)")
                }
                    
                else if response["value"].bool! {
                    
                    print("response arrived")
                    let total = self.navigationController?.viewControllers
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "bucketList") as! BucketListTableViewController
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
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                    
                }
                    
                else {
                    
                    print("response error: \(response["data"])")
                    
                }
            })
        })
    }
    
    func searchPlace(_ sender: UIButton) {
        
        print("in search button target")
        searchFieldView.searchField.resignFirstResponder()
        
    }
    
    func chooseCity(_ sender: UIButton) {
        
        self.signUpCityVC = self.storyboard?.instantiateViewController(withIdentifier: "chooseCity") as! ChooseCityViewController
        self.navigationController?.pushViewController(self.signUpCityVC, animated: true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCountry = tableView.cellForRow(at: indexPath) as! CountriesTableViewCell
        searchBarSearchButtonClicked(searchController.searchBar)
        
        if whichView == "addYear" {
            
            if selectedCountry.tintColor == mainOrangeColor {
                
                selectedCountry.tintColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
                
                if filteredArray != nil {
                    
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
                
                if filteredArray != nil {
                    
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
            
            if selectedCountry.tintColor == mainOrangeColor && !alreadySelected.contains(countries[(indexPath as NSIndexPath).row]) {
                
                selectedCountry.tintColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
                
                if  shouldShowSearchResults && filteredArray != nil {
                    
                    selectedCountries = selectedCountries.filter{$0 != filteredArray[(indexPath as NSIndexPath).row]["_id"].string!}
                }
                else {
                    
                    selectedCountries = selectedCountries.filter{$0 != countries[(indexPath as NSIndexPath).row]["_id"].string!}
                }
                
                print("selected countries: \(selectedCountries)")
                print("selected countries: \(countries[(indexPath as NSIndexPath).row]["_id"].string!)")
                
            }
                
            else {
                
                selectedCountry.tintColor = mainOrangeColor
                
                print("search: \(shouldShowSearchResults), \(filteredArray)")
                
                if  shouldShowSearchResults && filteredArray != nil {
                    
                    print("in the filter array")
                    selectedCountries.append(filteredArray[(indexPath as NSIndexPath).row]["_id"].string!)
                }
                else {
                    
                    selectedCountries.append(countries[(indexPath as NSIndexPath).row]["_id"].string!)
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
                
                let prevSelected = tableView.cellForRow(at: selectedIndex) as! CountriesTableViewCell
                //            prevSelected?.backgroundColor = UIColor.lightGrayColor()
                prevSelected.tintColor = UIColor.lightGray
                
                selectedCountry.tintColor = mainOrangeColor
//                selectedNationality = selectedCountry.countryName.text
                 if filteredArray != nil {
                    
                    selectedYear = filteredArray[(indexPath as NSIndexPath).row]["_id"].string!
                }
                else {
                    
                    selectedYear = countries[(indexPath as NSIndexPath).row]["_id"].string!
                }
                
                print("selected countries \(selectedYear)")
                selectedIndex = indexPath
            }
                
            else {
                
                selectedCountry.tintColor = mainOrangeColor
                selectedIndex = indexPath
                isSelected = true
                if  filteredArray != nil {
                    
                    selectedYear = filteredArray[(indexPath as NSIndexPath).row]["_id"].string!
                }
                else {
                    
                    selectedYear = countries[(indexPath as NSIndexPath).row]["_id"].string!
                }
                
                
                print("selected countries \(selectedYear)")
//                selectedNationality = selectedCountry.countryName.text
                
            }
            
            addYear(nil)
        }
        
    }
    
    func addYear(_ sender: UIButton?) {
        
//        let nextVC = storyboard?.instantiateViewControllerWithIdentifier("SelectCountryVC") as! SelectCountryViewController
//        nextVC.whichView = "addYear"
//        nextVC.selectedYear = selectedYear
//        self.navigationController?.pushViewController(nextVC, animated: true)
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "addYears") as! AddYearsCountriesVisitedTableViewController
        nextVC.selectedCountry = selectedYear
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CountriesTableViewCell
//        cell.flagImage.image = UIImage(named: "indian_flag")
        
//        if whichView == "addYear" {
//            
//            cell.flagImage.hidden = true
//            cell.countryName.text = years[indexPath.row]
//            
//        }
        
                if countries != nil {
            

             if shouldShowSearchResults && filteredArray != nil {
                
                if(filteredArray.count > indexPath.row) {
                    cell.countryName.text = filteredArray[(indexPath as NSIndexPath).row]["name"].string!
                    cell.flagImage.hnk_setImageFromURL(getImageURL(filteredArray[indexPath.row]["flag"].stringValue,width:100))
                }
            }
            else {
                print(countries[(indexPath as NSIndexPath).row])
                cell.countryName.text = countries[(indexPath as NSIndexPath).row]["name"].string!
                cell.flagImage.hnk_setImageFromURL(getImageURL(countries[indexPath.row]["flag"].stringValue,width:100))

            }
            
            
            if alreadySelected != nil && alreadySelected.contains(countries[(indexPath as NSIndexPath).row]) {
                
                print("already selected contains \(countries[(indexPath as NSIndexPath).row])")
                cell.tintColor = mainOrangeColor
            }
            
            else if selectedCountries.contains(countries[(indexPath as NSIndexPath).row]["_id"].string!) {
                
                cell.tintColor = mainOrangeColor
                
            }
            
            else {
                
                cell.tintColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
                
            }
        }

        
        cell.accessoryType = .checkmark
        if (indexPath as NSIndexPath).row % 2 == 0 {
            
            if whichView == "selectNationality" {
                
                cell.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                
            }
            
            else {
                
                cell.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            }
            
        }
        
        else {
            
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.6)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  countries != nil  {
            
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
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
//        let indexLetters =
//        let indexOfLetters = indexLetters.componentsSeparatedByString(" ")
        
        if whichView == "addYear" {
            return nil
        }
        
//        var indexOfLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "X", "Y", "Z"]
        
        if countries != nil {
            for country in countries {
                
//                indexOfLetters.append(String(country["name"].string!.characters.first!))
                
            }
            
//            indexOfLetters = Array(Set(indexOfLetters))
//            indexOfLetters = indexOfLetters.sorted()
        }
        return nil
        
    }
    func setImage(_ imageView: UIImageView, imageName: String) {
        
        let isUrl = verifyUrl(imageName)
        print("isUrl: \(isUrl)")
        
        if imageName == "" {
            
            imageView.image = UIImage(named: "profile_icon")
            makeTLProfilePictureFollowers(imageView)
            
        }
            
        else if isUrl {
            imageView.hnk_setImageFromURL(URL(string: imageName)!)
            makeTLProfilePictureFollowers(imageView)
        }
            
        else {
            
            let getImageUrl = adminUrl + "upload/readFile?file=" + imageName + "&width=200"
            
            print("getImageUrl: \(getImageUrl)")
            
            imageView.hnk_setImageFromURL(URL(string: getImageUrl)!)
            makeTLProfilePictureFollowers(imageView)
        }
    }


}

class CountriesTableViewCell: UITableViewCell {

    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var countryName: UILabel!
//    @IBOutlet weak var checkboxImage: UIButton!

}


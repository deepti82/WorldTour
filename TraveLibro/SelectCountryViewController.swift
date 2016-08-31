import UIKit
import SwiftyJSON

class SelectCountryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var searchView: UIView!
//    var countries = ["India", "Kuwait", "Mumbai", "Australia", "Switzerland", "Hong Kong", "Malaysia", "Singapore", "Mauritius"]
    
    var countries: [JSON]!
    
    var selectedCountries: [String] = []
    
    var years = ["2016", "2015", "2014", "2013", "2012"]
    
    var selectedIndex: NSIndexPath = NSIndexPath()
    var isSelected: Bool = false
    var signUpCityVC: UIViewController!
    var searchFieldView: SearchFieldView!
    var selectedYear: String!
    var alreadySelected: [JSON]!

    
    internal var whichView: String!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var selectedNationality: String!
    
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
            
//        if whichView == "addYear" {
//            
////            request.getAllCountries({(response) in
////                
////                dispatch_async(dispatch_get_main_queue(), {
////                    
////                    if response.error != nil {
////                        
////                        print("error: \(response.error?.localizedDescription)")
////                        
////                    }
////                        
////                    else {
////                        
////                        if response["value"] {
////                            
////                            self.countries = response["data"].array!
////                            self.mainTableView.reloadData()
////                            
////                        }
////                        else {
////                            
////                            print("error: \(response["data"])")
////                        }
////                        
////                    }
////                    
////                    
////                })
////                
////            })
//            
//        }
        
        else {
            
            searchFieldView.searchField.placeholder = "Search"
            
        }
        
    }
    
    func saveCountriesVisited(sender: UIButton) {
        
        print("save countries visited: \(selectedCountries), \(selectedYear)")
        
        var listFormat: [NSDictionary] = []
        let list: NSMutableDictionary = [:]
        
        for country in selectedCountries {
            
            list["year"] = selectedYear
            list["countryId"] = country
            listFormat.append(list)
            
        }
        print("list format: \(listFormat)")
        
        request.addCountriesVisited(currentUser["_id"].string!, list: listFormat, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error- \(response.error!.code): \(response.error!.localizedDescription)")
                }
                    
                else if response["value"] {
                    
                    print("response arrived")
                    let total = self.navigationController?.viewControllers
                    let prevVC = total![total!.count - 3] as! BucketListTableViewController
                    prevVC.tableView.reloadData()
                    self.navigationController?.popViewControllerAnimated(true)
                    
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
        
        
        if whichView == "CountriesVisited" {
            
            if selectedCountry.tintColor == mainOrangeColor {
                
                selectedCountry.tintColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
                selectedCountries = selectedCountries.filter{$0 != countries[indexPath.row]["_id"].string!}
                print("selected countries: \(selectedCountries)")
                print("selected countries: \(countries[indexPath.row]["_id"].string!)")
                
            }
                
            else {
                
                selectedCountry.tintColor = mainOrangeColor
                selectedCountries.append(countries[indexPath.row]["_id"].string!)
                print("selected countries: \(selectedCountries)")
                print("selected countries: \(countries[indexPath.row]["_id"].string!)")
                
            }
            
        }
        
        else if whichView == "BucketList" {
            
            if selectedCountry.tintColor == mainOrangeColor {
                
                selectedCountry.tintColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
                selectedCountries = selectedCountries.filter{$0 != countries[indexPath.row]["_id"].string!}
                print("selected countries: \(selectedCountries)")
                print("selected countries: \(countries[indexPath.row]["_id"].string!)")
                
            }
                
            else {
                
                selectedCountry.tintColor = mainOrangeColor
                selectedCountries.append(countries[indexPath.row]["_id"].string!)
                print("selected countries: \(selectedCountries)")
                print("selected countries: \(countries[indexPath.row]["_id"].string!)")
                
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
        
        else if whichView == "addYear" {
            
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
                selectedYear = years[indexPath.row]
                selectedIndex = indexPath
            }
                
            else {
                
                selectedCountry.tintColor = mainOrangeColor
                selectedIndex = indexPath
                isSelected = true
                selectedYear = years[indexPath.row]
//                selectedNationality = selectedCountry.countryName.text
                
            }
            
        }
        
    }
    
    
    
    func addYear(sender: UIButton) {
        
        let nextVC = storyboard?.instantiateViewControllerWithIdentifier("SelectCountryVC") as! SelectCountryViewController
        nextVC.whichView = "addYear"
        nextVC.selectedCountries = selectedCountries
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! CountriesTableViewCell
//        cell.flagImage.image = UIImage(named: "indian_flag")
        
        if whichView == "addYear" {
            
            cell.flagImage.hidden = true
            cell.countryName.text = years[indexPath.row]
            
        }
        
        if countries != nil {
            
            cell.countryName.text = countries[indexPath.row]["name"].string!
            if alreadySelected != nil && alreadySelected.contains(countries[indexPath.row]) {
                
                print("already selected contains \(countries[indexPath.row])")
                cell.tintColor = mainOrangeColor
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
            
            return countries.count
            
        }
        else if whichView == "addYear" {
            
            return years.count
            
        }
        
        return 0
        
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        
//        let indexLetters =
//        let indexOfLetters = indexLetters.componentsSeparatedByString(" ")
        
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


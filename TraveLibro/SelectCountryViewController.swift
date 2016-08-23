//
//  SelectCountryViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftyJSON

class SelectCountryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var searchView: UIView!
//    var countries = ["India", "Kuwait", "Mumbai", "Australia", "Switzerland", "Hong Kong", "Malaysia", "Singapore", "Mauritius"]
    
    var countries: [JSON]!
    
    var selectedIndex: NSIndexPath = NSIndexPath()
    var isSelected: Bool = false
    var signUpCityVC: UIViewController!
    var searchFieldView: SearchFieldView!
    
    internal var whichView: String!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var selectedNationality: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGroundBlur(self)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        
        let rightButton = UIButton()
        
        mainTableView.sectionIndexBackgroundColor = UIColor.clearColor()
        mainTableView.sectionIndexTrackingBackgroundColor = UIColor.clearColor()
        
        if whichView == "addCountries" {
            
            rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
            rightButton.addTarget(self, action: #selector(SelectCountryViewController.addYear(_:)), forControlEvents: .TouchUpInside)
            rightButton.frame = CGRectMake(0, 8, 30, 30)
            
            self.customNavigationBar(leftButton, right: rightButton)
            
        }
        
        else if whichView == "selectNationality" {
            
            rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
            rightButton.addTarget(self, action: #selector(SelectCountryViewController.chooseCity(_:)), forControlEvents: .TouchUpInside)
            rightButton.frame = CGRectMake(0, 0, 30, 30)
            
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
        
        
        if whichView == "selectNationality" {
            
            print("currentUser: \(currentUser)")
            if currentUser["homeCountry"] != nil {
                searchFieldView.searchField.text = currentUser["homeCountry"].string!
            }
            else {
                searchFieldView.searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            }
            
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
        else {
            
            searchFieldView.searchField.placeholder = "Search"
            
        }
        
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
        
        
        if whichView == "addCountries" {
            
            if selectedCountry.tintColor == mainOrangeColor {
                
                selectedCountry.tintColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
                
            }
                
            else {
                
                selectedCountry.tintColor = mainOrangeColor
                
            }
            
        }
        
        else {
            
            if selectedCountry.tintColor == mainOrangeColor {
                
                selectedCountry.tintColor = UIColor.lightGrayColor()
                selectedNationality = ""
                isSelected = false
                
            }
                
            else if isSelected == true {
                
                let prevSelected = tableView.cellForRowAtIndexPath(selectedIndex) as! CountriesTableViewCell
                //            prevSelected?.backgroundColor = UIColor.lightGrayColor()
                prevSelected.tintColor = UIColor.lightGrayColor()
                
                selectedCountry.tintColor = mainOrangeColor
                selectedNationality = selectedCountry.countryName.text
                selectedIndex = indexPath
            }
                
            else {
                
                selectedCountry.tintColor = mainOrangeColor
                selectedIndex = indexPath
                isSelected = true
                selectedNationality = selectedCountry.countryName.text
                
            }
            
        }
        
    }
    
    
    
    func addYear(sender: UIButton) {
        
        let nextVC = storyboard?.instantiateViewControllerWithIdentifier("SelectCountryVC") as! SelectCountryViewController
        nextVC.whichView = ""
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! CountriesTableViewCell
        cell.flagImage.image = UIImage(named: "indian_flag")
        
        if countries != nil {
            
            cell.countryName.text = countries[indexPath.row]["name"].string!
            
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


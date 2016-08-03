//
//  SelectCountryViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SelectCountryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchView: UIView!
    var countries = ["India", "Kuwait", "Mumbai", "Australia", "Switzerland", "Hong Kong", "Malaysia", "Singapore", "Mauritius"]
    
    var selectedIndex: NSIndexPath = NSIndexPath()
    var isSelected: Bool = false
    var signUpCityVC: UIViewController!
    
    internal var whichView: String!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    
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
        
        let searchFieldView = SearchFieldView(frame: CGRect(x: 10, y: 0, width: searchView.frame.width + 25, height: searchView.frame.height))
        searchFieldView.leftLine.backgroundColor = mainOrangeColor
        searchFieldView.rightLine.backgroundColor = mainOrangeColor
        searchFieldView.bottomLine.backgroundColor = mainOrangeColor
        searchFieldView.searchButton.tintColor = mainOrangeColor
        searchView.addSubview(searchFieldView)
        searchView.backgroundColor = UIColor.clearColor()
        
        if whichView == "selectNationality" {
            
            searchFieldView.searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            
        }
        else {
            
            searchFieldView.searchField.placeholder = "Search"
            
        }
        
    }
    
    func chooseCity(sender: UIButton) {
        
        signUpCityVC = storyboard?.instantiateViewControllerWithIdentifier("chooseCity") as! ChooseCityViewController
        self.navigationController?.pushViewController(signUpCityVC, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCountry = tableView.cellForRowAtIndexPath(indexPath)
        
        if whichView == "addCountries" {
            
            if selectedCountry?.tintColor == mainOrangeColor {
                
                selectedCountry?.tintColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
                
            }
                
            else {
                
                selectedCountry?.tintColor = mainOrangeColor
                
            }
            
        }
        
        else {
            
            if selectedCountry?.tintColor == mainOrangeColor {
                
                selectedCountry?.tintColor = UIColor.lightGrayColor()
                //            selectedCountry?.backgroundColor = UIColor.lightGrayColor()
                isSelected = false
                
            }
                
            else if isSelected == true {
                
                let prevSelected = tableView.cellForRowAtIndexPath(selectedIndex)
                //            prevSelected?.backgroundColor = UIColor.lightGrayColor()
                prevSelected?.tintColor = UIColor.lightGrayColor()
                
                selectedCountry?.tintColor = mainOrangeColor
                //            selectedCountry?.backgroundColor = mainOrangeColor
                selectedIndex = indexPath
            }
                
            else {
                
                selectedCountry?.tintColor = mainOrangeColor
                //            selectedCountry?.backgroundColor = mainOrangeColor
                selectedIndex = indexPath
                isSelected = true
                
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
        cell.countryName.text = countries[indexPath.item]
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
        
        return countries.count
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        
//        let indexLetters = "A B C D E F G H I J K L M N O P Q R S T U V X Y Z"
//        let indexOfLetters = indexLetters.componentsSeparatedByString(" ")
        
        var indexOfLetters = [String]()
        for string in countries {
            
            indexOfLetters.append(String(string.characters.first!))
            
        }
        
        indexOfLetters = Array(Set(indexOfLetters))
        indexOfLetters = indexOfLetters.sort()
        return indexOfLetters
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class CountriesTableViewCell: UITableViewCell {

    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var countryName: UILabel!
//    @IBOutlet weak var checkboxImage: UIButton!

}


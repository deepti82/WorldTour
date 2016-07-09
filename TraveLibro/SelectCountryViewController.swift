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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if whichView == "addCountries" {
            
            let leftButton = UIButton()
            leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
            leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
            leftButton.frame = CGRectMake(0, 0, 30, 30)
            
            let rightButton = UIButton()
            rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
            rightButton.addTarget(self, action: #selector(SelectCountryViewController.addYear(_:)), forControlEvents: .TouchUpInside)
            rightButton.frame = CGRectMake(0, 0, 30, 30)
            
            self.customNavigationBar(leftButton, right: rightButton)
            
        }
        
        let searchFieldView = SearchFieldView(frame: CGRect(x: 0, y: 0, width: searchView.frame.width + 60, height: searchView.frame.height))
        searchFieldView.leftLine.backgroundColor = mainOrangeColor
        searchFieldView.rightLine.backgroundColor = mainOrangeColor
        searchFieldView.bottomLine.backgroundColor = mainOrangeColor
        searchFieldView.searchButton.tintColor = mainOrangeColor
        searchFieldView.searchField.placeholder = "Search"
        searchView.addSubview(searchFieldView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCountry = tableView.cellForRowAtIndexPath(indexPath)
        
        if whichView == "addCountries" {
            
            if selectedCountry?.accessoryType == .Checkmark {
                
                selectedCountry?.accessoryType = .None
                
            }
                
            else {
                
                selectedCountry?.accessoryType = .Checkmark
                
            }
            
        }
        
        else {
            
            if selectedCountry?.accessoryType == .Checkmark {
                
                selectedCountry?.accessoryType = .None
                //            selectedCountry?.backgroundColor = UIColor.lightGrayColor()
                isSelected = false
                
                signUpCityVC = storyboard?.instantiateViewControllerWithIdentifier("chooseCity") as! ChooseCityViewController
                self.navigationController?.pushViewController(signUpCityVC, animated: true)
                
                
            }
                
            else if isSelected == true {
                
                let prevSelected = tableView.cellForRowAtIndexPath(selectedIndex)
                //            prevSelected?.backgroundColor = UIColor.lightGrayColor()
                prevSelected?.accessoryType = .None
                
                selectedCountry?.accessoryType = .Checkmark
                //            selectedCountry?.backgroundColor = mainOrangeColor
                selectedIndex = indexPath
            }
                
            else {
                
                selectedCountry?.accessoryType = .Checkmark
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
        
        if indexPath.row % 2 == 0 {
            
            cell.backgroundColor = mainOrangeColor.colorWithAlphaComponent(0.1)
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


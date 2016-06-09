//
//  SelectCountryViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SelectCountryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var countries = ["India", "Kuwait", "Mumbai", "Australia", "Switzerland", "Hong Kong", "Malaysia", "Singapore", "Mauritius"]
    
    var selectedIndex: NSIndexPath = NSIndexPath()
    var isSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCountry = tableView.cellForRowAtIndexPath(indexPath)
        
        if selectedCountry?.accessoryType == .Checkmark {
            
            selectedCountry?.accessoryType = .None
//            selectedCountry?.backgroundColor = UIColor.lightGrayColor()
            isSelected = false
            
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! CountriesTableViewCell
        cell.flagImage.image = UIImage(named: "indian_flag")
        cell.countryName.text = countries[indexPath.item]
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


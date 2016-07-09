//
//  NoFollowingViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 09/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class NoFollowingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var countries = ["India", "Kuwait", "Mumbai", "Australia", "Switzerland", "Hong Kong", "Malaysia", "Singapore", "Mauritius"]
    var isSelected: Bool = false
    @IBOutlet weak var putSearchView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let search = SearchFieldView(frame: CGRect(x: -5, y: 0, width: putSearchView.frame.width + 75, height: putSearchView.frame.height))
        putSearchView.addSubview(search)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 12
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("noFollowingCell") as! NoFollowingTableViewCell
        cell.accessoryType = .None
        
//        if indexPath.row%2 == 0 {
//            
//            print("index path: \(indexPath.row)")
//            cell.backgroundColor = UIColor(red: 244/255, green: 245/255, blue: 246/255, alpha: 1)
//        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Add Friends"
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 20
        
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        
        var indexOfLetters = [String]()
        for string in countries {
            
            indexOfLetters.append(String(string.characters.first!))
            
        }
        
        indexOfLetters = Array(Set(indexOfLetters))
        indexOfLetters = indexOfLetters.sort()
        return indexOfLetters
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCountry = tableView.cellForRowAtIndexPath(indexPath)
        
        if selectedCountry?.accessoryType == .Checkmark {
            
            selectedCountry?.accessoryType = .None
            
        }
            
        else {
            
            selectedCountry?.accessoryType = .Checkmark
            
        }
        
        
    }

}

class NoFollowingTableViewCell: UITableViewCell {
    
    
    
    
}


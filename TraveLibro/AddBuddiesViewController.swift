//
//  AddBuddiesViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 28/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class AddBuddiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var peopleImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addCheckIn = storyboard?.instantiateViewControllerWithIdentifier("addCheckIn") as! AddCheckInViewController
        
        setCheckInNavigationBarItem(addCheckIn)
        
        let attribute = [NSForegroundColorAttributeName: UIColor.lightGrayColor()]
        
        let search = SearchFieldView(frame: CGRect(x: 45, y: 8, width: searchView.frame.width - 10, height: 30))
        search.leftLine.backgroundColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
        search.rightLine.backgroundColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
        search.bottomLine.backgroundColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
        search.searchField.attributedPlaceholder = NSAttributedString(string:  "Search buddies", attributes: attribute)
        search.searchButton.tintColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
        search.searchField.returnKeyType = .Done
        searchView.addSubview(search)
        
        peopleImage.tintColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 12
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! addBuddiesTableViewCell
        if indexPath.row % 2 == 0 {
            
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
            
        }
        else {
            
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
            
        }
        cell.accessoryType = .None
        return cell
        
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        return "All Friends"
//    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let titleView = UIView(frame: CGRect(x: 16, y: 0, width: 200, height: 22))
        let titleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: 200, height: 22))
        titleLabel.font = avenirFont
        titleLabel.textColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
        titleLabel.text = "All Friends"
        titleView.addSubview(titleLabel)
        tableView.headerViewForSection(section)?.addSubview(titleView)
        
        return titleView
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let close = String(format: "%C", faicon["close"]!)
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! addedBuddiesCollectionViewCell
        cell.removeBuddyButton.setTitle(close, forState: .Normal)
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        
                let indexLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "X", "Y", "Z"]
        //        let indexOfLetters = indexLetters.componentsSeparatedByString(" ")
        
        var indexOfLetters = [String]()
        for string in indexLetters {
            
            indexOfLetters.append(String(string.characters.first!))
            
        }
        
        indexOfLetters = Array(Set(indexOfLetters))
        indexOfLetters = indexOfLetters.sort()
        return indexOfLetters
        
    }
    

}

class addedBuddiesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var removeBuddyButton: UIButton!
    @IBOutlet weak var buddyName: UILabel!
    @IBOutlet weak var buddyDp: UIImageView!
    
}

class addBuddiesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var buddyProfileImage: UIImageView!
    @IBOutlet weak var buddyName: UILabel!
    
}


//
//  AddFriendsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 10/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class AddFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableTitle: UILabel!
    
    var names = ["Manan Vora", "Harsh Thakkar", "Pooja Thakare", "Jagruti Patil", "Chaitalee Patil", "Vignesh Kasturi", "Vinod Beloshe", "Dhaval Gala", "Jay Visariya", "Nikesh Mane", "Midhet Sulemani", "Raj Shah", "Tushar Sachde", "Rohan Gada", "Amit Yadav"]
    let images = [UIImage(named: "journey_shoes"), UIImage(named: "journey_shoes"), UIImage(named: "journey_shoes"), UIImage(named: "journey_shoes"), UIImage(named: "journey_shoes"), UIImage(named: "journey_shoes"), UIImage(named: "journey_shoes"), UIImage(named: "journey_shoes"), UIImage(named: "journey_shoes"), UIImage(named: "journey_shoes"), UIImage(named: "journey_shoes"), UIImage(named: "journey_shoes"), UIImage(named: "journey_shoes"), UIImage(named: "journey_shoes"), UIImage(named: "journey_shoes")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        names = names.sort()
        tableTitle.font = avenirFont
        tableTitle.textColor = mainOrangeColor
        
        let addedBuddies = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 22))
        addedBuddies.center = CGPointMake(65, 80)
        addedBuddies.text = "Added Buddies"
        addedBuddies.font = avenirFont
        addedBuddies.textColor = mainOrangeColor
        self.view.addSubview(addedBuddies)
        
        
        let addedBuddyList = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        addedBuddyList.center = CGPointMake(80, 150)
        self.view.addSubview(addedBuddyList)
        
        let addedBuddyImages = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        addedBuddyImages.center = CGPointMake(12, 15)
        addedBuddyImages.image = UIImage(named: "info_circle")
        addedBuddyList.addSubview(addedBuddyImages)
        
        let addedBuddyNames = UILabel(frame: CGRect(x: 0, y: 0, width: 75, height: 20))
        addedBuddyNames.center = CGPointMake(20, 45)
        addedBuddyNames.text = "Manan Vora"
        addedBuddyNames.font = UIFont(name: "Avenir-Roman", size: 10)
        addedBuddyNames.textColor = mainBlueColor
        addedBuddyList.addSubview(addedBuddyNames)
        
        let searchBox = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        searchBox.center = CGPointMake(self.view.frame.size.width/2 - 10, self.view.frame.size.height/3)
        self.view.addSubview(searchBox)
        
        let searchFriendImage = UIImageView(frame: CGRect(x: 0, y: 0, width: searchBox.frame.size.width/12, height: searchBox.frame.size.height))
        searchFriendImage.center = CGPointMake(searchBox.frame.size.width/10, searchBox.frame.size.height/2 + 5)
        searchFriendImage.image = UIImage(named: "add_circle")
        searchBox.addSubview(searchFriendImage)
        
        let searchTextBox = UIView(frame: CGRect(x: 0, y: 0, width: searchBox.frame.size.width/16 * 13, height: searchBox.frame.size.height))
        searchTextBox.center = CGPointMake(searchBox.frame.size.width/8 * 4.5, searchBox.frame.size.height/2)
        searchBox.addSubview(searchTextBox)
        
        let searchText = UITextField(frame: CGRect(x: 0, y: 0, width: searchTextBox.frame.size.width/4 * 2.5, height: searchTextBox.frame.size.height))
        searchText.center = CGPointMake(searchTextBox.frame.size.width/8 * 3 - 10, searchTextBox.frame.size.height/2 + 3)
        searchText.placeholder = "Search a Friend"
        searchText.font = avenirFont
        searchText.textColor = mainBlueColor
//        searchText.layer.borderColor = mainOrangeColor.CGColor
//        searchText.layer.borderWidth = 1
        searchTextBox.addSubview(searchText)
        
        let searchTextImage = UIImageView(frame: CGRect(x: 0, y: 0, width: searchTextBox.frame.size.width/10, height: searchTextBox.frame.size.height/2))
        searchTextImage.center = CGPointMake(searchTextBox.frame.size.width/8 * 7 + 10, searchTextBox.frame.size.height/2)
        searchTextImage.image = UIImage(named: "feed_icon")
        searchTextImage.tintColor = mainOrangeColor
        searchTextBox.addSubview(searchTextImage)
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRectMake(0, searchBox.frame.height - 0.5, searchTextBox.frame.width, 0.5)
        bottomLine.backgroundColor = UIColor.whiteColor().CGColor
        bottomLine.borderColor = mainOrangeColor.CGColor
        bottomLine.borderWidth = 0.5
        searchTextBox.layer.addSublayer(bottomLine)
        
        let leftLine = CALayer()
        leftLine.frame = CGRectMake(0, searchBox.frame.height/3 * 2.2, 0.5, searchTextBox.frame.height/3.8)
        leftLine.backgroundColor = UIColor.whiteColor().CGColor
        leftLine.borderColor = mainOrangeColor.CGColor
        leftLine.borderWidth = 0.5
        searchTextBox.layer.addSublayer(leftLine)
        
        let rightLine = CALayer()
        rightLine.frame = CGRectMake(searchTextBox.frame.width - 1, searchBox.frame.height/3 * 2.2, 0.5, searchTextBox.frame.height/3.8)
        rightLine.backgroundColor = UIColor.whiteColor().CGColor
        rightLine.borderColor = mainOrangeColor.CGColor
        rightLine.borderWidth = 0.5
        searchTextBox.layer.addSublayer(rightLine)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return names.count
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AddFriendsViewCell
        
        cell.friendImage.image = images[indexPath.row]
        cell.friendName.text = names[indexPath.row]
        
        return cell
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        
        let indexLetters = "A B C D E F G H I J K L M N O P Q R S T U V X Y Z"
        let indexOfLetters = indexLetters.componentsSeparatedByString(" ")
        return indexOfLetters
        
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        
        return index
    
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

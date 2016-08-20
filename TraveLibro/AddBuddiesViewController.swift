import UIKit
import SwiftyJSON

class AddBuddiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var peopleImage: UIImageView!
    @IBOutlet weak var friendsTable: UITableView!
    @IBOutlet weak var addedBuddies: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var buddiesCollectionView: UICollectionView!
    @IBOutlet weak var buddiesTableView: UITableView!
    
    var whichView = "LL"
    var addedFriends: [JSON]! = []
    var addedFriendsImages: [String] = []
    var flag = 0
    
    let allFriends = ["Manan Vora", "Malhar Gala", "Monish Shah", "Yash Chudasama", "Andrea Christina", "Nargis Fakhri", "Jacqueline Fernandes", "Aanam Chashmawala", "Sajid Nadiadwala", "Sai Vemula", "Aadil Shah", "Harshit Shah", "Fatema Pocketwala"]
    
    var allFriendsJson: JSON!
    var friendsCount = 0
    
    
    var uniqueId: String!
    
    @IBAction func saveButtonTapped(sender: UIButton) {
        
        var addedFriendUsers: [String] = []
        
        for friend in addedFriends {
            
            print("added friend: \(friend)")
            addedFriendUsers.append(friend["_id"].string!)
            
        }
        if whichView == "TL" {
            
            request.addBuddiesOTG(addedFriendUsers, userId: "57b31418a558b3494544d28f", journeyId: uniqueId, completion: {(response) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if response.error != nil {
                        
                        print("response: \(response.error?.localizedDescription)")
                        
                    }
                        
                    else {
                        
//                        print("response: \(response.description)")
                        let allControllers = self.navigationController?.viewControllers
                        print("count: \(allControllers)")
                        let backVC = allControllers![allControllers!.count - 2] as! NewTLViewController
                        print("count: \(self.addedFriends.count)")
                        backVC.countLabel = self.addedFriends.count
                        backVC.addedBuddies = self.addedFriends
                        backVC.showBuddies()
                        print("count: \(self.addedFriends.count)")
                        
//                        backVC.dpOne = self.addedFriends[0]["profilePicture"].string!
//                        backVC.dpTwo = self.addedFriendsImages[1]["profilePicture"]
//                        backVC.dpThree = self.addedFriendsImages[2]["profilePicture"]
                        self.popVC(sender)
                        
                    }
                    
                })
            })
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        
        let rightButton = UIButton()
        rightButton.setTitle("", forState: .Normal)
        rightButton.addTarget(self, action: nil, forControlEvents: .TouchUpInside)
        rightButton.frame = CGRectMake(0, 8, 80, 30)
        
        self.customNavigationBar(leftButton, right: rightButton)
        
        request.getAllFriends({(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("response: \(response.error?.localizedDescription)")
                    
                }
                    
                else {
                    
                    self.allFriendsJson = response["data"]
                    print("friends: \(self.allFriendsJson)")
                    self.friendsCount = self.allFriendsJson.count
                    self.buddiesTableView.reloadData()
                }
                
            })
            
        })
        
//        setCheckInNavigationBarItem(addCheckIn)
        
        for _ in 0 ..< 3 {
            
            addedFriendsImages.append("profile_icon")
            
        }
//        addedFriendsImages[0] = "profile_icon"
//        addedFriendsImages[1] = "profile_icon"
//        addedFriendsImages[2] = "profile_icon"
        
        let search = SearchFieldView(frame: CGRect(x: 45, y: 8, width: searchView.frame.width - 10, height: 30))
        search.searchField.returnKeyType = .Done
        searchView.addSubview(search)
        
        peopleImage.tintColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
        
        if whichView == "TL" {
            
            getBackGround(self)
            addedBuddies.textColor = mainOrangeColor
            peopleImage.tintColor = mainOrangeColor
            buddiesTableView.backgroundColor = UIColor.clearColor()
            buddiesCollectionView.backgroundColor = UIColor.clearColor()
            search.searchField.attributedPlaceholder = NSAttributedString(string:  "Search buddies", attributes: [NSForegroundColorAttributeName: mainBlueColor])
            search.leftLine.backgroundColor = mainOrangeColor
            search.rightLine.backgroundColor = mainOrangeColor
            search.bottomLine.backgroundColor = mainOrangeColor
            search.searchButton.tintColor = mainOrangeColor
            saveButton.setTitleColor(mainOrangeColor, forState: .Normal)
            
        }
        
        else {
            
            search.searchField.attributedPlaceholder = NSAttributedString(string:  "Search buddies", attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            search.leftLine.backgroundColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
            search.rightLine.backgroundColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
            search.bottomLine.backgroundColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
            search.searchButton.tintColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
            
        }
        
    }
    
    func saveFriendChanges(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendsCount
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! addBuddiesTableViewCell
        cell.accessoryType = .Checkmark
        cell.selectionStyle = .None
        cell.buddyName.text = "\(allFriendsJson[indexPath.row]["firstName"].string!) \(allFriendsJson[indexPath.row]["lastName"].string!)"
        
        let imageUrl = allFriendsJson[indexPath.row]["profilePicture"].string!
        let imageData = NSData(contentsOfURL: NSURL(string: imageUrl)!)
        
        if imageData != nil {
            
            cell.buddyProfileImage.image = UIImage(data:imageData!)
        }
        
        cell.tintColor = UIColor(red: 241/255, green: 242/255, blue: 242/255, alpha: 1)
        if indexPath.row % 2 == 0 {
            
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
            
        }
        else {
            
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
            
        }
         
        if addedFriends.contains(allFriendsJson[indexPath.row]) {
            
            if whichView == "TL" {
                
                cell.tintColor = mainOrangeColor
            }
            else {
                
                cell.tintColor = mainGreenColor
            }
            
        }
        
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
        if whichView == "TL" {
            
            titleLabel.textColor = UIColor(red: 255/255, green: 104/255, blue: 88/255, alpha: 1)
        }
        else {
            
            titleLabel.textColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
            
        }
        titleLabel.text = "All Friends"
        titleView.addSubview(titleLabel)
        tableView.headerViewForSection(section)?.addSubview(titleView)
        
        return titleView
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if addedFriends == nil {
            
            return friendsCount
        }
        
        return addedFriends.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let close = String(format: "%C", faicon["close"]!)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! addedBuddiesCollectionViewCell
        cell.removeBuddyButton.setTitle(close, forState: .Normal)
        cell.buddyName.text = addedFriends[indexPath.row]["firstName"].string!
        
        let imageUrl = addedFriends[indexPath.row]["profilePicture"].string!
        print("collection view dp: \(imageUrl)")
        
        let imageData = NSData(contentsOfURL: NSURL(string: imageUrl)!)
        
        if imageData != nil {
            
            cell.buddyDp.image = UIImage(data:imageData!)
            
        }
        
        if whichView == "TL" {
            
            cell.removeBuddyButton.setTitleColor(mainOrangeColor, forState: .Normal)
            cell.buddyName.textColor = mainBlueColor
            
        }
        cell.removeBuddyButton.layer.zPosition = 10
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! addBuddiesTableViewCell
//        print("tint: \(cell.tintColor)")
        
//        if cell.tintColor != UIColor(red: 241/255, green: 242/255, blue: 242/255, alpha: 1) {
//            
//            cell.tintColor = UIColor(red: 241/255, green: 242/255, blue: 242/255, alpha: 1)
//            
//        }
//        else {
//            
//            if whichView == "LL" {
//                
//                cell.tintColor = mainGreenColor
//                
//            }
//            else {
//                
//                cell.tintColor = mainOrangeColor
//            }
//        }
        if whichView == "TL" {
            
            if cell.tintColor == mainOrangeColor {
                
                cell.tintColor = UIColor(red: 241/255, green: 242/255, blue: 242/255, alpha: 1)
                if let index = addedFriends.indexOf(allFriendsJson[indexPath.row]) {
                    
                    addedFriends.removeAtIndex(index)
                    
                }
                
//                buddiesCollectionView.reloadData()
            }
            
            else {
                
                cell.tintColor = mainOrangeColor
                addedFriends.append(allFriendsJson[indexPath.row])
                
            }
            
        }
        else {
            
            if cell.tintColor == mainGreenColor {
                
                cell.tintColor = UIColor(red: 241/255, green: 242/255, blue: 242/255, alpha: 1)
                if let index = addedFriends.indexOf(allFriendsJson[indexPath.row]) {
                    
                    addedFriends.removeAtIndex(index)
                    
                }
                
//                addedFriends.removeAtIndex(indexPath.row)
//                buddiesCollectionView.reloadData()
            }
                
            else {
                
                cell.tintColor = mainGreenColor
                addedFriends.append(allFriendsJson[indexPath.row])
                
            }
            
        }
//        addedFriends.append(cell.buddyName.text!)
        buddiesCollectionView.reloadData()
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("selected index: \(indexPath.row)")
        addedFriends.removeAtIndex(indexPath.item)
        collectionView.reloadData()
        buddiesTableView.reloadData()
        
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


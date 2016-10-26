import UIKit


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
    
    var allFriendsJson: [JSON] = []
//    var friendsCount = 0
    
    var uniqueId: String = ""
    var journeyName: String = ""
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        sender.isEnabled = false
        
        var addedFriendUsers: [JSON] = []
        
        print("added friends: \(addedFriends), \(currentUser["_id"].string!)")
        
        for friend in addedFriends {
            
            addedFriendUsers.append(friend)
            
        }
        if whichView == "TL" {
            
            let finalFriends: JSON = JSON(addedFriendUsers)
            
            request.addBuddiesOTG(finalFriends, userId: currentUser["_id"].string!, userName: currentUser["name"].string!, journeyId: uniqueId, inMiddle: false, journeyName: journeyName, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    
                    if response.error != nil {
                        
                        print("response: \(response.error?.localizedDescription)")
                        
                    }
                        
                    else if response["value"].bool! {
                        
//                        print("response: \(response.description)")
                        let allControllers = self.navigationController!.viewControllers
//                        print("count: \(allControllers)")
                        for vc in allControllers {
                            
                            if vc.isKind(of: NewTLViewController.self) {
                                
                                print("is kind of class new tl view controller")
                                let backVC = vc as! NewTLViewController
                                backVC.countLabel = self.addedFriends!.count
                                backVC.addedBuddies = self.addedFriends!
//                                backVC.getCurrentOTG()
                                backVC.showBuddies()
                                self.navigationController!.popToViewController(backVC, animated: true)
                                
                            }
                            
                        }
                        
                    }
                    
                    else {
                        
                        let alert = UIAlertController(title: nil, message:
                            "response error!", preferredStyle: .alert)
                        self.present(alert, animated: false, completion: nil)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
                            {action in
                                alert.dismiss(animated: true, completion: nil)
                        }))
                        print("response error")
                        
                    }
                    
                })
            })
            
        }
        else if whichView == "TLMiddle" {
            
            let finalFriends: JSON = JSON(addedFriendUsers)
//            saveButton.hidden = true
            
            request.addBuddiesOTG(finalFriends, userId: currentUser["_id"].string!, userName: currentUser["name"].string!, journeyId: uniqueId, inMiddle: true, journeyName: journeyName, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    
                    if response.error != nil {
                        
                        print("response: \(response.error?.localizedDescription)")
                        
                    }
                        
                    else if response["value"].bool! {
                        
                        //                        print("response: \(response.description)")
                        let allControllers = self.navigationController!.viewControllers
                        //                        print("count: \(allControllers)")
                        for vc in allControllers {
                            
                            if vc.isKind(of: NewTLViewController.self) {
                                
                                let backVC = vc as! NewTLViewController
                                backVC.getJourney()
                                self.navigationController!.popToViewController(backVC, animated: true)
                                
                            }
                            
                        }
                        
                    }
                        
                    else {
                        
                        print("response error")
                        
                    }
                    
                })
            })
        }
        else if whichView == "TLTags" {
            
            let allControllers = self.navigationController!.viewControllers
            
            for vc in allControllers {
                
                if vc.isKind(of: NewTLViewController.self) {
                    
                    let backVC = vc as! NewTLViewController
                    backVC.addedBuddies = addedFriends
                    backVC.displayFriendsCount()
                    self.navigationController!.popToViewController(backVC, animated: true)
                    
                }
                
            }
            
        }
        
    }
    
    var search: SearchFieldView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setTitle("", for: UIControlState())
//        rightButton.addTarget(self, action: nil, for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 80, height: 30)
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        request.getFollowers(currentUser["_id"].string!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("response: \(response.error?.localizedDescription)")
                    
                }
                    
                else if response["value"].bool! {
                    
                    self.allFriendsJson = response["data"]["followers"].array!
                    print("friends: \(self.allFriendsJson)")
//                    self.friendsCount = self.allFriendsJson.count
                    self.buddiesTableView.reloadData()
                }
                
                else {
                    
                    print("response error!")
                    
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
        
        search = SearchFieldView(frame: CGRect(x: 45, y: 8, width: searchView.frame.width - 10, height: 30))
        search.searchField.returnKeyType = .done
        searchView.addSubview(search)
        
        peopleImage.tintColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
        
        if whichView == "TL" || whichView == "TLMiddle" || whichView == "TLTags" {
            
            getBackGround(self)
            search.searchField.addTarget(self, action: #selector(AddBuddiesViewController.getSearchResults(_:)), for: .editingChanged)
            addedBuddies.textColor = mainOrangeColor
            peopleImage.tintColor = mainOrangeColor
            buddiesTableView.backgroundColor = UIColor.clear
            buddiesCollectionView.backgroundColor = UIColor.clear
            search.searchField.attributedPlaceholder = NSAttributedString(string:  "Search buddies", attributes: [NSForegroundColorAttributeName: mainBlueColor])
            search.leftLine.backgroundColor = mainOrangeColor
            search.rightLine.backgroundColor = mainOrangeColor
            search.bottomLine.backgroundColor = mainOrangeColor
            search.searchButton.tintColor = mainOrangeColor
            saveButton.setTitleColor(mainOrangeColor, for: UIControlState())
            
        }
        
        else {
            
            search.searchField.attributedPlaceholder = NSAttributedString(string:  "Search buddies", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            search.leftLine.backgroundColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
            search.rightLine.backgroundColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
            search.bottomLine.backgroundColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
            search.searchButton.tintColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
            
        }
        
    }
    
    func getSearchResults(_ sender: UITextField) {
        
        print("sender: \(search.searchField.text!)")
        
        request.getBuddySearch(currentUser["_id"].string!, searchtext: search.searchField.text!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error; \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    self.allFriendsJson = response["data"].array!
                    self.friendsTable.reloadData()
                    
                }
                else {
                    
                }
            })
            
        })
        
        
        
    }
    
    
    func saveFriendChanges(_ sender: UIButton) {
        
        self.navigationController!.popViewController(animated: true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allFriendsJson.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! addBuddiesTableViewCell
        cell.accessoryType = .checkmark
        cell.selectionStyle = .none
        cell.buddyName.text = allFriendsJson[(indexPath as NSIndexPath).row]["name"].string!
        
        let imageUrl = allFriendsJson[(indexPath as NSIndexPath).row]["profilePicture"].string!
        
        let isUrl = verifyUrl(imageUrl)
        print("isUrl: \(isUrl)")
        
        if isUrl {
            
            print("inside if statement")
            let data = try? Data(contentsOf: URL(string: imageUrl)!)
            
            if data != nil  && imageUrl != "" {
                
                print("some problem in data \(data)")
                //                uploadView.addButton.setImage(, forState: .Normal)
                cell.buddyProfileImage.image = UIImage(data: data!)
                //                cell.buddyDp.image = UIImage(data: data!)
                //                    makeTLProfilePicture(profile.image)
                makeTLProfilePicture(cell.buddyProfileImage)
            }
        }
            
        else if imageUrl != "" {
            
            let getImageUrl = adminUrl + "upload/readFile?file=" + imageUrl + "&width=100"
            
            //                print("getImageUrl: \(getImageUrl)")
            
            let data = try? Data(contentsOf: URL(string: getImageUrl)!)
            //                print("data: \(data)")
            
            if data != nil {
                
                //                uploadView.addButton.setImage(UIImage(data:data!), forState: .Normal)
                print("inside if statement \(cell.buddyProfileImage.image)")
                cell.buddyProfileImage.image = UIImage(data: data!)
                print("sideMenu.profilePicture.image: \(cell.buddyProfileImage.image)")
                cell.buddyProfileImage.image = UIImage(data: data!)
                makeTLProfilePicture(cell.buddyProfileImage)
            }
            
        }
        
        
//        let imageData = NSData(contentsOfURL: NSURL(string: imageUrl)!)
//        
//        if imageData != nil {
//            
//            cell.buddyProfileImage.image = UIImage(data:imageData!)
//        }
        
        cell.tintColor = UIColor(red: 241/255, green: 242/255, blue: 242/255, alpha: 1)
        if (indexPath as NSIndexPath).row % 2 == 0 {
            
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            
        }
        else {
            
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.7)
            
        }
         
        if addedFriends.contains(allFriendsJson[(indexPath as NSIndexPath).row]) {
            
            if whichView == "TL" || whichView == "TLMiddle" || whichView == "TLTags" {
                
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let titleView = UIView(frame: CGRect(x: 16, y: 0, width: 200, height: 22))
        let titleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: 200, height: 22))
        titleLabel.font = avenirFont
        if whichView == "TL" || whichView == "TLMiddle" || whichView == "TLTags" {
            
            titleLabel.textColor = UIColor(red: 255/255, green: 104/255, blue: 88/255, alpha: 1)
        }
        else {
            
            titleLabel.textColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
            
        }
        titleLabel.text = "All Friends"
        titleView.addSubview(titleLabel)
        tableView.headerView(forSection: section)?.addSubview(titleView)
        
        return titleView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if addedFriends == nil {
            
            return addedFriends.count
        }
        
        return addedFriends.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let close = String(format: "%C", faicon["close"]!)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! addedBuddiesCollectionViewCell
        cell.removeBuddyButton.setTitle(close, for: UIControlState())
        cell.buddyName.text = addedFriends[(indexPath as NSIndexPath).row]["name"].string!
        
        let imageUrl = addedFriends[(indexPath as NSIndexPath).row]["profilePicture"].string!
        print("collection view dp: \(imageUrl)")
        
        let isUrl = verifyUrl(imageUrl)
        print("isUrl: \(isUrl)")
        
        if isUrl && imageUrl != "" {
            
            print("inside if statement")
            let data = try? Data(contentsOf: URL(string: imageUrl)!)
            
            if data != nil {
                
                print("some problem in data \(data)")
                //                uploadView.addButton.setImage(, forState: .Normal)
                cell.buddyDp.image = UIImage(data: data!)
//                cell.buddyDp.image = UIImage(data: data!)
                //                    makeTLProfilePicture(profile.image)
                makeTLProfilePicture(cell.buddyDp)
            }
        }
            
        else if imageUrl != "" {
            
            let getImageUrl = adminUrl + "upload/readFile?file=" + imageUrl + "&width=100"
            
            //                print("getImageUrl: \(getImageUrl)")
            
            let data = try? Data(contentsOf: URL(string: getImageUrl)!)
            //                print("data: \(data)")
            
            if data != nil {
                
                //                uploadView.addButton.setImage(UIImage(data:data!), forState: .Normal)
                print("inside if statement \(cell.buddyDp.image)")
                cell.buddyDp.image = UIImage(data: data!)
                print("sideMenu.profilePicture.image: \(cell.buddyDp.image)")
                cell.buddyDp.image = UIImage(data: data!)
                makeTLProfilePicture(cell.buddyDp)
            }
            
        }
        
//        let imageData = NSData(contentsOfURL: NSURL(string: imageUrl)!)
//        
//        if imageData != nil {
//            
//             = UIImage(data:imageData!)
//            
//        }
        
        if whichView == "TL" || whichView == "TLMiddle" || whichView == "TLTags" {
            
            cell.removeBuddyButton.setTitleColor(mainOrangeColor, for: UIControlState())
            cell.buddyName.textColor = mainBlueColor
            
        }
        cell.removeBuddyButton.layer.zPosition = 10
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! addBuddiesTableViewCell
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
        if whichView == "TL" || whichView == "TLMiddle" || whichView == "TLTags" {
            
            if cell.tintColor == mainOrangeColor {
                
                cell.tintColor = UIColor(red: 241/255, green: 242/255, blue: 242/255, alpha: 1)
                if let index = addedFriends.index(of: allFriendsJson[(indexPath as NSIndexPath).row]) {
                    
                    addedFriends.remove(at: index)
                    
                }
                
//                buddiesCollectionView.reloadData()
            }
            
            else {
                
                cell.tintColor = mainOrangeColor
                addedFriends.append(allFriendsJson[(indexPath as NSIndexPath).row])
                
            }
            
        }
        else {
            
            if cell.tintColor == mainGreenColor {
                
                cell.tintColor = UIColor(red: 241/255, green: 242/255, blue: 242/255, alpha: 1)
                if let index = addedFriends.index(of: allFriendsJson[(indexPath as NSIndexPath).row]) {
                    
                    addedFriends.remove(at: index)
                    
                }
                
//                addedFriends.removeAtIndex(indexPath.row)
//                buddiesCollectionView.reloadData()
            }
                
            else {
                
                cell.tintColor = mainGreenColor
                addedFriends.append(allFriendsJson[(indexPath as NSIndexPath).row])
                
            }
            
        }
//        addedFriends.append(cell.buddyName.text!)
        buddiesCollectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("selected index: \((indexPath as NSIndexPath).row)")
        addedFriends.remove(at: (indexPath as NSIndexPath).item)
        collectionView.reloadData()
        buddiesTableView.reloadData()
        
    }
    
//    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
//        
//        let indexLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "X", "Y", "Z"]
//        //        let indexOfLetters = indexLetters.componentsSeparatedByString(" ")
//        
//        var indexOfLetters = [String]()
//        for string in indexLetters {
//            
//            indexOfLetters.append(String(string.characters.first!))
//            
//        }
//        
//        indexOfLetters = Array(Set(indexOfLetters))
//        indexOfLetters = indexOfLetters.sort()
//        return indexOfLetters
//        
//    }
    

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


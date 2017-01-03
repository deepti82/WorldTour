import UIKit

class AddBuddiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var peopleImage: UIImageView!
    @IBOutlet weak var friendsTable: UITableView!
    @IBOutlet weak var addedBuddies: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var buddiesCollectionView: UICollectionView!
    @IBOutlet weak var buddiesTableView: UITableView!
    
    var buddies:[Buddy]!
    var friendsTag:UIImageView!
    var friendsCount:UIButton!
    
    var whichView = "LL"
    var addedFriends: [JSON] = []
    var frezzFriends: [JSON] = []
    var addedFriendsImages: [String] = []
    var flag = 0
    var buddiesStatus = true
    var allFriendsJson: [JSON] = []
    
    var uniqueId: String = ""
    var journeyName: String = ""
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        sender.isEnabled = false
        
        self.navigationController?.popViewController(animated: true)
        
        print("Chintan Shaha");
        print(whichView);
        switch(whichView) {
            case "AddActivity":
            globalAddActivityNew.buddyAdded(addedFriends);
            case "NewTLMiddle":
            globalNewTLViewController.buddyAdded(addedFriends);
            default:
            break;
        }
//        globalNewTLViewController.getJourney()
//                        for vc in allControllers {
//        
//                            if vc.isKind(of: NewTLViewController.self) {
//        
//                                print("is kind of class new tl view controller")
//                                let backVC = vc as! NewTLViewController
//                                backVC.addedBuddies = self.addedFriends
//                                self.navigationController!.popToViewController(backVC, animated: true)
//        
//                            }
//                            
//                        }
        
        
//        if whichView == "TL" {
//            if(addedFriends.count == 0) {
//                let allControllers = self.navigationController!.viewControllers
//                for vc in allControllers {
//                    
//                    if vc.isKind(of: NewTLViewController.self) {
//                        
//                        print("is kind of class new tl view controller")
//                        let backVC = vc as! NewTLViewController
//                        backVC.countLabel = self.addedFriends.count
//                        backVC.addedBuddies = self.addedFriends
//                        backVC.getJourney()
//                        backVC.showBuddies()
//                        self.navigationController!.popToViewController(backVC, animated: true)
//                        
//                    }
//                    
//                }
//            } else {
//                for friend in addedFriends {
//                    addedFriendUsers.append(friend)
//                }
//                let finalFriends: JSON = JSON(addedFriendUsers)
//                
//                let allControllers = self.navigationController!.viewControllers
//                for vc in allControllers {
//                    
//                    if vc.isKind(of: NewTLViewController.self) {
//                        
//                        print("is kind of class new tl view controller")
//                        let backVC = vc as! NewTLViewController
//                        backVC.countLabel = self.addedFriends.count
//                        backVC.addedBuddies = self.addedFriends
//                        //                                backVC.getCurrentOTG()
//                        backVC.showBuddies()
//                        self.navigationController!.popToViewController(backVC, animated: true)
//                        
//                    }
//                    
//                }
//                
//            }
//        }
//        else if whichView == "TLMiddle" {
//            for friend in addedFriends {
//                addedFriendUsers.append(friend)
//            }
//            
//            let finalFriends: JSON = JSON(addedFriendUsers)
//            //            saveButton.hidden = true
//            
//            
//            let allControllers = self.navigationController!.viewControllers
//            for vc in allControllers {
//                
//                if vc.isKind(of: NewTLViewController.self) {
//                    
//                    let backVC = vc as! NewTLViewController
//                    backVC.getJourney()
//                    self.navigationController!.popToViewController(backVC, animated: true)
//                }
//            }
//        } else if whichView == "TLTags" {
//            let allControllers = self.navigationController!.viewControllers
//            
//            for vc in allControllers {
//                
//                if vc.isKind(of: NewTLViewController.self) {
//                    let backVC = vc as! NewTLViewController
//                    backVC.addedBuddies = addedFriends
//                    backVC.displayFriendsCount()
//                    self.navigationController!.popToViewController(backVC, animated: true)
//                    
//                }
//                
//            }
//            
//        }
        
        
        
    }
    
    var search: SearchFieldView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("which view: \(buddiesStatus)")
        
        if !buddiesStatus {
            print("in if buddies not")
            frezzFriends = addedFriends
            addedFriends = []
        }
        
            self.title = "Added Buddies"
            
            print("addedFriends: \(addedFriends)")
            print("friends json: \(allFriendsJson)")
            
            let leftButton = UIButton()
            leftButton.setImage(UIImage(named: "arrow_prev"), for: .normal)
            leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
            leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            
            let rightButton = UIButton()
            rightButton.setTitle("Done", for: .normal)
            rightButton.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: .touchUpInside)
            rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
            
            self.customNavigationBar(left: leftButton, right: rightButton)
        
        setBuddies(searchText: "")
        
        for _ in 0 ..< 3 {
            
            addedFriendsImages.append("profile_icon")
            
        }
        
        search = SearchFieldView(frame: CGRect(x: 45, y: 8, width: searchView.frame.width - 10, height: 30))
        search.searchField.returnKeyType = .done
        searchView.addSubview(search)
        
        peopleImage.tintColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
        
        
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
    
    func formatAllFriends(friends: [JSON]) {
        for friend in friends {
            allFriendsJson.append(["name": friend["name"].string!, "_id": friend["_id"].string!, "email": friend["email"].string!, "profilePicture": friend["profilePicture"].string!])
        }
        self.buddiesTableView.reloadData()
    }
    
    func setBuddies(searchText: String) {
        request.getBuddySearch(currentUser["_id"].string!, searchtext: searchText, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error; \(response.error!.localizedDescription)")
                    
                } else if response["value"].bool! {
                    
                    if self.buddiesStatus {
                        self.allFriendsJson = response["data"].array!
                    }else{
                        self.allFriendsJson = []
                        for n in response["data"].array! {
                            if !(self.frezzFriends.contains(where: {$0["_id"] == n["_id"]})) {
                                self.allFriendsJson.append(n)
                            }
                        }
                    }
                    
                    self.buddiesTableView.reloadData()
                    
                }
                else {
                    
                }
            })
            
        })
    }
    
    func getSearchResults(_ sender: UITextField) {
        
        print("sender: \(search.searchField.text!)")
        
        
        setBuddies(searchText: search.searchField.text!)
        
        
    }
    
    
    func saveFriendChanges(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
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
                cell.buddyProfileImage.image = UIImage(data: data!)
                makeTLProfilePicture(cell.buddyProfileImage)
            }
        } else if imageUrl != "" {
            
            let getImageUrl = adminUrl + "upload/readFile?file=" + imageUrl + "&width=100"
            let data = try! Data(contentsOf: URL(string: getImageUrl)!)
            
            
            if data != nil {
                
                
                cell.buddyProfileImage.hnk_setImageFromURL(URL(string:getImageUrl)!)
                
                makeTLProfilePicture(cell.buddyProfileImage)
            }
            
        }
        
        cell.tintColor = UIColor(red: 241/255, green: 242/255, blue: 242/255, alpha: 1)
        if indexPath.row % 2 == 0 {
            
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            
        }
        else {
            
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.7)
            
        }
        
        
        if addedFriends.contains(where: {$0["_id"] == allFriendsJson[indexPath.row]["_id"]}) {
            
                    cell.tintColor = mainOrangeColor
            
        }
        
        
        return cell
        
    }
    
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
            return 0
        }
        else {
            if(self.friendsTag != nil && self.friendsCount != nil) {
                if(addedFriends.count == 0) {
                    self.friendsTag.tintColor = mainBlueColor
                    self.friendsCount.isHidden = true;
                }
                else {
                    self.friendsTag.tintColor = mainOrangeColor
                    self.friendsCount.isHidden = false;
                    if(addedFriends.count == 1) {
                        self.friendsCount.titleLabel?.text =  "1 Friend";
                    } else {
                        self.friendsCount.titleLabel?.text =  String(allFriendsJson.count) + " Friends";
                    }
                }
            }
            return addedFriends.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let close = String(format: "%C", faicon["close"]!)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! addedBuddiesCollectionViewCell
        cell.removeBuddyButton.setTitle(close, for: UIControlState())
        cell.buddyName.text = addedFriends[(indexPath as NSIndexPath).row]["name"].string!
        //        cell.acc
        
        let imageUrl = addedFriends[(indexPath as NSIndexPath).row]["profilePicture"].string!
        print("collection view dp: \(imageUrl)")
        
        let isUrl = verifyUrl(imageUrl)
        print("isUrl: \(isUrl)")
        
        if isUrl && imageUrl != "" {
            
            print("inside if statement")
            let data = try? Data(contentsOf: URL(string: imageUrl)!)
            
            if data != nil {
                
                print("some problem in data \(data)")
                cell.buddyDp.image = UIImage(data: data!)
                cell.buddyDp.image = UIImage(data: data!)
                makeTLProfilePicture(cell.buddyDp)
                
            }
        }
            
        else if imageUrl != "" {
            
            let getImageUrl = adminUrl + "upload/readFile?file=" + imageUrl + "&width=100"
            
            
            let data = try? Data(contentsOf: URL(string: getImageUrl)!)
            
            if data != nil {
                
                //                uploadView.addButton.setImage(UIImage(data:data!), forState: .Normal)
                cell.buddyDp.image = UIImage(data: data!)
                
                cell.buddyDp.image = UIImage(data: data!)
                makeTLProfilePicture(cell.buddyDp)
            }
            
        }
        
        
        
            cell.removeBuddyButton.setTitleColor(mainOrangeColor, for: UIControlState())
            cell.buddyName.textColor = mainBlueColor
            
        cell.removeBuddyButton.layer.zPosition = 10
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! addBuddiesTableViewCell
            if cell.tintColor == mainOrangeColor {
                print(" in if mainoragecolor")
                cell.tintColor = UIColor(red: 241/255, green: 242/255, blue: 242/255, alpha: 0)
                print(addedFriends.index(where: {$0["_id"] == allFriendsJson[indexPath.row]["_id"]}) ?? -1)
                if let index = addedFriends.index(where: {$0["_id"] == allFriendsJson[indexPath.row]["_id"]}) {
                    
                    addedFriends.remove(at: index)
                    
                }
                
            } else {
                
                cell.tintColor = mainOrangeColor
                addedFriends.append(allFriendsJson[indexPath.row])
                
            }
            
        
        buddiesCollectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("selected index: \((indexPath as NSIndexPath).row)")
        addedFriends.remove(at: (indexPath as NSIndexPath).item)
        collectionView.reloadData()
        buddiesTableView.reloadData()
        
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


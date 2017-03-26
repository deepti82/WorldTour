
import UIKit




class FollowersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var whichView: String!
    
    var followers: [JSON] = []
    
    @IBOutlet weak var followerTable: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var headerText: UILabel!    
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    
    var customSearch: SearchFieldView!
    var shouldShowSearchResults = false
    var filter: [JSON]!
    var searchText = ""
    var followersMainCopy: [JSON] = []
    var back: Bool = true
    var currentSelectedUser:JSON = []
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGround(self)
        
        followers = []
        
        loader.showOverlay(self.view)
        
        let rightButton = UIButton()
        rightButton.setTitle("Invite", for: .normal)
        rightButton.setTitleColor(mainGreenColor, for: .normal)
        rightButton.addTarget(self, action: #selector(FollowersViewController.inviteButtonClicked(sender:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        
//        if back {
            let leftButton = UIButton()
            leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
            leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
            leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            
            self.customNavigationBar(left: leftButton, right: rightButton)
//        }
//        else{
//            self.setOnlyRightNavigationButton(rightButton)
//        }
        
        followerTable.delegate = self
        followerTable.dataSource = self
        print("\n FollowerInteraction : \(followerTable.isUserInteractionEnabled) \n")
        followerTable.tableFooterView = UIView(frame: CGRect.zero)
        
        if whichView == "Following" {
            self.title = "Following"
            headerText.text = " "
            configureSearchController()
            getFollowing()
            
        } 
        else if whichView == "No Followers" {
            
            followerTable.removeFromSuperview()
            searchView.removeFromSuperview()
            headerText.removeFromSuperview()
            
            let nofollow = NoFollowers(frame: CGRect(x: 0, y: 75, width: self.view.frame.width, height: 250))
            self.view.addSubview(nofollow)
            
        } 
        else {
//            searchViewHeightConstraint.constant = 0
            configureSearchController()            
            getFollowers()
            headerText.text = " "
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func getFollowing() {
        
        print("inside following function")
        request.getFollowing(user.getExistingUser(), searchText: searchText, urlSlug:currentSelectedUser["urlSlug"].stringValue,  completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                self.headerText.text = "Following (0))"
                
                if response.error != nil {
                    
                    print("response: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    self.followers = response["data"]["following"].array!
                    self.headerText.text = "Following (\(self.followers.count))"
                    self.followerTable.reloadData()
                    loader.hideOverlayView()
                    if (self.searchText == "" && (self.followers.count > 0 && self.followers.first!["following"].intValue != 1)) {
                        self.noFollowingFound()
                    }
                }
                else {
                    
                    print("response error: \(response["error"])")
                }
            })
        })
    }
    
    func getFollowers() {       
        
        request.getFollowers(user.getExistingUser(), searchText: searchText, urlSlug:currentSelectedUser["urlSlug"].stringValue,  completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                self.headerText.text = "Following (0)"
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    self.followers = response["data"]["followers"].array!
                    self.followersMainCopy = response["data"]["followers"].array!
                    self.headerText.text = "Followers (\(self.followers.count))"
                    self.followerTable.reloadData()
                    loader.hideOverlayView()
                    if self.followers.isEmpty {
                        self.noFollowersFound()
                    }
                }
                else {
                    
                    print("response error: \(response["error"])")
                    
                }
            })
            
        })
        
    }
    
    //MARK: - Empty Data Handled
    
    func noFollowingFound() {
        headerText.text = "Popular Travellers"
    }
    
    func noFollowersFound() {
        followerTable.removeFromSuperview()
        searchView.removeFromSuperview()
        headerText.removeFromSuperview()
        self.navigationItem.rightBarButtonItems = []
        let nofollow = NoFollowers(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120))
        nofollow.inviteButton.addTarget(self, action: #selector(FollowersViewController.inviteButtonClicked(sender:)), for: .touchUpInside)
        nofollow.center = self.view.center
        self.view.addSubview(nofollow)
    }
    
    
    //MARK: - Search
    
    func configureSearchController() {
        
        customSearch = SearchFieldView(frame: CGRect(x: 10, y: 10, width: searchView.frame.width - 10, height: 30))
        customSearch.leftLine.backgroundColor = mainOrangeColor
        customSearch.rightLine.backgroundColor = mainOrangeColor
        customSearch.bottomLine.backgroundColor = mainOrangeColor
        customSearch.searchButton.tintColor = mainOrangeColor
        customSearch.backgroundColor = UIColor.clear
        customSearch.searchField.returnKeyType = .done
        customSearch.searchField.autocorrectionType = .no
        customSearch.searchButton.isUserInteractionEnabled = true
        customSearch.searchButton.addTarget(self, action: #selector(FollowersViewController.searchButtonClicked(sender:)), for: .touchUpInside)
        customSearch.searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        customSearch.searchField.delegate = self
        customSearch.tintColor = mainOrangeColor
        searchView.addSubview(customSearch)
        searchView.clipsToBounds = true
        
        if whichView == "Following" {
            customSearch.searchField.placeholder = "Search interesting people to follow  "
        }
        else if whichView == "Followers" {
            customSearch.searchField.placeholder = "Search Followers  "
        }        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        headerHeightConstraint.constant = 0
        shouldShowSearchResults = true       
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        headerHeightConstraint.constant = 30
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        customSearch.searchField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
        searchText = textField.text!
        if whichView == "Following" {
            getFollowing()
        }else{
            getFollowers()
//            searchFollowersLocaly()
        }
        followerTable.reloadData()
        
    }
    
    func searchButtonClicked(sender: UIButton) {
        if !shouldShowSearchResults {
            
            shouldShowSearchResults = true
            followerTable.reloadData()
            
        }
        customSearch.searchField.resignFirstResponder()
    }
    
    func searchFollowersLocaly() {
        
    }
    
    //MARK: - Tableview Delegates and Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults && filter != nil {
            
            return filter.count
        }else{
            
            return followers.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FollowersCell
        cell.followButton.isSelected = false
        cell.profileImage.image = UIImage(named: "logo-default")
        HiBye(cell.profileImage)
        
        cell.setAll()
        
        if filter != nil {
            print("\n celldata : \(filter[indexPath.row])")
        }

        if filter != nil && shouldShowSearchResults {
            cell.profileName.text = filter[(indexPath as NSIndexPath).row]["name"].string!
            cell.urlSlurg.text =  filter[(indexPath as NSIndexPath).row]["urlSlug"].string!
            let image = filter[(indexPath as NSIndexPath).row]["profilePicture"].string!
            HiBye(cell.profileImage)
            setImage(cell.profileImage, imageName: image)
            
            
            if filter[indexPath.row]["following"].intValue == 1 {
                cell.followButton.tag = 1
                cell.followButton.setImage(UIImage(named:"following"), for: .normal)
            }
            else if filter[indexPath.row]["following"].intValue == 0 {
                cell.followButton.tag = 0
                cell.followButton.setImage(UIImage(named:"follow"), for: .normal)
            }
            else if filter[indexPath.row]["following"].intValue == 2 {
                cell.followButton.tag = 2
                cell.followButton.setImage(UIImage(named:"requested"), for: .normal)
            }
            
            cell.followButton.contentMode = .scaleAspectFit
            cell.followButton.clipsToBounds = true
            cell.followButton.isSelected = true
            
            
        }
            
        else if followers.count != 0 {
            cell.profileName.text = followers[(indexPath as NSIndexPath).row]["name"].string!
            cell.urlSlurg.text = "@\(followers[(indexPath as NSIndexPath).row]["urlSlug"].string!)"
            if followers[(indexPath as NSIndexPath).row]["profilePicture"] != nil {                
                let image = followers[(indexPath as NSIndexPath).row]["profilePicture"].string!
                setImage(cell.profileImage, imageName: image)
            }
            
            if followers[indexPath.row]["following"].intValue == 1 {
                cell.followButton.tag = 1
                cell.followButton.setImage(UIImage(named:"following"), for: .normal)
            }
            else if followers[indexPath.row]["following"].intValue == 0 {
                cell.followButton.tag = 0
                cell.followButton.setImage(UIImage(named:"follow"), for: .normal)
            }
            else if followers[indexPath.row]["following"].intValue == 2 {
                cell.followButton.tag = 2
                cell.followButton.setImage(UIImage(named:"requested"), for: .normal)
            }
            
            cell.followButton.contentMode = .scaleAspectFit
            cell.followButton.clipsToBounds = true
            cell.followButton.isSelected = true
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filter != nil && shouldShowSearchResults {
            selectedPeople = filter[indexPath.row]["_id"].stringValue
            selectedUser = filter[indexPath.row]
        
        }else{
            selectedPeople = followers[indexPath.row]["_id"].stringValue
            selectedUser = followers[indexPath.row]
        }        
        
        let profile = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        profile.displayData = "search"
        profile.currentSelectedUser = selectedUser
        globalNavigationController.pushViewController(profile, animated: true)
    }
    
    func setImage(_ imageView: UIImageView, imageName: String) {
        
        let isUrl = verifyUrl(imageName)
        
        if imageName == "" {
            
            imageView.image = UIImage(named: "logo-default")
            makeBuddiesTLProfilePicture(imageView)
            
        }
            
        else if isUrl {
            imageView.hnk_setImageFromURL(URL(string: imageName)!)
            makeTLProfilePictureFollowers(imageView)
        }
            
        else {
            
            let getImageUrl = adminUrl + "upload/readFile?file=" + imageName + "&width=100"            
            imageView.hnk_setImageFromURL(URL(string: getImageUrl)!)
            makeTLProfilePictureFollowers(imageView)
        }
    }    
    
    //MARK: - Follow Actions
    
    func followUser(_ followName: String, sender: UIButton) {
        
        var followId: String!
        
        var Index = 0
        
        for i in 0 ..< followers.count {
            
            if followers[i]["urlSlug"].string! == followName {
                
                followId = followers[i]["_id"].string!
                Index = i
                
            }
            
        }
        
        request.followUser(user.getExistingUser(), followUserId: followId, completion: {(response) in
            DispatchQueue.main.async(execute: {
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    print("response arrived!")
//                    var newJson = followers[Index]
//                    newJson["following"] = JSON(response["data"]["responseValue"].stringValue)
//                    followers[Index] = newJson
//                    self.followerTable.reloadData()
//                    self.followerTable.reloadRows(at: [NSIndexPath(row: Index, section: 0) as IndexPath], with: .automatic)
                    
                    setFollowButtonTitle(button: sender, followType: response["data"]["responseValue"].intValue)
                }
                else {
                    
                    print("error: \(response["error"])")
                    
                }
            })
            })       
    }
    
    func unFollowUser(_ unfollowName: String, sender: UIButton) {
        
        var unfollowId: String!
        
        var Index = 0
        
        for i in 0 ..< followers.count {
            
            if followers[i]["urlSlug"].string! == unfollowName {
                
                unfollowId = followers[i]["_id"].string!
                Index = i
                
            }
            
        }
        
        request.unfollow(user.getExistingUser(), unFollowId: unfollowId, completion: {(response) in
            DispatchQueue.main.async(execute: {
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    print("response arrived! : \(response)")
//                    var newJson = followers[Index]
//                    newJson["following"] = JSON(response["data"]["responseValue"].stringValue)
//                    followers[Index] = newJson
//                    self.followerTable.reloadData()
//                    self.followerTable.reloadRows(at: [NSIndexPath(row: Index, section: 0) as IndexPath], with: .automatic)
                    setFollowButtonTitle(button: sender, followType: response["data"]["responseValue"].intValue)
                }
                else {
                    
                    print("error: \(response["error"])")
                    
                }                
            })
            
        })
        
        
    }

    //MARK: - Invite
    
    func inviteButtonClicked(sender: UIButton) {
        
        inviteToAppClicked(sender: sender, onView: self)
    }
}

class FollowersCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var urlSlurg: UILabel!
    
    var parent = FollowersViewController()
    
    @IBAction func followTap(_ sender: UIButton) {
        
        if sender.tag == 0 {            
            parent.followUser(getURLSlug(slug: urlSlurg.text!), sender: sender)
            sender.tag = 1
            sender.setImage(UIImage(named:"following"), for: .normal)
            sender.contentMode = .scaleAspectFit
            sender.clipsToBounds = true
            sender.isSelected = true
        }
            
        else if sender.tag == 1 {
            parent.unFollowUser(getURLSlug(slug: urlSlurg.text!), sender: sender)
            sender.tag = 0
            sender.setImage(UIImage(named:"follow"), for: .normal)
            sender.contentMode = .scaleAspectFit
            sender.clipsToBounds = true
            sender.isSelected = false
        }
        
        else if sender.tag == 2 {            
            //Nothing should happen
        }
    }
    
    func toProfile(_ sender: AnyObject) {
        print("clicked \(currentUser)")
//        selectedPeople = currentUser["user"]["_id"].stringValue
//        selectedUser = currentFeed["user"]
//        let profile = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
//        profile.displayData = "search"
//        globalNavigationController.pushViewController(profile, animated: true)
    }
    
    func setAll() {
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.toProfile(_:)))
        self.profileImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    
    func getURLSlug(slug: String) -> String {
        var myString = slug
        myString.remove(at: myString.startIndex)
        return myString
    }
    
    
    
}



import UIKit


var followers: [JSON] = []

class FollowersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var followerTable: UITableView!
   
    var whichView: String!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var headerText: UILabel!    
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    
    var customSearch: SearchFieldView!
    var shouldShowSearchResults = false
    var filter: [JSON]!
    var searchText = ""
    var followersMainCopy: [JSON] = []
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGround(self)
        
        followers = []
        
        loader.showOverlay(self.view)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setTitle("Invite", for: .normal)
        rightButton.setTitleColor(mainGreenColor, for: .normal)
        rightButton.addTarget(self, action: #selector(FollowersViewController.inviteButtonClicked(sender:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        self.setOnlyLeftNavigationButton(leftButton)
        
        followerTable.delegate = self
        followerTable.dataSource = self
        followerTable.tableFooterView = UIView(frame: CGRect.zero)
        
        if whichView == "Following" {
            self.title = "Following"
            headerText.text = "Following (counting)"
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
            headerText.text = "Followers (counting)"
        }
    }
    
    func getFollowing() {
        
        print("inside following function")
        request.getFollowing(currentUser["_id"].string!, searchText: searchText, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                self.headerText.text = "Following (0))"
                
                if response.error != nil {
                    
                    print("response: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    print("SearchText :\(self.searchText) && RESULT : \n \(response["data"]["following"])")                    
                    followers = response["data"]["following"].array!
                    self.headerText.text = "Following (\(followers.count))"
                    self.followerTable.reloadData()
                    loader.hideOverlayView()
                }
                else {
                    
                    print("response error: \(response["error"])")
                }
                
                
            })
            
            
        })
        
    }
    
    func getFollowers() {
        
        print("inside following function")
        request.getFollowers(currentUser["_id"].string!, searchText: searchText, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                self.headerText.text = "Following (0)"
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    print("\(response["data"]["following"])")
                    followers = response["data"]["followers"].array!
                    self.followersMainCopy = response["data"]["followers"].array!
                    self.headerText.text = "Followers (\(followers.count))"
                    self.followerTable.reloadData()
                    loader.hideOverlayView()
                }
                else {
                    
                    print("response error: \(response["error"])")
                    
                }
            })
            
        })
        
    }
    
    //MARK: - Search
    
    func configureSearchController() {
        
        customSearch = SearchFieldView(frame: CGRect(x: 10, y: 10, width: searchView.frame.width, height: 30))
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
        searchView.addSubview(customSearch)
        searchView.clipsToBounds = true
        
        if whichView == "Following" {
            customSearch.searchField.placeholder = "Search interesting people to follow their inspirational stories..."
        }
        else if whichView == "Followers" {
            customSearch.searchField.placeholder = "Search Followers"
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
        
        if filter != nil {
            print("\n celldata : \(filter[indexPath.row])")
        }

        if filter != nil && shouldShowSearchResults {
            print("in ONE")
            cell.profileName.text = filter[(indexPath as NSIndexPath).row]["name"].string!
            cell.urlSlurg.text =  filter[(indexPath as NSIndexPath).row]["urlSlug"].string!
            let image = filter[(indexPath as NSIndexPath).row]["profilePicture"].string!
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
            print("in TWO")
            cell.profileName.text = followers[(indexPath as NSIndexPath).row]["name"].string!
            cell.urlSlurg.text = "@\(followers[(indexPath as NSIndexPath).row]["urlSlug"].string!)"
            if followers[(indexPath as NSIndexPath).row]["profilePicture"] != nil {
                print(followers[(indexPath as NSIndexPath).row]["profilePicture"].string!)
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
    
    func setImage(_ imageView: UIImageView, imageName: String) {
        
        let isUrl = verifyUrl(imageName)
        
        if imageName == "" {
            
            imageView.image = UIImage(named: "profile_icon")
            makeTLProfilePictureFollowers(imageView)
            
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
    
    func followUser(_ followName: String) {
        
        var followId: String!
        
        print("followers: \(followers)")
        
        for i in 0 ..< followers.count {
            
            if followers[i]["name"].string! == followName {
                
                followId = followers[i]["_id"].string!
                
            }
            
        }
        
        request.followUser(currentUser["_id"].string!, followUserId: followId, completion: {(response) in
            
            if response.error != nil {
                
                print("error: \(response.error!.localizedDescription)")
                
            }
            else if response["value"].bool! {
                
                print("response arrived!")

                
            }
            else {
                
                print("error: \(response["error"])")
                
            }
            })

        
    }
    
    func unFollowUser(_ unfollowName: String) {
        
        var unfollowId: String!
        
        print("followers: \(followers)")
        
        for i in 0 ..< followers.count {
            
            if followers[i]["name"].string! == unfollowName {
                
                unfollowId = followers[i]["_id"].string!
                
            }
            
        }
        
        request.unfollow(currentUser["_id"].string!, unFollowId: unfollowId, completion: {(response) in
            
            if response.error != nil {
                
                print("error: \(response.error!.localizedDescription)")
                
            }
            else if response["value"].bool! {
                
                print("response arrived!")
                
            }
            else {
                
                print("error: \(response["error"])")
                
            }
        })
        
        
    }

    //MARK: - Invite
    
    func inviteButtonClicked(sender: UIButton) {
        
        let textToShare = "Check out this application. This is awesome life :) "
        
        if let myWebsite = NSURL(string: "http://travelibro.com/") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard, UIActivityType.saveToCameraRoll]
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
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
            
            print("profile name follow: \(profileName.text)")
            parent.followUser(profileName.text!)
            sender.tag = 1
            sender.setImage(UIImage(named:"following"), for: .normal)
            sender.contentMode = .scaleAspectFit
            sender.clipsToBounds = true
            sender.isSelected = true
            
        }
            
        else if sender.tag == 1 {
            print("profile name unfollow: \(profileName.text)")
            parent.unFollowUser(profileName.text!)
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
    
}


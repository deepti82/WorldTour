
import UIKit


var followers: [JSON] = []

class FollowersViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {

    @IBOutlet var shareButtons: [UIButton]!
    @IBOutlet weak var mailShare: UIButton!
    @IBOutlet weak var whatsappShare: UIButton!
    @IBOutlet weak var facebookShare: UIButton!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var followerTable: UITableView!
    
    var whichView: String!
    var searchController: UISearchController!
    var shouldShowSearchResults = false
    var filter: [JSON]!
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followers = []
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        self.setOnlyLeftNavigationButton(leftButton)
        
        configureSearchController()
        
//        self.setCheckInNavigationBarItem(self)
        
        for button in shareButtons {
            
            button.layer.cornerRadius = 5
            
        }
        
        if whichView == "Following" {
            
            self.title = "Following"
            mailShare.setTitle(String(format: "%C", faicon["email"]!), for: UIControlState())
            whatsappShare.setTitle(String(format: "%C", faicon["whatsapp"]!), for: UIControlState())
            facebookShare.setTitle(String(format: "%C", faicon["facebook"]!), for: UIControlState())
            getFollowing()
//            searchController.searchBar
//            shareView.removeFromSuperview()
//            seperatorView.removeFromSuperview()
//            tableHeightConstraint.constant = self.view.frame.height
        }
        
        else if whichView == "No Followers" {
            
            shareView.removeFromSuperview()
            seperatorView.removeFromSuperview()
            followerTable.removeFromSuperview()
            
            let nofollow = NoFollowers(frame: CGRect(x: 0, y: 75, width: self.view.frame.width, height: 250))
            self.view.addSubview(nofollow)
            
        }
            
        else {
            
            mailShare.setTitle(String(format: "%C", faicon["email"]!), for: UIControlState())
            whatsappShare.setTitle(String(format: "%C", faicon["whatsapp"]!), for: UIControlState())
            facebookShare.setTitle(String(format: "%C", faicon["facebook"]!), for: UIControlState())
            getFollowers()
            
        }
        
    }
    
    func getFollowing() {
        
        print("inside following function")
        
        request.getFollowing(currentUser["_id"].string!, searchText: searchText, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("response: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    print("\(response["data"]["following"])")
                    followers = response["data"]["following"].array!
                    self.followerTable.reloadData()
                }
                else {
                    
                    print("response error: \(response["error"])")
                }
                
                
            })
            
            
        })
        
    }
    
    func getFollowers() {
        
        print("inside following function")
        request.getFollowers(currentUser["_id"].string!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    print("\(response["data"]["following"])")
                    followers = response["data"]["followers"].array!
                    self.followerTable.reloadData()
                    
                }
                else {
                    
                    print("response error: \(response["error"])")
                    
                }
                
            })
            
        })
        
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchController.dimsBackgroundDuringPresentation = true
        shouldShowSearchResults = true
        followerTable.reloadData()
        
    }
    
    func configureSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        followerTable.tableHeaderView = searchController.searchBar
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        shouldShowSearchResults = false
        followerTable.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !shouldShowSearchResults {
            
            shouldShowSearchResults = true
            followerTable.reloadData()
            
        }
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        searchController.dimsBackgroundDuringPresentation = false
        searchText = searchController.searchBar.text!
        
        // Filter the data array and get only those countries that match the search text.
//        filter = followers.filter({(follower) -> Bool in
//            
//            //            print("country: \(country["name"])")
//            
//            let text: NSString = follower["name"].string!
//            
//            print("country: \(text.rangeOfString(searchString!, options: .CaseInsensitiveSearch).location)")
//            
//            return (text.rangeOfString(searchString!, options: .CaseInsensitiveSearch).location) != NSNotFound
//        })
//        
//        //        filteredArray = countries.filter{$0["name"].string! == searchString}
//        
//        print("filtered array: \(filter)")
        
        getFollowing()
        
        // Reload the tableview.
        followerTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FollowersCell
        self.addStylingToButton(cell.followButton)
        cell.followButton.isSelected = false
        
        if filter != nil && shouldShowSearchResults {
            
            cell.profileName.text = filter[(indexPath as NSIndexPath).row]["name"].string!
            let image = filter[(indexPath as NSIndexPath).row]["profilePicture"].string!
            setImage(cell.profileImage, imageName: image)
            
            if let abc = filter[(indexPath as NSIndexPath).row]["following"].string {
                
                cell.followButton.tag = 1
                cell.followButton.backgroundColor = UIColor(red: 44/255, green: 55/255, blue: 87/255, alpha: 1)
                let followTick = UIImageView(frame: CGRect(x: -15, y: 2, width: 12, height: 12))
                followTick.image = UIImage(named: "correct-signal")
                cell.followButton.titleLabel?.addSubview(followTick)
                cell.followButton.setTitle("Following", for: UIControlState())
                cell.followButton.setTitleColor(UIColor.white, for: UIControlState())
                cell.followButton.contentHorizontalAlignment = .right
                cell.followButton.isSelected = true
                
            }
            
        }
        
        else if followers.count != 0 {
            
            cell.profileName.text = followers[(indexPath as NSIndexPath).row]["name"].string!
            let image = followers[(indexPath as NSIndexPath).row]["profilePicture"].string!
            setImage(cell.profileImage, imageName: image)
            
            if let abc = followers[(indexPath as NSIndexPath).row]["following"].string {
                
                cell.followButton.tag = 1
                cell.followButton.backgroundColor = UIColor(red: 44/255, green: 55/255, blue: 87/255, alpha: 1)
                let followTick = UIImageView(frame: CGRect(x: -15, y: 2, width: 12, height: 12))
                followTick.image = UIImage(named: "correct-signal")
                cell.followButton.titleLabel?.addSubview(followTick)
                cell.followButton.setTitle("Following", for: UIControlState())
                cell.followButton.setTitleColor(UIColor.white, for: UIControlState())
                cell.followButton.contentHorizontalAlignment = .right
                cell.followButton.isSelected = true
                
            }
            
        }
        
//        cell.followButton.addTarget(self, action: #selector(FollowersViewController.followUser(_:)), forControlEvents: .TouchUpInside)
//        cell.followButton.selected = false
        
        if whichView == "Following" {
            
            cell.followButton.tag = 1
            cell.followButton.backgroundColor = UIColor(red: 44/255, green: 55/255, blue: 87/255, alpha: 1)
            let followTick = UIImageView(frame: CGRect(x: -15, y: 2, width: 12, height: 12))
            followTick.image = UIImage(named: "correct-signal")
            cell.followButton.titleLabel?.addSubview(followTick)
            cell.followButton.setTitle("Following", for: UIControlState())
            cell.followButton.setTitleColor(UIColor.white, for: UIControlState())
            cell.followButton.contentHorizontalAlignment = .right
            cell.followButton.isSelected = true
            
        }
        
        return cell
        
    }
    
    func setImage(_ imageView: UIImageView, imageName: String) {
        
        let isUrl = verifyUrl(imageName)
        print("isUrl: \(isUrl)")
        
        if imageName == "" {
            
            imageView.image = UIImage(named: "profile_icon")
            makeTLProfilePicture(imageView)
            
        }
        
        else if isUrl {
            imageView.hnk_setImageFromURL(URL(string: imageName)!)
            makeTLProfilePicture(imageView)
        }
            
        else {
            
            let getImageUrl = adminUrl + "upload/readFile?file=" + imageName + "&width=100"
            
            print("getImageUrl: \(getImageUrl)")
            
            imageView.hnk_setImageFromURL(URL(string: getImageUrl)!)
            makeTLProfilePicture(imageView)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults && filter != nil {
            
            return filter.count
        }
        
        return followers.count
        
    }
    
    func addStylingToButton(_ sender: UIButton) {
        
        sender.layer.borderColor = UIColor(red: 44/255, green: 55/255, blue: 87/255, alpha: 1).cgColor
        sender.layer.borderWidth = 1.0
        sender.layer.cornerRadius = 5
        
    }
    
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
                
//                if self.whichView == "Following" && self.whichView != nil {
//                    
//                    self.getFollowing()
//                    
//                }
//                else {
//                    
//                    self.getFollowers()
//                }
                
            }
            else {
                
                print("error: \(response["error"])")
                
            }
            })
        
        
//        if !sender.selected {
//            
//            sender.backgroundColor = UIColor(red: 44/255, green: 55/255, blue: 87/255, alpha: 1)
//            let followTick = UIImageView(frame: CGRect(x: -15, y: 2, width: 12, height: 12))
//            followTick.image = UIImage(named: "correct-signal")
//            sender.titleLabel?.addSubview(followTick)
//            sender.setTitle("Following", forState: .Normal)
//            sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//            sender.contentHorizontalAlignment = .Right
//            sender.selected = true
//            
//        }
//        
//        else {
//            
//            sender.backgroundColor = UIColor.whiteColor()
//            sender.titleLabel?.textColor = UIColor.whiteColor()
//            sender.setTitle("+ Follow", forState: .Normal)
//            sender.setTitleColor(UIColor(red: 44/255, green: 55/255, blue: 87/255, alpha: 1), forState: .Normal)
//            sender.contentHorizontalAlignment = .Center
//            sender.selected = false
//            
//        }
        
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
                
//                if self.whichView == "Following" && self.whichView != nil {
//                    
//                    self.getFollowing()
//                    
//                }
//                else {
//                    
//                    self.getFollowers()
//                }
                
            }
            else {
                
                print("error: \(response["error"])")
                
            }
        })
        
        
    }

}

class FollowersCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var parent = FollowersViewController()
    
    @IBAction func followTap(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            print("profile name follow: \(profileName.text)")
            parent.followUser(profileName.text!)
            sender.tag = 1
            sender.backgroundColor = UIColor(red: 44/255, green: 55/255, blue: 87/255, alpha: 1)
            let followTick = UIImageView(frame: CGRect(x: -15, y: 2, width: 12, height: 12))
            followTick.image = UIImage(named: "correct-signal")
            sender.titleLabel?.addSubview(followTick)
            sender.setTitle("Following", for: UIControlState())
            sender.setTitleColor(UIColor.white, for: UIControlState())
            sender.contentHorizontalAlignment = .right
            sender.isSelected = true
            
        }
            
        else {
            print("profile name unfollow: \(profileName.text)")
            parent.unFollowUser(profileName.text!)
            sender.tag = 0
            sender.backgroundColor = UIColor.white
            sender.titleLabel?.textColor = UIColor.white
            sender.setTitle("+ Follow", for: UIControlState())
            sender.setTitleColor(UIColor(red: 44/255, green: 55/255, blue: 87/255, alpha: 1), for: UIControlState())
            sender.contentHorizontalAlignment = .center
            sender.isSelected = false
            
        }
    }
    
}


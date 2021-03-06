
import UIKit
import SwiftyJSON

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
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        
        self.setOnlyLeftNavigationButton(leftButton)
        
        configureSearchController()
        
//        self.setCheckInNavigationBarItem(self)
        
        for button in shareButtons {
            
            button.layer.cornerRadius = 5
            
        }
        
        if whichView == "Following" {
            
            self.title = "Following"
            mailShare.setTitle(String(format: "%C", faicon["email"]!), forState: .Normal)
            whatsappShare.setTitle(String(format: "%C", faicon["whatsapp"]!), forState: .Normal)
            facebookShare.setTitle(String(format: "%C", faicon["facebook"]!), forState: .Normal)
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
            
            mailShare.setTitle(String(format: "%C", faicon["email"]!), forState: .Normal)
            whatsappShare.setTitle(String(format: "%C", faicon["whatsapp"]!), forState: .Normal)
            facebookShare.setTitle(String(format: "%C", faicon["facebook"]!), forState: .Normal)
            getFollowers()
            
        }
        
    }
    
    func getFollowing() {
        
        print("inside following function")
        
        request.getFollowing(currentUser["_id"].string!, searchText: searchText, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("response: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"] {
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
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"] {
                    
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

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
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
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        shouldShowSearchResults = false
        followerTable.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        if !shouldShowSearchResults {
            
            shouldShowSearchResults = true
            followerTable.reloadData()
            
        }
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! FollowersCell
        self.addStylingToButton(cell.followButton)
        cell.followButton.selected = false
        
        if filter != nil && shouldShowSearchResults {
            
            cell.profileName.text = filter[indexPath.row]["name"].string!
            let image = filter[indexPath.row]["profilePicture"].string!
            setImage(cell.profileImage, imageName: image)
            
            if filter[indexPath.row]["following"] {
                
                cell.followButton.tag = 1
                cell.followButton.backgroundColor = UIColor(red: 44/255, green: 55/255, blue: 87/255, alpha: 1)
                let followTick = UIImageView(frame: CGRect(x: -15, y: 2, width: 12, height: 12))
                followTick.image = UIImage(named: "correct-signal")
                cell.followButton.titleLabel?.addSubview(followTick)
                cell.followButton.setTitle("Following", forState: .Normal)
                cell.followButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                cell.followButton.contentHorizontalAlignment = .Right
                cell.followButton.selected = true
                
            }
            
        }
        
        else if followers.count != 0 {
            
            cell.profileName.text = followers[indexPath.row]["name"].string!
            let image = followers[indexPath.row]["profilePicture"].string!
            setImage(cell.profileImage, imageName: image)
            
            if followers[indexPath.row]["following"] {
                
                cell.followButton.tag = 1
                cell.followButton.backgroundColor = UIColor(red: 44/255, green: 55/255, blue: 87/255, alpha: 1)
                let followTick = UIImageView(frame: CGRect(x: -15, y: 2, width: 12, height: 12))
                followTick.image = UIImage(named: "correct-signal")
                cell.followButton.titleLabel?.addSubview(followTick)
                cell.followButton.setTitle("Following", forState: .Normal)
                cell.followButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                cell.followButton.contentHorizontalAlignment = .Right
                cell.followButton.selected = true
                
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
            cell.followButton.setTitle("Following", forState: .Normal)
            cell.followButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            cell.followButton.contentHorizontalAlignment = .Right
            cell.followButton.selected = true
            
        }
        
        return cell
        
    }
    
    func setImage(imageView: UIImageView, imageName: String) {
        
        let isUrl = verifyUrl(imageName)
        print("isUrl: \(isUrl)")
        
        if imageName == "" {
            
            imageView.image = UIImage(named: "profile_icon")
            makeTLProfilePicture(imageView)
            
        }
        
        else if isUrl {
            
            print("inside if statement")
            let data = NSData(contentsOfURL: NSURL(string: imageName)!)
            
            if data != nil {
                
                print("some problem in data \(data)")
                //                uploadView.addButton.setImage(, forState: .Normal)
                imageView.image = UIImage(data: data!)
                makeTLProfilePicture(imageView)
            }
        }
            
        else {
            
            let getImageUrl = adminUrl + "upload/readFile?file=" + imageName + "&width=100"
            
            print("getImageUrl: \(getImageUrl)")
            
            let data = NSData(contentsOfURL: NSURL(string: getImageUrl)!)
//            print("data: \(data)")
            
            if data != nil {
                
                //                uploadView.addButton.setImage(UIImage(data:data!), forState: .Normal)
                print("inside if statement \(imageView.image)")
                imageView.image = UIImage(data: data!)
                //                print("sideMenu.profilePicture.image: \(profileImage.image)")
                makeTLProfilePicture(imageView)
            }
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults && filter != nil {
            
            return filter.count
        }
        
        return followers.count
        
    }
    
    func addStylingToButton(sender: UIButton) {
        
        sender.layer.borderColor = UIColor(red: 44/255, green: 55/255, blue: 87/255, alpha: 1).CGColor
        sender.layer.borderWidth = 1.0
        sender.layer.cornerRadius = 5
        
    }
    
    func followUser(followName: String) {
        
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
            else if response["value"] {
                
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
    
    func unFollowUser(unfollowName: String) {
        
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
            else if response["value"] {
                
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
    
    @IBAction func followTap(sender: UIButton) {
        
        if sender.tag == 0 {
            
            print("profile name follow: \(profileName.text)")
            parent.followUser(profileName.text!)
            sender.tag = 1
            sender.backgroundColor = UIColor(red: 44/255, green: 55/255, blue: 87/255, alpha: 1)
            let followTick = UIImageView(frame: CGRect(x: -15, y: 2, width: 12, height: 12))
            followTick.image = UIImage(named: "correct-signal")
            sender.titleLabel?.addSubview(followTick)
            sender.setTitle("Following", forState: .Normal)
            sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            sender.contentHorizontalAlignment = .Right
            sender.selected = true
            
        }
            
        else {
            print("profile name unfollow: \(profileName.text)")
            parent.unFollowUser(profileName.text!)
            sender.tag = 0
            sender.backgroundColor = UIColor.whiteColor()
            sender.titleLabel?.textColor = UIColor.whiteColor()
            sender.setTitle("+ Follow", forState: .Normal)
            sender.setTitleColor(UIColor(red: 44/255, green: 55/255, blue: 87/255, alpha: 1), forState: .Normal)
            sender.contentHorizontalAlignment = .Center
            sender.selected = false
            
        }
    }
    
}


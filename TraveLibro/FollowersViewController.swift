
import UIKit


var followers: [JSON] = []

class FollowersViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {


    @IBOutlet weak var followersDefaultText: UILabel!
    @IBOutlet var shareButtons: [UIButton]!
    @IBOutlet weak var mailShare: UIButton!
    @IBOutlet weak var whatsappShare: UIButton!
    @IBOutlet weak var facebookShare: UIButton!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var followerTable: UITableView!
   
    var loader = LoadingOverlay()
    var whichView: String!
    var searchController: UISearchController!
    var shouldShowSearchResults = false
    var filter: [JSON]!
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGround(self)
        followers = []
        loader.showOverlay(self.view)
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        self.setOnlyLeftNavigationButton(leftButton)
        
        
        
        for button in shareButtons {
            
            button.layer.cornerRadius = 5
            
        }
        
        if whichView == "Following" {
            self.title = "Following"
            mailShare.setTitle(String(format: "%C", faicon["envelop"]!), for: UIControlState())
            whatsappShare.setTitle(String(format: "%C", faicon["whatsapp"]!), for: UIControlState())
//            facebookShare.setTitle(String(format: "%C", faicon["fbSquare"]!), for: UIControlState())
            configureSearchController()
            getFollowing()
            
        } else if whichView == "No Followers" {
            shareView.removeFromSuperview()
            seperatorView.removeFromSuperview()
            followerTable.removeFromSuperview()
            let nofollow = NoFollowers(frame: CGRect(x: 0, y: 75, width: self.view.frame.width, height: 250))
            self.view.addSubview(nofollow)
            followersDefaultText.isHidden = true
        } else {
            mailShare.setTitle(String(format: "%C", faicon["email"]!), for: UIControlState())
            whatsappShare.setTitle(String(format: "%C", faicon["whatsapp"]!), for: UIControlState())
//            facebookShare.setTitle(String(format: "%C", faicon["facebook"]!), for: UIControlState())
            getFollowers()
            followersDefaultText.isHidden = true
        }
    }
    
    func getFollowing() {
        
        print("inside following function")
        self.loader.hideOverlayView()
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
        self.loader.hideOverlayView()
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
        if whichView == "Following" {
            
            getFollowing()
        }else{
            getFollowers()
            followersDefaultText.isHidden = true
        }
        followerTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FollowersCell
        self.addStylingToButton(cell.followButton)
        cell.followButton.isSelected = false
        
        if filter != nil && shouldShowSearchResults {
            print("in ONE")
            cell.profileName.text = filter[(indexPath as NSIndexPath).row]["name"].string!
            cell.urlSlurg.text =  filter[(indexPath as NSIndexPath).row]["urlSlug"].string!
            let image = filter[(indexPath as NSIndexPath).row]["profilePicture"].string!
            setImage(cell.profileImage, imageName: image)
            
            
            if filter[(indexPath as NSIndexPath).row]["following"].boolValue {
                cell.followButton.tag = 1
                cell.followButton.setImage(UIImage(named:"following"), for: .normal)
                cell.followButton.contentMode = .scaleAspectFit
                cell.followButton.clipsToBounds = true
                cell.followButton.isSelected = true
            }else{
                cell.followButton.tag = 0
                cell.followButton.setImage(UIImage(named:"follow"), for: .normal)
                cell.followButton.contentMode = .scaleAspectFit
                cell.followButton.clipsToBounds = true
                cell.followButton.isSelected = true
            }
            
            
            
        } else if followers.count != 0 {
            print("in TWO")
            
            cell.profileName.text = followers[(indexPath as NSIndexPath).row]["name"].string!
            cell.urlSlurg.text = "@\(followers[(indexPath as NSIndexPath).row]["urlSlug"].string!)"
            if followers[(indexPath as NSIndexPath).row]["profilePicture"] != nil {
                print("yaaa hoooo")
                print(followers[(indexPath as NSIndexPath).row]["profilePicture"].string!)
                let image = followers[(indexPath as NSIndexPath).row]["profilePicture"].string!
                setImage(cell.profileImage, imageName: image)
            }
            
            
            if followers[(indexPath as NSIndexPath).row]["following"].boolValue {
                
                cell.followButton.tag = 1
//                cell.followButton.backgroundColor = UIColor(red: 44/255, green: 55/255, blue: 87/255, alpha: 1)
//                let followTick = UIImageView(frame: CGRect(x: -18, y: 4, width: 12, height: 12))
//                followTick.image = UIImage(named: "correct-signal")
//                cell.followButton.titleLabel?.addSubview(followTick)
//                cell.followButton.setTitle("Following", for: UIControlState())
//                cell.followButton.setTitleColor(UIColor.white, for: UIControlState())
//                cell.followButton.contentHorizontalAlignment = .right
//                cell.followButton.titleLabel?.textAlignment = .center
                cell.followButton.setImage(UIImage(named:"following"), for: .normal)
                cell.followButton.contentMode = .scaleAspectFit
                cell.followButton.clipsToBounds = true
                cell.followButton.isSelected = true
            }else{
                cell.followButton.tag = 0
                cell.followButton.setImage(UIImage(named:"follow"), for: .normal)
                cell.followButton.contentMode = .scaleAspectFit
                cell.followButton.clipsToBounds = true
                cell.followButton.isSelected = true

                cell.followButton.isSelected = true
            }
            
            
        }

        
        return cell
        
    }
    
    func setImage(_ imageView: UIImageView, imageName: String) {
        
        let isUrl = verifyUrl(imageName)
        print("isUrl: \(isUrl)")
        
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
            
            print("getImageUrl: \(getImageUrl)")
            
            imageView.hnk_setImageFromURL(URL(string: getImageUrl)!)
            makeTLProfilePictureFollowers(imageView)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults && filter != nil {
            
            return filter.count
        }else{
        
        return followers.count
        }
        
    }
    
    func addStylingToButton(_ sender: UIButton) {
        
//        sender.layer.borderColor = UIColor(red: 44/255, green: 55/255, blue: 87/255, alpha: 1).cgColor
////        sender.layer.borderWidth = 1.0
//          sender.layer.cornerRadius = 5
        
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
            
        else {
            print("profile name unfollow: \(profileName.text)")
            parent.unFollowUser(profileName.text!)
            sender.tag = 0
            sender.setImage(UIImage(named:"follow"), for: .normal)
            sender.contentMode = .scaleAspectFit
            sender.clipsToBounds = true
            sender.isSelected = false
            
        }
    }
    
}


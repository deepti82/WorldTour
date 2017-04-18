//
//  LikeUserViewController.swift
//  TraveLibro
//
//  Created by Jagruti  on 03/03/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

var likeDataArray:JSON = []

class LikeUserViewController: UITableViewController {
    
    var postId:String = ""
    var userId:String = ""
    var pagenumber:Int = 1    
    var type:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigation()
        likeDataArray = []
        loadLikes(page: pagenumber)
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "back_7_4"))
        self.tableView.tableFooterView = UIView()
    }
    
    func loadLikes(page:Int) {
        print(type)
        loader.showOverlay(self.view)
        
        
        switch type {
        case "on-the-go-journey", "ended-journey":
            request.getJourneyLikes(userId: user.getExistingUser(), id: postId, pagenumber: pagenumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    loader.hideOverlayView()
                    
                    likeDataArray = request["data"]["like"]
                    self.reloadTableView()
                })
            })
        case "quick-itinerary", "detail-itinerary":
            request.getItineraryLikes(userId: user.getExistingUser(), id: postId, pagenumber: pagenumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    loader.hideOverlayView()
                    
                    likeDataArray = request["data"]["like"]
                    self.reloadTableView()
                })
            })
        case "photo":
            request.getPhotoLikes(userId: user.getExistingUser(), id: postId, pagenumber: pagenumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    loader.hideOverlayView()
                    
                    likeDataArray = request["data"]["like"]
                    self.reloadTableView()
                })
            })
        case "video":
            request.getVideoLikes(userId: user.getExistingUser(), id: postId, pagenumber: pagenumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    loader.hideOverlayView()
                    
                    likeDataArray = request["data"]["like"]
                    self.reloadTableView()
                })
            })
        default:
            request.getLikes(userId: user.getExistingUser(), post: postId, pagenumber: pagenumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    loader.hideOverlayView()
                    
                    likeDataArray = request["data"]["like"]
                    self.reloadTableView()
                })
            })
        }
        
    }
    
    func reloadTableView(){
        self.title = "Likes (\(likeDataArray.count))"
        self.tableView.reloadData()
    }
    
    func createNavigation() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.imageView?.image = leftButton.imageView?.image!.withRenderingMode(.alwaysTemplate)
        leftButton.imageView?.tintColor = UIColor.white
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        self.customNavigationBar(left: leftButton, right: nil)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likeDataArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "likeCell", for: indexPath) as! LikeCell
        cell.profileName.text = likeDataArray[indexPath.row]["name"].stringValue
        cell.profileImage.hnk_setImageFromURL(getImageURL(likeDataArray[indexPath.row]["profilePicture"].stringValue, width: 300))
        cell.urlSlurg.text = "@\(likeDataArray[indexPath.row]["urlSlug"].stringValue)"
        
        setFollowButtonImage(button: cell.followButton, followType: likeDataArray[indexPath.row]["following"].intValue, otherUserID: likeDataArray[indexPath.row]["_id"].stringValue)
        
        makeBuddiesTLProfilePicture(cell.profileImage)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        selectedPeople = likeDataArray[indexPath.row]["_id"].stringValue
        selectedUser = likeDataArray[indexPath.row]
        
        let profile = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        profile.displayData = "search"
        profile.currentSelectedUser = likeDataArray[indexPath.row]
        globalNavigationController.pushViewController(profile, animated: true)
    }
    
    //MARK: - Follow actions 
    
    func followUser(_ followName: String, sender: UIButton) {
        
        var followId: String!
        
        for i in 0 ..< likeDataArray.count {
            
            if likeDataArray[i]["urlSlug"].string! == followName {
                
                followId = likeDataArray[i]["_id"].string!
                break
            }
            
        }
        
        request.followUser(user.getExistingUser(), followUserId: followId, completion: {(response) in
            DispatchQueue.main.async(execute: {
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    print("response arrived!")
                    setFollowButtonTitle(button: sender, followType: response["data"]["responseValue"].intValue, otherUserID: "")
                }
                else {
                    
                    print("error: \(response["error"])")
                    
                }
            })
        })       
    }
    
    func unFollowUser(_ unfollowName: String, sender: UIButton) {
        
        var unfollowId: String!
        
        for i in 0 ..< likeDataArray.count {
            
            if likeDataArray[i]["urlSlug"].string! == unfollowName {                
                unfollowId = likeDataArray[i]["_id"].string!
                break
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
                    setFollowButtonTitle(button: sender, followType: response["data"]["responseValue"].intValue, otherUserID: "")
                }
                else {
                    
                    print("error: \(response["error"])")
                    
                }                
            })
            
        })
        
        
    }
    
}

class LikeCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!    
    @IBOutlet weak var urlSlurg: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var parent = LikeUserViewController()
    
    @IBAction func followTap(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            print("profile name follow: \(profileName.text)")            
            parent.followUser(getURLSlug(slug: urlSlurg.text!), sender: sender)
            sender.tag = 1
            sender.setImage(UIImage(named:"following"), for: .normal)
            sender.contentMode = .scaleAspectFit
            sender.clipsToBounds = true
            sender.isSelected = true
            
        }
            
        else if sender.tag == 1 {
            print("profile name unfollow: \(profileName.text)")
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
    
}

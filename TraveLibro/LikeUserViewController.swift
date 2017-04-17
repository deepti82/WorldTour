//
//  LikeUserViewController.swift
//  TraveLibro
//
//  Created by Jagruti  on 03/03/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class LikeUserViewController: UITableViewController {
    
    var postId:String = ""
    var userId:String = ""
    var pagenumber:Int = 1
    var data:JSON = []
    var type:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigation()
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
                    
                    self.data = request["data"]["like"]
                    self.reloadTableView()
                })
            })
        case "quick-itinerary", "detail-itinerary":
            request.getItineraryLikes(userId: user.getExistingUser(), id: postId, pagenumber: pagenumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    loader.hideOverlayView()
                    
                    self.data = request["data"]["like"]
                    self.reloadTableView()
                })
            })
        case "photo":
            request.getPhotoLikes(userId: user.getExistingUser(), id: postId, pagenumber: pagenumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    loader.hideOverlayView()
                    
                    self.data = request["data"]["like"]
                    self.reloadTableView()
                })
            })
        case "video":
            request.getVideoLikes(userId: user.getExistingUser(), id: postId, pagenumber: pagenumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    loader.hideOverlayView()
                    
                    self.data = request["data"]["like"]
                    self.reloadTableView()
                })
            })
        default:
            request.getLikes(userId: user.getExistingUser(), post: postId, pagenumber: pagenumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    loader.hideOverlayView()
                    
                    self.data = request["data"]["like"]
                    self.reloadTableView()
                })
            })
        }
        
    }
    
    func reloadTableView(){
        self.title = "Likes (\(self.data.count))"
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
        return self.data.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "likeCell", for: indexPath) as! LikeCell
        cell.profileName.text = self.data[indexPath.row]["name"].stringValue
        cell.profileImage.hnk_setImageFromURL(getImageURL(self.data[indexPath.row]["profilePicture"].stringValue, width: 300))
        cell.urlSlurg.text = "@\(self.data[indexPath.row]["urlSlug"].stringValue)"
        makeBuddiesTLProfilePicture(cell.profileImage)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        selectedPeople = self.data[indexPath.row]["_id"].stringValue
        selectedUser = self.data[indexPath.row]
        
        let profile = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        profile.displayData = "search"
        profile.currentSelectedUser = self.data[indexPath.row]
        globalNavigationController.pushViewController(profile, animated: true)
    }
    
}

class LikeCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!    
    @IBOutlet weak var urlSlurg: UILabel!
    
    var parent = FollowersViewController()
    
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

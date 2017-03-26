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
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "darkBgNew"))
        self.tableView.tableFooterView = UIView()
    }
    
    func loadLikes(page:Int) {
        print(type)
        if type == "on-the-go-journey" || type == "ended-journey" {
            request.getJourneyLikes(userId: currentUser["_id"].stringValue, id: postId, pagenumber: pagenumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    
                    self.data = request["data"]["like"]
                    self.tableView.reloadData()
                })
            })
        } else if type == "quick-itinerary" || type == "detail-itinerary" {
            request.getItineraryLikes(userId: currentUser["_id"].stringValue, id: postId, pagenumber: pagenumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    
                    self.data = request["data"]["like"]
                    self.tableView.reloadData()
                })
            })
        } else {
            request.getLikes(userId: currentUser["_id"].stringValue, post: postId, pagenumber: pagenumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    
                    self.data = request["data"]["like"]
                    self.tableView.reloadData()
                })
            })
        }
        
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
        cell.urlSlurg.text = self.data[indexPath.row]["urlSlug"].stringValue
        makeTLProfilePicture(cell.profileImage)
        return cell
    }
    
    
}

class LikeCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var urlSlurg: UILabel!
    
    var parent = FollowersViewController()
    
    @IBAction func followTap(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            print("profile name follow: \(profileName.text)")
            parent.followUser(profileName.text!, sender: sender)
            sender.tag = 1
            sender.setImage(UIImage(named:"following"), for: .normal)
            sender.contentMode = .scaleAspectFit
            sender.clipsToBounds = true
            sender.isSelected = true
            
        }
            
        else {
            print("profile name unfollow: \(profileName.text)")
            parent.unFollowUser(profileName.text!, sender: sender)
            sender.tag = 0
            sender.setImage(UIImage(named:"follow"), for: .normal)
            sender.contentMode = .scaleAspectFit
            sender.clipsToBounds = true
            sender.isSelected = false
            
        }
    }
    
}

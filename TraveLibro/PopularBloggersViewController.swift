//
//  PopularBloggersViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 13/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Toaster

class PopularBloggersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var allUsers: [JSON] = []
    var pagenum = 1
    var loader = LoadingOverlay()
    var hasNext = true
    
    @IBOutlet weak var userTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarItem()
        
        loader.showOverlay(self.view)
        
        getPopulerUser(pageNum : pagenum )
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - GetUsers
    func getPopulerUser(pageNum : Int) {
        
        request.getPopularUsers(pagenumber: pageNum) { (response) in
            
            DispatchQueue.main.async(execute: {
                self.loader.hideOverlayView()
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    let newResponse = response["data"].array!
                    
                    if newResponse.isEmpty {
                        self.hasNext = false
                    }
                    
                    if self.allUsers.isEmpty {
                        self.allUsers = newResponse
                        if newResponse.isEmpty {
                            Toast(text: "No notifications for you....").show()
                        }
                    }
                    else {                        
                        self.allUsers.append(contentsOf: newResponse)
                    }
                    
                    if !(newResponse.isEmpty) {
                        self.userTableView.reloadData()                            
                    }                        
                }
                else {
                    
                    print("response error!")
                    
                }
                
            })
            
        }
        
    }
    
    
    //MARK: - Tableview Delegates and Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allUsers.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "popularCell") as! PopularBloggerTableViewCell
        cell.titleTag.layer.cornerRadius = 5
        cell.titleTag.layer.borderColor = mainBlueColor.cgColor
        cell.titleTag.layer.borderWidth = 1.5
        cell.cameraIcon.tintColor = mainBlueColor
        cell.videoIcon.tintColor = mainBlueColor
        cell.locationIcon.tintColor = mainBlueColor
        cell.selectionStyle = .none
        
        let cellData = allUsers[indexPath.row]        
        
        cell.userIcon.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(cellData["profilePicture"].stringValue)", width: 100))
        
        cell.userIcon.layer.masksToBounds = false
        cell.userIcon.layer.borderColor = UIColor.clear.cgColor
        cell.userIcon.layer.cornerRadius = cell.userIcon.frame.size.width/2
        cell.userIcon.clipsToBounds = true
        
        cell.userName.text = cellData["name"].stringValue
       
        cell.photoCountLabel.text = cellData["photos_count"].stringValue
        cell.videoCountLabel.text = cellData["videos_count"].stringValue
        cell.bucketListCount.text = cellData["checkins_count"].stringValue
        
        cell.countryVisitedCountLabel.text =  "Countries visited : " + cellData["countriesVisited_count"].stringValue
        cell.journeyCountLabel.text =  "Journeys : " + cellData["journeysCreated_count"].stringValue        
        cell.followerCountLabel.text = "Followers : " + cellData["followers_count"].stringValue
        
        cell.userBadgeImage.image = UIImage(named:cellData["userBadgeName"].stringValue.lowercased())
        
        return cell
        
    }

}


class PopularBloggerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleTag: UIView!
    @IBOutlet weak var cameraIcon: UIImageView!
    @IBOutlet weak var videoIcon: UIImageView!
    @IBOutlet weak var locationIcon: UIImageView!
    
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var photoCountLabel: UILabel!
    @IBOutlet weak var videoCountLabel: UILabel!
    @IBOutlet weak var bucketListCount: UILabel!
    
    @IBOutlet weak var countryVisitedCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var journeyCountLabel: UILabel!
    
    @IBOutlet weak var userBadgeImage: UIImageView!
    
}

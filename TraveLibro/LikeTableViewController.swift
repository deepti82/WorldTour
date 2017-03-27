//
//  LikeTableViewController.swift
//  TraveLibro
//
//  Created by Jagruti  on 01/03/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class LikeTableViewController: UITableViewController {
    
    var postId:String = ""
    var userId:String = ""
    var pagenumber:Int = 1
    var data:JSON = []
    var type:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigation()
        loadLikes(page: pagenumber)
    }

    func loadLikes(page:Int) {
        loader.showOverlay(self.view)
        print(type)
        if type == "on-the-go-journey" || type == "ended-journey" {
            request.getJourneyLikes(userId: currentUser["_id"].stringValue, id: postId, pagenumber: pagenumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    loader.hideOverlayView()
                    
                    self.data = request["data"]["like"]
                    self.tableView.reloadData()
                })
            })
        } else if type == "quick-itinerary" || type == "detail-itinerary" {
            request.getItineraryLikes(userId: currentUser["_id"].stringValue, id: postId, pagenumber: pagenumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    loader.hideOverlayView()
                    
                    self.data = request["data"]["like"]
                    self.tableView.reloadData()
                })
            })
        } else {
            request.getLikes(userId: currentUser["_id"].stringValue, post: postId, pagenumber: pagenumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    loader.hideOverlayView()
                    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "likeCell", for: indexPath)
        cell.imageView?.hnk_setImageFromURL(getImageURL(self.data[indexPath.row]["profilePicture"].stringValue, width: 200))
        cell.textLabel?.text = self.data[indexPath.row]["name"].stringValue
        cell.detailTextLabel?.text = self.data[indexPath.row]["urlSlug"].stringValue
        return cell
    }
    

}

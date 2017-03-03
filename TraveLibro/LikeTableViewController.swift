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

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLikes(page: pagenumber)
    }

    func loadLikes(page:Int) {
        request.getLikes(userId: currentUser["_id"].stringValue, post: postId, pagenumber: pagenumber, completion: {(request) in
            DispatchQueue.main.async(execute: {

            self.data = request["data"]["like"]
            self.tableView.reloadData()
            })
        })
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

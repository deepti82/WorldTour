//
//  FollowersViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 31/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class FollowersViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var mailShare: UIButton!
    @IBOutlet weak var whatsappShare: UIButton!
    @IBOutlet weak var facebookShare: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarItem()
        
        let email = String(format: "%C", faicon["email"]!)
        
        mailShare.setTitle(email, forState: .Normal)
        whatsappShare.setTitle(String(format: "%C", faicon["whatsapp"]!), forState: .Normal)
        facebookShare.setTitle(String(format: "%C", faicon["facebook"]!), forState: .Normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! FollowersCell
        
        let followTick = UIImageView(frame: CGRect(x: -17, y: 0, width: 15, height: 15))
        followTick.image = UIImage(named: "correct-signal")
        cell.followButton.titleLabel?.addSubview(followTick)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return 10
        
    }

}

class FollowersCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
}


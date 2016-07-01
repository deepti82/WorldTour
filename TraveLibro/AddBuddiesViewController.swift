//
//  AddBuddiesViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 28/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class AddBuddiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var removeBuddyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addCheckIn = storyboard?.instantiateViewControllerWithIdentifier("addCheckIn") as! AddCheckInViewController
        
        setCheckInNavigationBarItem(addCheckIn)
        
        let search = SearchFieldView(frame: CGRect(x: 45, y: 0, width: searchView.frame.width - 10, height: searchView.frame.height))
        searchView.addSubview(search)
        
        let close = String(format: "%C", faicon["close"]!)
        removeBuddyButton.setTitle(close, forState: .Normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 12
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell")
        return cell!
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Add Friends"
    }

}

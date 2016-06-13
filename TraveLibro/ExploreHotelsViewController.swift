//
//  ExploreHotelsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 11/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ExploreHotelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let hotelNames = ["The Taj", "Trident, Nariman Point", "The Taj", "Trident, Nariman Point"]
    
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let hotelTypesLayer = HotelTypeSelect(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//        hotelTypesLayer.layer.zPosition = 100
//        self.view.addSubview(hotelTypesLayer)
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60))
        scrollView.contentSize.height = 2500
        scrollView.layer.zPosition = 100
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        let filterVC = storyboard?.instantiateViewControllerWithIdentifier("FilterViewController") as! FilterCheckboxesViewController
        addChildViewController(filterVC)
        filterVC.view.frame.size.height = scrollView.contentSize.height
        scrollView.addSubview(filterVC.view)
        filterVC.didMoveToParentViewController(self)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("hotelCell") as! HotelsTableViewCell
        cell.hotelNames.text = hotelNames[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // Dequeue with the reuse identifier
        let headerView = HotelsCustomHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 85))
        return headerView
    }

}


class HotelsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hotelNames: UILabel!
    @IBOutlet weak var hotelExpense: UILabel!
    
}

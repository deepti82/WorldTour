//
//  CheckInSearchViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 28/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class CheckInSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let CILabels = ["TING - Creative Lounge", "Interlink Banquets", "CocoGanache", "Jolly Gymkhana", "Ltt Terminus Railway Station Kurla", "Mental Masala", "White rivers Digital", "Rainforest Cafe In Pheonix Market City Kurla", "Rudra Centre", "Neelkanth Business Park", "TING - Creative Lounge", "Interlink Banquets", "CocoGanache", "Jolly Gymkhana", "Ltt Terminus Railway Station Kurla", "Mental Masala", "White rivers Digital", "Rainforest Cafe In Pheonix Market City Kurla", "Rudra Centre", "Neelkanth Business Park"]
    
    let CIDetailsLabels = ["0.3 mi - 13 check-ins", "0.3 mi - 13 check-ins", "0.3 mi - 13 check-ins", "0.3 mi - 13 check-ins", "0.3 mi - 13 check-ins", "0.3 mi - 13 check-ins", "0.3 mi - 13 check-ins", "0.3 mi - 13 check-ins", "0.3 mi - 13 check-ins", "0.3 mi - 13 check-ins", "0.3 mi - 13 check-ins", "0.3 mi - 13 check-ins", "0.3 mi - 13 check-ins", "0.3 mi - 13 check-ins", "0.3 mi - 13 check-ins", "0.3 mi - 13 check-ins", "0.3 mi - 13 check-ins", "0.3 mi - 13 check-ins", "0.3 mi - 13 check-ins", "0.3 mi - 13 check-ins"]
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchIcon: UIImageView!
    
    var whichView = "LL"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchView = SearchFieldView(frame: CGRect(x: 55, y: 15, width: 300, height: 30))
        searchView.bottomLine.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        searchView.leftLine.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        searchView.rightLine.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        self.searchView.addSubview(searchView)
        
        if whichView == "TL" {
            
            searchIcon.image = UIImage(named: "location_TL")
            searchView.searchButton.tintColor = mainOrangeColor
            
        }
        
        else {
            
            searchView.searchButton.tintColor = mainGreenColor
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return CILabels.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! CheckInTableViewCell
        cell.checkInTitle.text = CILabels[indexPath.row]
        cell.checkInDetailType.text = CIDetailsLabels[indexPath.row]
        cell.checkInDetail.image = UIImage(named: "close_local_life")
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectCategoryVC = storyboard?.instantiateViewControllerWithIdentifier("checkInCategory") as! CategoriseCheckInViewController
        selectCategoryVC.whichView = self.whichView
        self.navigationController?.pushViewController(selectCategoryVC, animated: true)
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class CheckInTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkInTitle: UILabel!
    @IBOutlet weak var checkInDetailType: UILabel!
    @IBOutlet weak var checkInDetail: UIImageView!
    
}


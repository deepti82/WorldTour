//
//  PopularBloggersViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 13/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class PopularBloggersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
        
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
        return cell
        
    }
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        
//        return 2
//        
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


class PopularBloggerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleTag: UIView!
    @IBOutlet weak var cameraIcon: UIImageView!
    @IBOutlet weak var videoIcon: UIImageView!
    @IBOutlet weak var locationIcon: UIImageView!
    
}

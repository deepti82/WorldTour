//
//  NearMeDetailViewController.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 21/11/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class NearMeDetailViewController: UIViewController {
    
    var nearMeDetailJSON: JSON!
    
    var currentLat: String!
    var currentLong: String!
    
    var nearMeLat: String!
    var nearMeLong: String!
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var openingHours: UILabel!
    
    var nearMeDistance = NSMutableAttributedString()
    var nearMeAddress = NSMutableAttributedString()
    var nearMePhone = NSMutableAttributedString()
    var nearMeOpeningHours = NSMutableAttributedString()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGround(self)
        navigationController?.hidesBarsOnSwipe = false
        
        detailView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        name.text = nearMeDetailJSON["name"].string!
            
        nearMeLat = nearMeDetailJSON["geometry"]["location"]["lat"].string!
        nearMeLong = nearMeDetailJSON["geometry"]["location"]["lng"].string!

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

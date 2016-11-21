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
    var nearMePlaceId: String!
    
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
        
        getPlaceDetail()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPlaceDetail() {
        request.getNearMeDetail(placeId: nearMePlaceId, completion: {(response) in
            DispatchQueue.main.async(execute: {
                if response.error != nil {
                    print("error: \(response.error!.localizedDescription)")
                } else if response["value"].bool! {
                    self.nearMeDetailJSON = response["data"]
                    
                    self.name.text = self.nearMeDetailJSON["name"].string!
                    
                    self.nearMeDistance = NSMutableAttributedString(string: "Distance from You :", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!])
                    self.nearMeDistance.append(NSAttributedString(string: " 0.08m", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!]))
                    
                    self.nearMeAddress = NSMutableAttributedString(string: "Address :", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
                    self.nearMeAddress.append(NSAttributedString(string: " \(self.nearMeDetailJSON["vicinity"].string!)", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!]))
                    
                    self.nearMePhone = NSMutableAttributedString(string: "Phone :", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
                    self.nearMePhone.append(NSAttributedString(string: " \(self.nearMeDetailJSON["vicinity"].string!)", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!]))
                    
                    self.nearMeLat = self.nearMeDetailJSON["geometry"]["location"]["lat"].string!
                    self.nearMeLong = self.nearMeDetailJSON["geometry"]["location"]["lng"].string!
                    
                } else {
                    print("response error")
                }
            })
        })
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

//
//  NearMeListViewController.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 18/11/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class NearMeListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var city: String!
    var nearMeType: String!
    var ratingIndex: Int!
    var nearMeListJSON: [JSON] = []
    var nearMeAddress = NSMutableAttributedString()
    
    let lat = "19.0451378"
    let long = "72.8632416"

    @IBOutlet weak var nearMeListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGround(self)
        navigationController?.hidesBarsOnSwipe = false
        //nearMeListTableView.isHidden = true
        
        nearMeListTableView.delegate = self
        nearMeListTableView.dataSource = self
        getNearMeValues()
    }
    
    func getNearMeValues() {
        
        print(nearMeType)
        
        request.getNearMeList(lat: lat, long: long, type: nearMeType, completion: {(response) in
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    print("error: \(response.error!.localizedDescription)")
                }
                else if response["value"].bool! {
                    
                    self.nearMeListJSON = response["data"].array!
                    self.nearMeListTableView.reloadData()
                }
                else {
                    print("response error")
                }
                self.nearMeListTableView.reloadData()
            })
            //self.nearMeListTableView.isHidden = false
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.nearMeListJSON.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "nearMeList", for: indexPath) as! NearMeListCell
        
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        for star in cell.stars {
            star.setImage(UIImage(named: "star_uncheck")?.withRenderingMode(.alwaysTemplate), for: UIControlState())
            star.setImage(UIImage(named: "star_check")?.withRenderingMode(.alwaysTemplate), for: .selected)
            star.setImage(UIImage(named: "star_check")?.withRenderingMode(.alwaysTemplate), for: [.highlighted, .selected])
            star.imageView?.tintColor = UIColor.darkGray
            star.adjustsImageWhenHighlighted = false
        }
        
        cell.listName.text = nearMeListJSON[indexPath.section]["name"].string!
        nearMeAddress = NSMutableAttributedString(string: "Address:", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
        nearMeAddress.append(NSAttributedString(string: " \(nearMeListJSON[indexPath.section]["vicinity"].string!)", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!]))
        cell.listAddress.attributedText = nearMeAddress
        if nearMeListJSON[indexPath.section]["rating"] != nil {
            let rating = nearMeListJSON[indexPath.section]["rating"]
            print("\(nearMeListJSON[indexPath.section]["name"].string!): \(rating)")
            for (index, star) in cell.stars.enumerated() {
                star.isSelected = index < Int(roundf(rating.floatValue))
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nearMeDetailController = storyboard?.instantiateViewController(withIdentifier: "nearMeDetail") as! NearMeDetailViewController
        //nearMeDetailController.nearMeDetailJSON = nearMeListJSON[indexPath.section]
        nearMeDetailController.nearMePlaceId = nearMeListJSON[indexPath.section]["place_id"].string!
        navigationController?.pushViewController(nearMeDetailController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let invisibleView = UIView()
        invisibleView.backgroundColor = UIColor.clear
        return invisibleView
    }

}

class NearMeListCell: UITableViewCell {
    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var listAddress: UILabel!
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet var stars: [UIButton]!
}

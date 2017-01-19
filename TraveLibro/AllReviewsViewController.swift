//
//  AllReviewsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 30/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class AllReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let labels = ["Girgaon Beach", "Colaba Social", "Girgaon Beach", "Colaba Social", "Girgaon Beach", "Colaba Social", "Girgaon Beach"]
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGround(self)
        
        addRadiosToButtons(button1)
        addRadiosToButtons(button2)
        addRadiosToButtons(button3)
        
        addShadowsToViews(view1)
        addShadowsToViews(view2)
        addShadowsToViews(view3)
        
        print("bounds view 3: \(view3.frame.origin.x), \(view3.frame.origin.y)")
        
        let titleTab1 = UIButton(frame: CGRect(x: view3.frame.origin.x + 8, y: view3.frame.origin.y - 30, width: 122, height: 35))
        titleTab1.setTitle("Journeys", for: UIControlState())
        titleTab1.titleLabel?.font = avenirFont
        titleTab1.backgroundColor = mainOrangeColor
        titleTab1.layer.cornerRadius = 5
        self.view.addSubview(titleTab1)
        
        let titleTab2 = UIButton(frame: CGRect(x: view3.frame.origin.x + 128, y: view3.frame.origin.y - 30, width: 122, height: 43))
        titleTab2.setTitle("Moments", for: UIControlState())
        titleTab2.titleLabel?.font = avenirFont
        titleTab2.backgroundColor = mainOrangeColor
        titleTab2.layer.cornerRadius = 5
        self.view.addSubview(titleTab2)
        
        let titleTab3 = UIButton(frame: CGRect(x: view3.frame.origin.x + (120 * 2) + 8, y: view3.frame.origin.y - 30, width: 110, height: 51))
        titleTab3.setTitle("Reviews", for: UIControlState())
        titleTab3.titleLabel?.font = avenirFont
        titleTab3.backgroundColor = mainOrangeColor
        titleTab3.layer.cornerRadius = 5
        self.view.addSubview(titleTab3)
        
        view3.layer.zPosition = 10
        titleTab2.layer.zPosition = 11
        view2.layer.zPosition = 12
        titleTab3.layer.zPosition = 13
        view1.layer.zPosition = 14
        
        addStylesToTabs(titleTab1)
        addStylesToTabs(titleTab2)
        addStylesToTabs(titleTab3)
        
//        self.view.bringSubviewToFront(view2)
//        self.view.bringSubviewToFront(titleTabs.momentsButton)
//        self.view.bringSubviewToFront(view1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! allReviewsTableViewCell
        
        let timestamp = DateAndTime(frame: CGRect(x: 0, y: 0, width: cell.timestampView.frame.width, height: cell.timestampView.frame.height))
        cell.timestampView.addSubview(timestamp)
        
        cell.reviewLocation.text = "Mumbai, India"
        cell.reviewTitle.text = labels[(indexPath as NSIndexPath).item]
        
        let ratingSuperviewWidth:Int = Int(cell.ratingSuperview.frame.width)
        let ratingSuperviewHeight:Int = Int(cell.ratingSuperview.frame.height)
        
        if (labels[(indexPath as NSIndexPath).item] != "Girgaon Beach" && cell.ratingView?.viewWithTag(1) != nil) {
            
            cell.ratingView.removeFromSuperview()
            
            for i in 0 ... 4 {
                
                let starIconButton = UIButton(frame: CGRect(x: ratingSuperviewWidth/5 * i, y: 0, width: ratingSuperviewWidth/10, height: ratingSuperviewHeight/2))
                starIconButton.setImage(UIImage(named: "star_uncheck"), for: UIControlState())
                cell.ratingSuperview.addSubview(starIconButton)
                
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return labels.count
    }
    
    func addRadiosToButtons(_ button: UIButton) -> Void {
        
        let radioInButton = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        radioInButton.image = UIImage(named: "radio_for_button")
        radioInButton.center = CGPoint(x: button.titleLabel!.frame.width/3 - 15, y: button.titleLabel!.frame.height/2 + 10)
        button.titleLabel!.addSubview(radioInButton)
        
    }
    
    func addShadowsToViews(_ myView: UIView) -> Void {
        
        myView.layer.shadowOffset = CGSize(width: 3, height: 3)
        myView.layer.shadowOpacity = 1
        myView.layer.shadowRadius = 4
        
    }
    
    func addStylesToTabs(_ myButton: UIButton) -> Void {
        
        myButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        myButton.layer.shadowOpacity = 1
        myButton.layer.shadowRadius = 4
        
    }
    func setTopNavigation(_ text: String) {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.goBack(_:)), for: .touchUpInside)
        let rightButton = UIView()
        self.title = text
        self.customNavigationBar(left: leftButton, right: rightButton)
    }
    
    
    
    func goBack(_ sender:AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }


}

class allReviewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timestampView: UIView!
    @IBOutlet weak var ratingView: UILabel!
    @IBOutlet weak var reviewTitle: UILabel!
    @IBOutlet weak var reviewCategory: UIImageView!
    @IBOutlet weak var reviewLocation: UILabel!
    @IBOutlet weak var ratingSuperview: UIView!
    
}

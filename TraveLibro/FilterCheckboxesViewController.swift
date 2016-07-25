//
//  FilterCheckboxesViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 13/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class FilterCheckboxesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let labels = ["Beach & Party", "Adventure", "Romance", "Food", "Festivals", "Shopping", "Hotels", "Countries & Cities", "Road Trips", "Vacations", "Beach & Party", "Adventure", "Romance", "Food", "Festivals", "Shopping", "Hotels", "Countries & Cities", "Road Trips", "Vacations","Beach & Party", "Adventure", "Romance", "Food", "Festivals", "Shopping", "Hotels", "Countries & Cities", "Road Trips", "Vacations", "Beach & Party", "Adventure", "Romance", "Food", "Festivals", "Shopping", "Hotels", "Countries & Cities", "Road Trips", "Vacations", "Beach & Party", "Adventure", "Romance", "Food", "Festivals", "Shopping", "Hotels", "Countries & Cities", "Road Trips", "Vacations", "Beach & Party", "Adventure", "Romance", "Food", "Festivals", "Shopping", "Hotels", "Countries & Cities", "Road Trips", "Vacations", "Beach & Party", "Adventure", "Romance", "Food", "Festivals", "Shopping", "Hotels", "Countries & Cities", "Road Trips", "Vacations", "Beach & Party", "Adventure", "Romance", "Food", "Festivals", "Shopping", "Hotels", "Countries & Cities", "Road Trips", "Vacations", "Beach & Party", "Adventure", "Romance", "Food", "Festivals", "Shopping", "Hotels", "Countries & Cities", "Road Trips", "Vacations"]
    
    @IBOutlet weak var HeadView: UIView!
    @IBOutlet weak var HeadViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    
    var whichView: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.bounds
        blurView.frame.size.height = 2000
        blurView.layer.zPosition = -1
        blurView.userInteractionEnabled = false
        self.view.addSubview(blurView)
        
//        if whichView == "Restaurants" {
//            
//        }
//        else {
//            
//        }
        
//        HeadViewHeightConstraint.constant = 100
        
        let headerView = FilterRestaurants(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: HeadView.frame.height))
        headerView.AllButton.addTarget(self, action: #selector(FilterCheckboxesViewController.FilterTypeButtonTapped(_:)), forControlEvents: .TouchUpInside)
        headerView.vegButton.addTarget(self, action: #selector(FilterCheckboxesViewController.FilterTypeButtonTapped(_:)), forControlEvents: .TouchUpInside)
        headerView.nonVegButton.addTarget(self, action: #selector(FilterCheckboxesViewController.FilterTypeButtonTapped(_:)), forControlEvents: .TouchUpInside)
        headerView.veganButton.addTarget(self, action: #selector(FilterCheckboxesViewController.FilterTypeButtonTapped(_:)), forControlEvents: .TouchUpInside)
        HeadView.addSubview(headerView)
        
        doneButton.layer.cornerRadius = 5
        doneButton.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return labels.count
        
    }
    
    func FilterTypeButtonTapped(sender: UIButton) {
        
        if sender.tag == 0 {
            
            sender.backgroundColor = mainOrangeColor
            sender.tag = 1
        }
        else {
            
            sender.backgroundColor = mainBlueColor
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CheckBoxCollectionViewCell
        cell.checkboxButton.setTitle("      " + labels[indexPath.item], forState: .Normal)
        cell.checkboxButton.addTarget(self, action: #selector(FilterCheckboxesViewController.selectCheckbox(_:)), forControlEvents: .TouchUpInside)
        
        let checkbox = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        checkbox.image = UIImage(named: "checkbox_empty")
        checkbox.contentMode = .ScaleAspectFit
        checkbox.tag = 2
        cell.checkboxButton.titleLabel?.addSubview(checkbox)
        
        return cell
        
    }
    
    func selectCheckbox(sender: UIButton) {
        
        let subviews = sender.titleLabel?.subviews
        
        for view in subviews! {
            
            if view.tag == 2 {
                
                print("removing subviews")
                view.removeFromSuperview()
                
            }
            
        }
        
        if sender.tag == 0 {
            
            let checkbox = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            checkbox.image = UIImage(named: "checkbox_fill")
            checkbox.contentMode = .ScaleAspectFit
            checkbox.tag = 2
            sender.titleLabel?.addSubview(checkbox)
            sender.tag = 1
        }
            
        else {
            
            let checkbox = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            checkbox.image = UIImage(named: "checkbox_empty")
            checkbox.contentMode = .ScaleAspectFit
            checkbox.tag = 2
            sender.titleLabel?.addSubview(checkbox)
            sender.tag = 0
            
        }
        
    }
    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        
//        print("in the selected item fn")
//        
//        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CheckBoxCollectionViewCell
//        
//    }

}

class CheckBoxCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var checkboxButton: UIButton!
    
}

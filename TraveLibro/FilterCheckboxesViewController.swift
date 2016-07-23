//
//  FilterCheckboxesViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 13/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class FilterCheckboxesViewController: UIViewController, UICollectionViewDataSource {
    
    let labels = ["Beach & Party", "Adventure", "Romance", "Food", "Festivals", "Shopping", "Hotels", "Countries & Cities", "Road Trips", "Vacations", "Beach & Party", "Adventure", "Romance", "Food", "Festivals", "Shopping", "Hotels", "Countries & Cities", "Road Trips", "Vacations","Beach & Party", "Adventure", "Romance", "Food", "Festivals", "Shopping", "Hotels", "Countries & Cities", "Road Trips", "Vacations", "Beach & Party", "Adventure", "Romance", "Food", "Festivals", "Shopping", "Hotels", "Countries & Cities", "Road Trips", "Vacations", "Beach & Party", "Adventure", "Romance", "Food", "Festivals", "Shopping", "Hotels", "Countries & Cities", "Road Trips", "Vacations", "Beach & Party", "Adventure", "Romance", "Food", "Festivals", "Shopping", "Hotels", "Countries & Cities", "Road Trips", "Vacations", "Beach & Party", "Adventure", "Romance", "Food", "Festivals", "Shopping", "Hotels", "Countries & Cities", "Road Trips", "Vacations", "Beach & Party", "Adventure", "Romance", "Food", "Festivals", "Shopping", "Hotels", "Countries & Cities", "Road Trips", "Vacations", "Beach & Party", "Adventure", "Romance", "Food", "Festivals", "Shopping", "Hotels", "Countries & Cities", "Road Trips", "Vacations"]
    
    @IBOutlet weak var HeadView: UIView!
    @IBOutlet weak var HeadViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.bounds
        blurView.frame.size.height = 2000
        blurView.layer.zPosition = -1
        self.view.addSubview(blurView)
        
        HeadViewHeightConstraint.constant = 100
        
        let headerView = FilterRestaurants(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: HeadView.frame.height))
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
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CheckBoxCollectionViewCell
        cell.checkboxButton.setTitle("      " + labels[indexPath.item], forState: .Normal)
        
        let checkbox = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        checkbox.image = UIImage(named: "checkbox_empty")
        checkbox.contentMode = .ScaleAspectFit
        cell.checkboxButton.titleLabel?.addSubview(checkbox)
        
        return cell
        
    }

}

class CheckBoxCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var checkboxButton: UIButton!
    
}

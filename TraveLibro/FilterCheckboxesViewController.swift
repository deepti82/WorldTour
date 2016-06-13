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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.bounds
        blurView.frame.size.height = 2000
        blurView.layer.zPosition = -1
        self.view.addSubview(blurView)
        
        let headerView = FilterBlogs(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 100))
        HeadView.addSubview(headerView)
        
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
        checkbox.image = UIImage(named: "radio_for_button")
        checkbox.contentMode = .ScaleAspectFit
        cell.checkboxButton.titleLabel?.addSubview(checkbox)
        
        return cell
        
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

class CheckBoxCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var checkboxButton: UIButton!
    
    
    
}

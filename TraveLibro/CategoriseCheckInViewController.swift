//
//  CategoriseCheckInViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 28/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class CategoriseCheckInViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let categories = ["Beaches", "Cinema & Theatre", "Restaurants", "Pubs & Bars", "Nature & Parks", "Sights & Landmarks", "Museums & Galleries", "Religious", "Shopping","Beaches", "Cinema & Theatre", "Restaurants","Beaches", "Cinema & Theatre", "Restaurants","Beaches", "Cinema & Theatre", "Restaurants","Beaches", "Cinema & Theatre", "Restaurants","Beaches", "Cinema & Theatre", "Restaurants","Beaches", "Cinema & Theatre", "Restaurants","Beaches", "Cinema & Theatre", "Restaurants","Beaches", "Cinema & Theatre", "Restaurants", "Restaurants"]
    let categoryImages = ["beach_checkin", "cinema_checkin", "landmarks_checkin", "nature_checkin", "pubs_checkin", "restaurant_checkin", "beach_checkin", "cinema_checkin", "landmarks_checkin", "nature_checkin", "pubs_checkin", "restaurant_checkin", "beach_checkin", "cinema_checkin", "landmarks_checkin", "nature_checkin", "pubs_checkin", "restaurant_checkin", "beach_checkin", "cinema_checkin", "landmarks_checkin", "nature_checkin", "pubs_checkin", "restaurant_checkin", "beach_checkin", "cinema_checkin", "landmarks_checkin", "nature_checkin", "pubs_checkin", "restaurant_checkin", "nature_checkin", "pubs_checkin", "restaurant_checkin", "beach_checkin", "cinema_checkin", "landmarks_checkin", "nature_checkin", "pubs_checkin", "restaurant_checkin", "nature_checkin", "pubs_checkin", "restaurant_checkin", "beach_checkin", "cinema_checkin", "landmarks_checkin", "nature_checkin", "pubs_checkin", "restaurant_checkin"]
    
    var previousItem: NSIndexPath!
    var whichView = "LL"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//       setCheckInNavigationBarItem(addCheckIn)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "close_fa"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 8, 20, 20)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(self.nextCheckIn(_:)), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRectMake(0, 8, 30, 30)
        
        self.customNavigationBar(leftButton, right: rightButton)
        
        
        if whichView == "TL" {
            
            getBackGround(self)
            
        }
       
    }
    
    func nextCheckIn(sender: UIButton) {
        
        let addCheckIn = storyboard?.instantiateViewControllerWithIdentifier("addCheckIn") as! AddCheckInViewController
        addCheckIn.whichView = self.whichView
        self.navigationController?.pushViewController(addCheckIn, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            
            previousItem = indexPath
            
        }
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! CheckInCategoryCollectionViewCell
        cell.categoryLabel.text = categories[indexPath.row]
        cell.categoryIcon.setImage(UIImage(named: categoryImages[indexPath.row]), forState: .Normal)
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! CheckInCategoryCollectionViewCell
        
        let deselectedCell = collectionView.cellForItemAtIndexPath(previousItem) as! CheckInCategoryCollectionViewCell
        deselectedCell.categoryIcon.setBackgroundImage(UIImage(named: "checkinbgwhite"), forState: .Normal)
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CheckInCategoryCollectionViewCell
        cell.categoryIcon.setBackgroundImage(UIImage(named: "checkinbggreen"), forState: .Normal)
        previousItem = indexPath
        
//        let addCheckInVC = storyboard?.instantiateViewControllerWithIdentifier("addCheckIn") as! AddCheckInViewController
//        self.navigationController?.pushViewController(addCheckInVC, animated: true)
        
    }

}


class CheckInCategoryCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var categoryIcon: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    
}

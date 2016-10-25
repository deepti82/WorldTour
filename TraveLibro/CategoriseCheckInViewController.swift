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
    
    var previousItem: IndexPath!
    var whichView = "LL"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//       setCheckInNavigationBarItem(addCheckIn)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "close_fa"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 8, width: 20, height: 20)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(self.nextCheckIn(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        
        if whichView == "TL" {
            
            getBackGround(self)
            
        }
       
    }
    
    func nextCheckIn(_ sender: UIButton) {
        
        let addCheckIn = storyboard?.instantiateViewController(withIdentifier: "addCheckIn") as! AddCheckInViewController
        addCheckIn.whichView = self.whichView
        self.navigationController?.pushViewController(addCheckIn, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath as NSIndexPath).item == 0 {
            
            previousItem = indexPath
            
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CheckInCategoryCollectionViewCell
        cell.categoryLabel.text = categories[(indexPath as NSIndexPath).row]
        cell.categoryIcon.setImage(UIImage(named: categoryImages[(indexPath as NSIndexPath).row]), for: UIControlState())
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! CheckInCategoryCollectionViewCell
        
        let deselectedCell = collectionView.cellForItem(at: previousItem) as! CheckInCategoryCollectionViewCell
        deselectedCell.categoryIcon.setBackgroundImage(UIImage(named: "checkinbgwhite"), for: UIControlState())
        
        let cell = collectionView.cellForItem(at: indexPath) as! CheckInCategoryCollectionViewCell
        cell.categoryIcon.setBackgroundImage(UIImage(named: "checkinbggreen"), for: UIControlState())
        previousItem = indexPath
        
//        let addCheckInVC = storyboard?.instantiateViewControllerWithIdentifier("addCheckIn") as! AddCheckInViewController
//        self.navigationController?.pushViewController(addCheckInVC, animated: true)
        
    }

}


class CheckInCategoryCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var categoryIcon: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    
}

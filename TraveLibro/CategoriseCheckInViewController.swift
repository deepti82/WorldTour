//
//  CategoriseCheckInViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 28/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class CategoriseCheckInViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let categories = ["Beaches", "Cinema & Theatre", "Restaurants", "Beaches", "Cinema & Theatre", "Restaurants","Beaches", "Cinema & Theatre", "Restaurants","Beaches", "Cinema & Theatre", "Restaurants","Beaches", "Cinema & Theatre", "Restaurants","Beaches", "Cinema & Theatre", "Restaurants","Beaches", "Cinema & Theatre", "Restaurants","Beaches", "Cinema & Theatre", "Restaurants","Beaches", "Cinema & Theatre", "Restaurants","Beaches", "Cinema & Theatre", "Restaurants","Beaches", "Cinema & Theatre", "Restaurants"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addCheckIn = storyboard?.instantiateViewControllerWithIdentifier("addCheckIn") as! AddCheckInViewController
        
       setCheckInNavigationBarItem(addCheckIn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! CheckInCategoryCollectionViewCell
        cell.categoryLabel.text = categories[indexPath.item]
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let addCheckInVC = storyboard?.instantiateViewControllerWithIdentifier("addCheckIn") as! AddCheckInViewController
        self.navigationController?.pushViewController(addCheckInVC, animated: true)
        
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


class CheckInCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
}
